/*
 * Runs the ORIGINAL Stardust 68k code (CODE 1) under the Musashi emulator,
 * with every Toolbox trap serviced by the same C toolbox layer the port uses.
 * Used as a reference: with STARDUST_TEST=1 both programs see the same
 * virtual clock and scripted input, so their frame logs must match.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../src/mac.h"
#include "../src/platform.h"
#include "musashi/m68k.h"

enum {
    kRamSize = 8 << 20,
    kCodeBase = 0x10000,
    kHeapBase = 0x100000,
    kStackTop = 0x7E0000,
    kA5 = 0x7F0000,
    kExitMagic = 0x0000F0, /* return address that ends emulation */
};

static uint8_t ram[kRamSize];
static uint32_t heapNext = kHeapBase;
static int exiting;

/* ------------------------------------------------------------------ */
/* Memory */

static uint32_t M(uint32_t a) { return a & (kRamSize - 1); }
unsigned int m68k_read_memory_8(unsigned int a) { return ram[M(a)]; }
unsigned int m68k_read_memory_16(unsigned int a) { return (unsigned)ram[M(a)] << 8 | ram[M(a + 1)]; }
unsigned int m68k_read_memory_32(unsigned int a) { return m68k_read_memory_16(a) << 16 | m68k_read_memory_16(a + 2); }
void m68k_write_memory_8(unsigned int a, unsigned int v) { ram[M(a)] = (uint8_t)v; }
void m68k_write_memory_16(unsigned int a, unsigned int v) { m68k_write_memory_8(a, v >> 8), m68k_write_memory_8(a + 1, v); }
void m68k_write_memory_32(unsigned int a, unsigned int v) { m68k_write_memory_16(a, v >> 16), m68k_write_memory_16(a + 2, v); }
unsigned int m68k_read_disassembler_16(unsigned int a) { return m68k_read_memory_16(a); }
unsigned int m68k_read_disassembler_32(unsigned int a) { return m68k_read_memory_32(a); }

#define R8 m68k_read_memory_8
#define R16 m68k_read_memory_16
#define R32 m68k_read_memory_32
#define W8 m68k_write_memory_8
#define W16 m68k_write_memory_16
#define W32 m68k_write_memory_32

static uint32_t Alloc(uint32_t size, int clear)
{
    uint32_t p = heapNext;
    heapNext = (heapNext + size + 15) & ~15u;
    if (clear)
        memset(&ram[p], 0, size);
    return p;
}

static uint32_t NewHandleWith(const void *data, uint32_t size)
{
    uint32_t block = Alloc(size + 4, 1);
    W32(block, size); /* size kept just before the data, for GetHandleSize */
    if (data)
        memcpy(&ram[block + 4], data, size);
    uint32_t master = Alloc(4, 1);
    W32(master, block + 4);
    return master;
}

/* ------------------------------------------------------------------ */
/* Stack access for Pascal calling conventions */

static uint32_t sp;
static uint32_t Pop16(void) { uint32_t v = R16(sp); sp += 2; return v; }
static uint32_t Pop32(void) { uint32_t v = R32(sp); sp += 4; return v; }
static int16_t PopS16(void) { return (int16_t)Pop16(); }
static Boolean PopBool(void) { Boolean b = R8(sp) != 0; sp += 2; return b; }
/* Function results live just above the arguments, so they're written after popping. */
static void Result16(uint32_t v) { W16(sp, v); }
static void Result32(uint32_t v) { W32(sp, v); }
static void ResultBool(Boolean b) { W8(sp, b ? 1 : 0); }

static Rect ReadRect(uint32_t a)
{
    Rect r = {(int16_t)R16(a), (int16_t)R16(a + 2), (int16_t)R16(a + 4), (int16_t)R16(a + 6)};
    return r;
}

static void WriteRect(uint32_t a, const Rect *r)
{
    W16(a, (uint16_t)r->top), W16(a + 2, (uint16_t)r->left), W16(a + 4, (uint16_t)r->bottom), W16(a + 6, (uint16_t)r->right);
}

static Point PointFrom(uint32_t v) { Point p = {(int16_t)(v >> 16), (int16_t)v}; return p; }

static void ReadPString(uint32_t a, char *out)
{
    int n = R8(a);
    for (int i = 0; i < n; i++)
        out[i] = (char)R8(a + 1 + i);
    out[n] = 0;
}

static void WritePString(uint32_t a, const char *s)
{
    size_t n = strlen(s);
    W8(a, (unsigned)n);
    for (size_t i = 0; i < n; i++)
        W8(a + 1 + (uint32_t)i, (uint8_t)s[i]);
}

/* ------------------------------------------------------------------ */
/* Native objects behind 68k addresses */

enum { kPort, kRgn, kPic, kDialog, kChan, kMenu, kSnd };
typedef struct { uint32_t addr; int kind; void *obj; int id; } Obj;
static Obj objs[512];
static int nobjs;

static void Bind(uint32_t addr, int kind, void *obj, int id)
{
    for (int i = 0; i < nobjs; i++)
        if (objs[i].addr == addr) {
            objs[i] = (Obj){addr, kind, obj, id};
            return;
        }
    objs[nobjs++] = (Obj){addr, kind, obj, id};
}

static Obj *Find(uint32_t addr, int kind)
{
    for (int i = 0; i < nobjs; i++)
        if (objs[i].addr == addr && objs[i].kind == kind)
            return &objs[i];
    return NULL;
}

static void *Native(uint32_t addr, int kind)
{
    Obj *o = Find(addr, kind);
    return o ? o->obj : NULL;
}

static uint32_t AddrOf(void *obj)
{
    for (int i = 0; i < nobjs; i++)
        if (objs[i].obj == obj)
            return objs[i].addr;
    return 0;
}

/* A BitMap* handed to CopyBits is &port->portBits, two bytes into the port. */
static GWorldPtr BitsPort(uint32_t bits) { return Native(bits - 2, kPort); }

static RgnHandle Rgn(uint32_t h)
{
    if (!h)
        return NULL;
    RgnHandle r = Native(h, kRgn);
    if (!r)
        fprintf(stderr, "unknown region %08x\n", h);
    return r;
}

static uint32_t NewPort(GWorldPtr gw)
{
    uint32_t p = Alloc(0x6C, 1);
    Bind(p, kPort, gw, 0);
    return p;
}

/* ------------------------------------------------------------------ */
/* Resources */

static uint32_t GetResourceTrap(uint32_t type, int id)
{
    char name[32];
    long size;
    unsigned char *data;
    switch (type) {
    case 0x54455854: /* 'TEXT' */
        data = (unsigned char *)GetTextResource(id);
        if (!data)
            return 0;
        size = (long)strlen((char *)data);
        for (long i = 0; i < size; i++)
            if (data[i] == '\n')
                data[i] = '\r';
        break;
    case 0x4C535020: /* 'LSP ': THINK runtime data, only read on a runtime error */
        (void)name;
        data = calloc(1, 18), size = 18;
        break;
    case 0x736E6420: { /* 'snd ' */
        uint32_t h = NewHandleWith(NULL, 4);
        Bind(h, kSnd, NULL, id);
        return h;
    }
    default: /* 'ZERO', 'DATA', 'DREL': no global initialization to do */
        return 0;
    }
    uint32_t h = NewHandleWith(data, (uint32_t)size);
    free(data);
    return h;
}

/* ------------------------------------------------------------------ */
/* Dialogs: user item procs are 68k code; the only one (export 6, the
 * default-button outline) is drawn natively here. */

static void OutlineDefaultButton(DialogPtr d, int item)
{
    (void)item;
    Rect r;
    GetDialogItemRect(d, 1, &r);
    GWorldPtr save = thePort;
    SetGWorld(DialogPort(d));
    PenNormal();
    InsetRect(&r, -4, -4);
    FrameRoundRect(&r, 16, 16);
    int corner = (r.bottom - r.top) / 2 + 2;
    PenSize(3, 3);
    FrameRoundRect(&r, corner, corner);
    PenNormal();
    SetGWorld(save);
}

/* ------------------------------------------------------------------ */
/* Traps */

static uint32_t qdGlobals; /* address of thePort */
static GWorldPtr currentPortNative;

static void SetCurrent(uint32_t port)
{
    GWorldPtr gw = Native(port, kPort);
    if (gw)
        SetGWorld(gw);
    if (qdGlobals)
        W32(qdGlobals, port);
}

static void QDExtensions(uint32_t selector)
{
    switch (selector) {
    case 0x160000:   /* NewGWorld */
    case 0x160003: { /* UpdateGWorld */
        Pop32();                    /* flags */
        Pop32();                    /* gdh */
        Pop32();                    /* ctab */
        Rect r = ReadRect(Pop32()); /* bounds */
        Pop16();                    /* depth */
        uint32_t ref = Pop32();
        uint32_t port = selector == 0x160003 ? R32(ref) : 0;
        GWorldPtr old = port ? Native(port, kPort) : NULL;
        GWorldPtr gw = NewGWorld(r.right - r.left, r.bottom - r.top);
        if (old) {
            if (old->w == gw->w && old->h == gw->h)
                memcpy(gw->px, old->px, (size_t)gw->w * gw->h * 4);
            if (thePort == old)
                SetGWorld(gw);
            Bind(port, kPort, gw, 0);
            DisposeGWorld(old);
        } else {
            port = NewPort(gw);
        }
        W32(ref, port);
        if (selector == 0x160003)
            Result32(0);
        else
            Result16(0);
        break;
    }
    case 0x40001: /* LockPixels */
        Pop32();
        ResultBool(true);
        break;
    case 0x40017: { /* GetGWorldPixMap */
        uint32_t port = Pop32();
        Result32(port + 2);
        break;
    }
    case 0x40004: { /* DisposeGWorld */
        uint32_t port = Pop32();
        Obj *o = Find(port, kPort);
        if (o) {
            DisposeGWorld(o->obj);
            o->kind = -1;
        }
        break;
    }
    case 0x80005: { /* GetGWorld */
        uint32_t gdh = Pop32(), port = Pop32();
        W32(port, AddrOf(thePort));
        W32(gdh, 0x00EE0000);
        break;
    }
    case 0x80006: { /* SetGWorld */
        Pop32();
        SetCurrent(Pop32());
        break;
    }
    default:
        fprintf(stderr, "QDExtensions %08x\n", selector);
        exit(1);
    }
}

static void ToolboxTrap(uint32_t pc, int trap)
{
    (void)pc;
    sp = m68k_get_reg(NULL, M68K_REG_A7);
    switch (trap) {
    /* --- startup --- */
    case 0x6E: /* InitGraf */
        qdGlobals = Pop32();
        W32(kA5, qdGlobals);
        W16(qdGlobals - 110, 640); /* screenBits.bounds.right */
        W16(qdGlobals - 112, 480);
        W32(qdGlobals - 126, 1); /* randSeed */
        for (int i = 0; i < 8; i++)
            W8(qdGlobals - 16 + i, 0xFF), W8(qdGlobals - 24 + i, i & 1 ? 0x55 : 0xAA);
        break;
    case 0xFE: case 0x112: case 0x130: case 0x1CC: case 0x050: /* InitFonts, InitWindows, InitMenus, TEInit, InitCursor */
        break;
    case 0x52: HideCursor(); break;
    case 0x53: ShowCursor(); break;
    case 0x1EB: Pop16(); Pop32(); break; /* Pack4 (FP68K SetEnvironment) */
    case 0x1F4: exiting = 1; break;      /* ExitToShell */
    case 0x3FF: { /* DebugStr */
        char s[256];
        ReadPString(Pop32(), s);
        fprintf(stderr, "DebugStr: %s\n", s);
        exiting = 1;
        break;
    }

    /* --- windows and ports --- */
    case 0x246: { /* GetNewCWindow */
        Pop32(), Pop32(), Pop16();
        Result32(Alloc(0x9C, 1));
        break;
    }
    case 0x200: { /* OpenCPort */
        uint32_t port = Pop32();
        Bind(port, kPort, ScreenPort(), 0);
        break;
    }
    case 0x73: SetCurrent(Pop32()); break; /* SetPort */
    case 0x74: W32(Pop32(), AddrOf(thePort)); break; /* GetPort */
    case 0x124: Result32(AddrOf(ScreenPort())); break; /* FrontWindow */
    case 0x12C: { /* FindWindow */
        uint32_t win = Pop32();
        Point p = PointFrom(Pop32());
        W32(win, AddrOf(ScreenPort()));
        Result16((uint16_t)FindWindow(p));
        break;
    }
    case 0x11F: Pop32(); break; /* SelectWindow */
    case 0x125: Pop32(), Pop32(), Pop32(); break; /* DragWindow */
    case 0x1B3: Pop32(), Pop32(); break; /* SystemClick */
    case 0x122: case 0x123: case 0x114: Pop32(); break; /* BeginUpdate, EndUpdate, DisposeWindow */

    /* --- QuickDraw --- */
    case 0x31D: QDExtensions(m68k_get_reg(NULL, M68K_REG_D0)); break;
    case 0x61: { /* Random */
        randSeed = (int32_t)R32(qdGlobals - 126);
        int16_t r = Random();
        W32(qdGlobals - 126, (uint32_t)randSeed);
        Result16((uint16_t)r);
        break;
    }
    case 0x62: ForeColor((int)Pop32()); break;
    case 0x63: BackColor((int)Pop32()); break;
    case 0x214: { /* RGBForeColor */
        uint32_t a = Pop32();
        RGBColor c = {(uint16_t)R16(a), (uint16_t)R16(a + 2), (uint16_t)R16(a + 4)};
        RGBForeColor(&c);
        break;
    }
    case 0x216: { /* SetCPixel */
        uint32_t a = Pop32();
        int v = PopS16(), h = PopS16();
        RGBColor c = {(uint16_t)R16(a), (uint16_t)R16(a + 2), (uint16_t)R16(a + 4)};
        SetCPixel(h, v, &c);
        break;
    }
    case 0xA7: { /* SetRect */
        int b = PopS16(), r = PopS16(), t = PopS16(), l = PopS16();
        uint32_t a = Pop32();
        Rect rr;
        SetRect(&rr, l, t, r, b);
        WriteRect(a, &rr);
        break;
    }
    case 0xA8: case 0xA9: { /* OffsetRect, InsetRect */
        int dv = PopS16(), dh = PopS16();
        uint32_t a = Pop32();
        Rect r = ReadRect(a);
        if (trap == 0xA8)
            OffsetRect(&r, dh, dv);
        else
            InsetRect(&r, dh, dv);
        WriteRect(a, &r);
        break;
    }
    case 0x80: { /* SetPt */
        int v = PopS16(), h = PopS16();
        uint32_t a = Pop32();
        W16(a, (uint16_t)v), W16(a + 2, (uint16_t)h);
        break;
    }
    case 0x7E: { /* AddPt */
        uint32_t dst = Pop32();
        Point s = PointFrom(Pop32());
        W16(dst, (uint16_t)((int16_t)R16(dst) + s.v));
        W16(dst + 2, (uint16_t)((int16_t)R16(dst + 2) + s.h));
        break;
    }
    case 0xA2: { Rect r = ReadRect(Pop32()); PaintRect(&r); break; }
    case 0xA3: { Rect r = ReadRect(Pop32()); EraseRect(&r); break; }
    case 0xA4: { Rect r = ReadRect(Pop32()); InvertRect(&r); break; }
    case 0xBA: { Rect r = ReadRect(Pop32()); InvertOval(&r); break; }
    case 0xB0: { /* FrameRoundRect */
        int oh = PopS16(), ow = PopS16();
        Rect r = ReadRect(Pop32());
        FrameRoundRect(&r, ow, oh);
        break;
    }
    case 0x93: { int v = PopS16(), h = PopS16(); MoveTo(h, v); break; }
    case 0x91: { int v = PopS16(), h = PopS16(); LineTo(h, v); break; }
    case 0x9E: PenNormal(); break;
    case 0x9B: { int h = PopS16(), w = PopS16(); PenSize(w, h); break; }
    case 0x9D: { /* PenPat */
        uint32_t a = Pop32();
        thePort->penGray = R8(a) != 0xFF;
        break;
    }
    case 0x98: { /* GetPenState */
        uint32_t a = Pop32();
        W16(a, (uint16_t)thePort->pen.v), W16(a + 2, (uint16_t)thePort->pen.h);
        W16(a + 4, (uint16_t)thePort->penH), W16(a + 6, (uint16_t)thePort->penW);
        W16(a + 8, 8);
        W8(a + 10, thePort->penGray ? 0xAA : 0xFF);
        break;
    }
    case 0x99: { /* SetPenState */
        uint32_t a = Pop32();
        thePort->pen.v = (int16_t)R16(a), thePort->pen.h = (int16_t)R16(a + 2);
        thePort->penH = (int16_t)R16(a + 4), thePort->penW = (int16_t)R16(a + 6);
        thePort->penGray = R8(a + 10) != 0xFF;
        break;
    }
    case 0xEC: { /* CopyBits */
        RgnHandle mask = Rgn(Pop32());
        int mode = PopS16();
        Rect dr = ReadRect(Pop32()), sr = ReadRect(Pop32());
        GWorldPtr dst = BitsPort(Pop32()), src = BitsPort(Pop32());
        if (src && dst)
            CopyBits(src, dst, &sr, &dr, mode, mask);
        else
            fprintf(stderr, "CopyBits: unknown port\n");
        break;
    }
    case 0xF6: { /* DrawPicture */
        Rect r = ReadRect(Pop32());
        PicHandle pic = Native(Pop32(), kPic);
        if (pic)
            DrawPicture(pic, &r);
        break;
    }
    case 0x1BC: { /* GetPicture */
        int id = PopS16();
        PicHandle pic = GetPicture(id);
        uint32_t h = 0;
        if (pic) {
            uint8_t hdr[10] = {0};
            Rect f = PictureFrame(pic);
            hdr[2] = (uint8_t)(f.top >> 8), hdr[3] = (uint8_t)f.top, hdr[4] = (uint8_t)(f.left >> 8), hdr[5] = (uint8_t)f.left;
            hdr[6] = (uint8_t)(f.bottom >> 8), hdr[7] = (uint8_t)f.bottom, hdr[8] = (uint8_t)(f.right >> 8), hdr[9] = (uint8_t)f.right;
            h = NewHandleWith(hdr, 10);
            Bind(h, kPic, pic, id);
        }
        Result32(h);
        break;
    }

    /* --- regions --- */
    case 0xD8: { uint32_t h = NewHandleWith(NULL, 10); Bind(h, kRgn, NewRgn(), 0); Result32(h); break; }
    case 0xDC: { RgnHandle d = Rgn(Pop32()), s = Rgn(Pop32()); CopyRgn(s, d); break; }
    case 0xDD: SetEmptyRgn(Rgn(Pop32())); break;
    case 0xDE: { int b = PopS16(), r = PopS16(), t = PopS16(), l = PopS16(); SetRectRgn(Rgn(Pop32()), l, t, r, b); break; }
    case 0xDF: { Rect r = ReadRect(Pop32()); RectRgn(Rgn(Pop32()), &r); break; }
    case 0xE0: { int dv = PopS16(), dh = PopS16(); OffsetRgn(Rgn(Pop32()), dh, dv); break; }
    case 0xE5: { RgnHandle d = Rgn(Pop32()), b = Rgn(Pop32()), a = Rgn(Pop32()); UnionRgn(a, b, d); break; }
    case 0xE6: { RgnHandle d = Rgn(Pop32()), b = Rgn(Pop32()), a = Rgn(Pop32()); DiffRgn(a, b, d); break; }
    case 0xE8: { RgnHandle r = Rgn(Pop32()); Point p = PointFrom(Pop32()); ResultBool(PtInRgn(p, r)); break; }
    case 0xD7: { /* BitMapToRegion */
        GWorldPtr gw = BitsPort(Pop32());
        BitMapToRegion(Rgn(Pop32()), gw);
        Result16(0);
        break;
    }
    case 0x7A: GetClip(Rgn(Pop32())); break;
    case 0x79: SetClip(Rgn(Pop32())); break;

    /* --- text --- */
    case 0x87: TextFont(PopS16()); break;
    case 0x88: TextFace(Pop16() & 0xFF); break;
    case 0x89: TextMode(PopS16()); break;
    case 0x8A: TextSize(PopS16()); break;
    case 0x8E: Pop32(); break; /* SpaceExtra */
    case 0x8C: { char s[256]; ReadPString(Pop32(), s); Result16((uint16_t)StringWidth(s)); break; }
    case 0x84: { char s[256]; ReadPString(Pop32(), s); DrawString(s); break; }

    /* --- events --- */
    case 0x175: Result32(TickCount()); break;
    case 0x174: ResultBool(Button()); break;
    case 0x176: { /* GetKeys */
        uint32_t a = Pop32();
        KeyMap k;
        GetKeys(k);
        for (int i = 0; i < 16; i++)
            W8(a + (uint32_t)i, k[i]);
        break;
    }
    case 0x170: { /* GetNextEvent */
        uint32_t a = Pop32();
        int mask = PopS16();
        EventRecord ev;
        Boolean got = GetNextEvent(mask, &ev);
        W16(a, (uint16_t)ev.what), W32(a + 2, ev.message), W32(a + 6, ev.when);
        W16(a + 10, (uint16_t)ev.where.v), W16(a + 12, (uint16_t)ev.where.h), W16(a + 14, ev.modifiers);
        ResultBool(got);
        break;
    }

    /* --- menus --- */
    case 0x134: case 0x14D: break; /* ClearMenuBar; AppendResMenu below */
    case 0x1C0: Pop16(); Result32(NewHandleWith(NULL, 4)); break; /* GetNewMBar */
    case 0x13C: Pop32(); InstallMenuBar(); break; /* SetMenuBar */
    case 0x149: { /* GetMenuHandle */
        int id = PopS16();
        uint32_t h = 0xE0000000u | (uint32_t)id;
        Bind(h, kMenu, GetMenuHandle(id), id);
        Result32(h);
        break;
    }
    case 0x139: case 0x13A: { /* EnableItem, DisableItem */
        int item = PopS16();
        MenuHandle m = Native(Pop32(), kMenu);
        if (trap == 0x139)
            EnableItem(m, item);
        else
            DisableItem(m, item);
        break;
    }
    case 0x145: { Boolean c = PopBool(); int item = PopS16(); CheckItem(Native(Pop32(), kMenu), item, c); break; }
    case 0x137: DrawMenuBar(); break;
    case 0x138: HiliteMenu(PopS16()); break;
    case 0x13D: { Point p = PointFrom(Pop32()); Result32((uint32_t)MenuSelect(p)); break; }
    case 0x13E: { int ch = Pop16() & 0xFF; Result32((uint32_t)MenuKey((char)ch)); break; }
    case 0x146: { uint32_t s = Pop32(); Pop16(); Pop32(); WritePString(s, ""); break; } /* GetItem */
    case 0x1B6: Pop32(); Result16(0); break; /* OpenDeskAcc */

    /* --- dialogs --- */
    case 0x17C: { /* GetNewDialog */
        Pop32(), Pop32();
        int id = PopS16();
        DialogPtr d = GetNewDialog(id);
        uint32_t a = Alloc(0xAA, 1);
        Bind(a, kDialog, d, id);
        Result32(a);
        break;
    }
    case 0x181: DrawDialog(Native(Pop32(), kDialog)); break;
    case 0x183: DisposeDialog(Native(Pop32(), kDialog)); break;
    case 0x191: { uint32_t item = Pop32(); Pop32(); int hit = 0; ModalDialog(&hit); W16(item, (uint16_t)hit); break; }
    case 0x18D: { /* GetDItem */
        uint32_t box = Pop32(), hdl = Pop32(), type = Pop32();
        int item = PopS16();
        uint32_t d = Pop32();
        Rect r;
        GetDialogItemRect(Native(d, kDialog), item, &r);
        WriteRect(box, &r);
        W16(type, 0);
        W32(hdl, (d << 8) | (uint32_t)item); /* opaque: dialog address and item */
        break;
    }
    case 0x18E: { /* SetDItem */
        Pop32();
        uint32_t proc = Pop32();
        Pop16();
        int item = PopS16();
        DialogPtr d = Native(Pop32(), kDialog);
        if (proc == kA5 + 0x52)
            SetDialogItemProc(d, item, OutlineDefaultButton);
        break;
    }
    case 0x190: { /* GetIText */
        uint32_t s = Pop32(), h = Pop32();
        char text[256];
        GetDialogItemText(Native(h >> 8, kDialog), (int)(h & 0xFF), text, sizeof text);
        WritePString(s, text);
        break;
    }

    /* --- resources --- */
    case 0x1A0: { int id = PopS16(); uint32_t type = Pop32(); Result32(GetResourceTrap(type, id)); break; }
    case 0x1A3: Pop32(); break; /* ReleaseResource */
    case 0x1A4: Pop32(); Result16(0); break; /* HomeResFile */

    /* --- sound --- */
    case 0x007: { /* SndNewChannel */
        Pop32(), Pop32(), Pop16();
        uint32_t ref = Pop32();
        uint32_t chan = Alloc(0x40, 1);
        Bind(chan, kChan, SndNewChannel(), 0);
        W32(ref, chan);
        Result16(0);
        break;
    }
    case 0x005: { /* SndPlay */
        Boolean async = PopBool();
        Obj *snd = Find(Pop32(), kSnd);
        SndChannelPtr chan = Native(Pop32(), kChan);
        if (snd)
            SndPlay(chan, snd->id, async);
        Result16(0);
        break;
    }
    case 0x001: { PopBool(); SndDisposeChannel(Native(Pop32(), kChan)); Result16(0); break; }
    case 0x000: { /* SoundDispatch: SndChannelStatus */
        uint32_t status = Pop32();
        Pop16();
        SndChannelPtr chan = Native(Pop32(), kChan);
        W8(status + 12, SndChannelBusy(chan) ? 1 : 0);
        Result16(0);
        break;
    }

    default:
        fprintf(stderr, "unimplemented toolbox trap A%03X at %06x\n", 0x800 | trap, pc);
        exit(1);
    }
    m68k_set_reg(M68K_REG_A7, sp);
}

static void OSTrap(uint32_t pc, int word)
{
    int trap = word & 0xFF;
    uint32_t d0 = m68k_get_reg(NULL, M68K_REG_D0), a0 = m68k_get_reg(NULL, M68K_REG_A0);
    switch (trap) {
    case 0x1E: { /* NewPtr / NewPtrClear */
        uint32_t p = Alloc(d0, 1);
        m68k_set_reg(M68K_REG_A0, p);
        m68k_set_reg(M68K_REG_D0, 0);
        break;
    }
    case 0x25: m68k_set_reg(M68K_REG_D0, R32(R32(a0) - 4)); break; /* GetHandleSize */
    case 0x36: case 0x63: m68k_set_reg(M68K_REG_D0, 0); break; /* MoreMasters, MaxApplZone */
    case 0x32: FlushEvents((int)(d0 & 0xFFFF), (int)(d0 >> 16)); m68k_set_reg(M68K_REG_D0, 0); break;
    case 0x31: { /* GetOSEvent */
        EventRecord ev;
        Boolean got = GetOSEvent((int)(d0 & 0xFFFF), &ev);
        W16(a0, (uint16_t)ev.what), W32(a0 + 2, ev.message), W32(a0 + 6, ev.when);
        W16(a0 + 10, (uint16_t)ev.where.v), W16(a0 + 12, (uint16_t)ev.where.h), W16(a0 + 14, ev.modifiers);
        m68k_set_reg(M68K_REG_D0, got ? 0 : 0xFFFFFFFF);
        break;
    }
    default:
        fprintf(stderr, "unimplemented OS trap %04X at %06x\n", word, pc);
        exit(1);
    }
}

void emu_instr_hook(unsigned int pc)
{
    for (;;) {
        if (pc == kExitMagic || exiting) {
            exiting = 1;
            m68k_end_timeslice();
            return;
        }
        uint32_t word = R16(pc);
        if ((word & 0xF000) != 0xA000)
            return;
        pc += 2;
        m68k_set_reg(M68K_REG_PC, pc);
        if (word & 0x0800) {
            ToolboxTrap(pc - 2, (int)(word & 0x3FF));
            if (word & 0x0400) { /* auto-pop: return to the glue's caller */
                uint32_t a7 = m68k_get_reg(NULL, M68K_REG_A7);
                pc = R32(a7);
                m68k_set_reg(M68K_REG_A7, a7 + 4);
                m68k_set_reg(M68K_REG_PC, pc);
            }
        } else {
            OSTrap(pc - 2, (int)word);
        }
        pc = m68k_get_reg(NULL, M68K_REG_PC);
    }
}

int main(int argc, char **argv)
{
    const char *codePath = argc > 1 ? argv[1] : "../extracted/Stardust 1.1.app_CODE_1_Main.bin";
    FILE *f = fopen(codePath, "rb");
    if (!f) {
        fprintf(stderr, "usage: stardust-orig [CODE_1.bin]\n");
        return 1;
    }
    size_t n = fread(&ram[kCodeBase - 4], 1, 0x10000, f);
    fclose(f);
    fprintf(stderr, "loaded %zu bytes of CODE 1\n", n);

    /* Jump table entries (loaded form: JMP abs.L) at A5+0x22 + 8*i. */
    static const uint32_t exports[] = {0x5DA8, 0x0, 0x164, 0x226, 0x27A, 0x5DA8, 0xF12};
    for (int i = 0; i < 7; i++) {
        W16(kA5 + 0x20 + 8 * (uint32_t)i, 1);
        W16(kA5 + 0x22 + 8 * (uint32_t)i, 0x4EF9);
        W32(kA5 + 0x24 + 8 * (uint32_t)i, kCodeBase + exports[i]);
    }
    W8(0x260, 7); /* SdVolume */

    if (PlatformInit() != 0)
        return 1;
    m68k_init();
    m68k_set_cpu_type(M68K_CPU_TYPE_68020);
    m68k_pulse_reset();
    m68k_set_reg(M68K_REG_A5, kA5);
    m68k_set_reg(M68K_REG_A7, kStackTop - 4);
    W32(kStackTop - 4, kExitMagic);
    m68k_set_reg(M68K_REG_PC, kA5 + 0x22);
    m68k_set_reg(M68K_REG_SR, 0x2000);
    while (!exiting)
        m68k_execute(100000);
    ExitToShell();
    return 0;
}
