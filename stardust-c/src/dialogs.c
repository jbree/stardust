/* Dialog Manager subset for DLOG/DITL 128-131. */
#include <stdlib.h>
#include <string.h>

#include "mac.h"
#include "platform.h"

enum { kUser = 0, kButton = 4, kStatic = 8, kEdit = 16, kIcon = 32, kPicture = 64 };

typedef struct {
    int type;
    Boolean enabled;
    Rect r;
    const char *text;
    int resID;
} ItemDef;

typedef struct {
    int id;
    Rect bounds;
    uint32_t content, frame;
    int nitems;
    ItemDef items[7];
} DialogDef;

/* DLOG bounds, dctb colors and DITL items, transcribed from the resources. */
static const DialogDef defs[] = {
    {128, {104, 170, 311, 470}, 0x000000, 0xEE0000, 1, {{kPicture, true, {3, 3, 205, 296}, NULL, 127}}},
    {129, {112, 203, 201, 437}, 0xFFFFFF, 0xEE0000, 5,
     {{kButton, true, {63, 169, 83, 227}, "OK", 0},
      {kButton, true, {63, 94, 83, 152}, "Cancel", 0},
      {kStatic, false, {7, 53, 39, 222}, "Are you sure you want to end this game?", 0},
      {kIcon, false, {7, 7, 39, 39}, NULL, 128},
      {kUser, false, {57, 163, 89, 283}, NULL, 0}}},
    {130, {112, 176, 238, 462}, 0xFFFFFF, 0xEE0000, 7,
     {{kButton, true, {99, 205, 119, 279}, "OK", 0},
      {kButton, true, {99, 109, 119, 183}, "Cancel", 0},
      {kEdit, true, {52, 10, 67, 276}, "", 0},
      {kStatic, false, {7, 51, 39, 275}, "Please enter the password of the level where you want to begin.", 0},
      {kIcon, true, {7, 7, 39, 39}, NULL, 128},
      {kUser, true, {93, 199, 125, 285}, NULL, 0},
      {kStatic, false, {74, 22, 90, 261}, "(be sure to use capital letters only)", 0}}},
    {131, {72, 208, 192, 447}, 0x888888, 0x000000, 2,
     {{kIcon, true, {10, 101, 42, 133}, NULL, 129},
      {kStatic, true, {84, 23, 101, 217}, "YOUR PASSWORD IS NOT VALID.", 0}}},
};

struct Dialog {
    const DialogDef *def;
    GWorldPtr port;
    UserItemProc procs[8];
    char edit[256];
    Rect saveRect;
    uint32_t *saved;
};

static DialogPtr front;

static uint32_t *Pix(GWorldPtr p, int h, int v) { return &p->px[v * p->w + h]; }

GWorldPtr DialogPort(DialogPtr d) { return d->port; }

static Rect FrameRectOf(DialogPtr d)
{
    Rect r = d->def->bounds;
    InsetRect(&r, -8, -8);
    return r;
}

/* Copy the dialog's local port onto the screen. */
static void Flush(DialogPtr d)
{
    GWorldPtr s = ScreenPort();
    for (int y = 0; y < d->port->h; y++)
        for (int x = 0; x < d->port->w; x++) {
            int sx = d->def->bounds.left + x, sy = d->def->bounds.top + y;
            if (sx >= 0 && sy >= 0 && sx < s->w && sy < s->h)
                *Pix(s, sx, sy) = *Pix(d->port, x, y);
        }
    ScreenDirty();
}

static void DrawFrame(DialogPtr d)
{
    GWorldPtr s = ScreenPort(), save = thePort;
    Rect outer = FrameRectOf(d);
    for (int y = outer.top; y < outer.bottom; y++)
        for (int x = outer.left; x < outer.right; x++) {
            if (x < 0 || y < 0 || x >= s->w || y >= s->h)
                continue;
            int e = 99;
            e = x - outer.left < e ? x - outer.left : e;
            e = y - outer.top < e ? y - outer.top : e;
            e = outer.right - 1 - x < e ? outer.right - 1 - x : e;
            e = outer.bottom - 1 - y < e ? outer.bottom - 1 - y : e;
            *Pix(s, x, y) = (e == 0 || (e >= 3 && e <= 5)) ? d->def->frame : d->def->content;
        }
    ScreenDirty();
    SetGWorld(save);
}

/* Word-wrapped static text, like TextBox with left justification. */
static void DrawWrapped(const char *text, const Rect *r)
{
    char line[256];
    int v = r->top + 12;
    const char *p = text;
    while (*p) {
        int n = 0, lastBreak = -1;
        while (p[n]) {
            memcpy(line, p, (size_t)n + 1);
            line[n + 1] = 0;
            if (StringWidth(line) > r->right - r->left && lastBreak > 0)
                break;
            if (p[n] == ' ')
                lastBreak = n;
            n++;
        }
        int len = p[n] ? lastBreak : n;
        memcpy(line, p, (size_t)len);
        line[len] = 0;
        MoveTo(r->left, v);
        DrawString(line);
        p += len;
        while (*p == ' ')
            p++;
        v += 16;
    }
}

static void DrawIcon(int id, const Rect *r)
{
    PicHandle pic = GetIconPicture(id);
    if (pic) {
        DrawPicture(pic, r);
        ReleasePicture(pic);
    }
}

static void DrawButton(const ItemDef *it, Boolean pressed)
{
    Rect r = it->r;
    EraseRect(&r);
    PenNormal();
    FrameRoundRect(&r, 16, 16);
    int w = StringWidth(it->text);
    MoveTo((r.left + r.right - w) / 2, r.top + 14);
    DrawString(it->text);
    if (pressed) {
        Rect in = r;
        InsetRect(&in, 1, 1);
        InvertRect(&in);
    }
}

static void DrawEdit(DialogPtr d, const ItemDef *it)
{
    Rect r = it->r;
    InsetRect(&r, -3, -3);
    EraseRect(&r);
    FrameRect(&r);
    MoveTo(it->r.left, it->r.top + 12);
    DrawString(d->edit);
    /* caret */
    int x = it->r.left + StringWidth(d->edit);
    MoveTo(x, it->r.top);
    LineTo(x, it->r.bottom - 2);
}

void DrawDialog(DialogPtr d)
{
    GWorldPtr save = thePort;
    DrawFrame(d);
    SetGWorld(d->port);
    TextFont(0), TextSize(12), TextFace(0);
    ForeColor(blackColor), BackColor(whiteColor);
    for (int i = 0; i < d->port->w * d->port->h; i++)
        d->port->px[i] = d->def->content;
    for (int i = 0; i < d->def->nitems; i++) {
        const ItemDef *it = &d->def->items[i];
        switch (it->type) {
        case kButton: DrawButton(it, false); break;
        case kStatic: DrawWrapped(it->text, &it->r); break;
        case kEdit: DrawEdit(d, it); break;
        case kIcon: DrawIcon(it->resID, &it->r); break;
        case kPicture: {
            PicHandle pic = GetPicture(it->resID);
            if (pic) {
                DrawPicture(pic, &it->r);
                ReleasePicture(pic);
            }
            break;
        }
        case kUser:
            if (d->procs[i + 1]) {
                d->procs[i + 1](d, i + 1);
                SetGWorld(d->port);
            }
            break;
        }
    }
    Flush(d);
    SetGWorld(save);
}

DialogPtr GetNewDialog(int id)
{
    const DialogDef *def = NULL;
    for (size_t i = 0; i < sizeof defs / sizeof *defs; i++)
        if (defs[i].id == id)
            def = &defs[i];
    if (!def)
        return NULL;
    DialogPtr d = calloc(1, sizeof *d);
    d->def = def;
    d->port = NewGWorld(def->bounds.right - def->bounds.left, def->bounds.bottom - def->bounds.top);
    GWorldPtr s = ScreenPort();
    d->saveRect = FrameRectOf(d);
    int w = d->saveRect.right - d->saveRect.left, h = d->saveRect.bottom - d->saveRect.top;
    d->saved = malloc((size_t)w * h * 4);
    for (int y = 0; y < h; y++)
        for (int x = 0; x < w; x++) {
            int sx = d->saveRect.left + x, sy = d->saveRect.top + y;
            d->saved[y * w + x] = (sx >= 0 && sy >= 0 && sx < s->w && sy < s->h) ? *Pix(s, sx, sy) : 0;
        }
    front = d;
    DrawDialog(d);
    return d;
}

void DisposeDialog(DialogPtr d)
{
    GWorldPtr s = ScreenPort();
    int w = d->saveRect.right - d->saveRect.left, h = d->saveRect.bottom - d->saveRect.top;
    for (int y = 0; y < h; y++)
        for (int x = 0; x < w; x++) {
            int sx = d->saveRect.left + x, sy = d->saveRect.top + y;
            if (sx >= 0 && sy >= 0 && sx < s->w && sy < s->h)
                *Pix(s, sx, sy) = d->saved[y * w + x];
        }
    ScreenDirty();
    free(d->saved);
    DisposeGWorld(d->port);
    if (front == d)
        front = NULL;
    free(d);
}

void GetDialogItemRect(DialogPtr d, int item, Rect *r) { *r = d->def->items[item - 1].r; }

void SetDialogItemProc(DialogPtr d, int item, UserItemProc proc)
{
    d->procs[item] = proc;
    DrawDialog(d);
}

void GetDialogItemText(DialogPtr d, int item, char *out, int outSize)
{
    (void)item;
    strncpy(out, d->edit, (size_t)outSize - 1);
    out[outSize - 1] = 0;
}

static int EditItem(DialogPtr d)
{
    for (int i = 0; i < d->def->nitems; i++)
        if (d->def->items[i].type == kEdit)
            return i;
    return -1;
}

static void Redraw(DialogPtr d, int i, Boolean pressed)
{
    GWorldPtr save = thePort;
    SetGWorld(d->port);
    TextFont(0), TextSize(12), TextFace(0);
    ForeColor(blackColor), BackColor(whiteColor);
    if (d->def->items[i].type == kButton)
        DrawButton(&d->def->items[i], pressed);
    else
        DrawEdit(d, &d->def->items[i]);
    Flush(d);
    SetGWorld(save);
}

/* Track a click in a button the way TrackControl does. */
static Boolean TrackButton(DialogPtr d, int i)
{
    Rect r = d->def->items[i].r;
    OffsetRect(&r, d->def->bounds.left, d->def->bounds.top);
    Boolean in = true, was = false;
    do {
        Point p;
        GetMouse(&p);
        in = PtInRect(p, &r);
        if (in != was)
            Redraw(d, i, in), was = in;
        PlatformIdle();
    } while (Button());
    Redraw(d, i, false);
    return in;
}

void ModalDialog(int *itemHit)
{
    DialogPtr d = front;
    for (;;) {
        EventRecord ev;
        if (!GetNextEvent(everyEvent, &ev))
            continue;
        if (ev.what == mouseDown) {
            for (int i = 0; i < d->def->nitems; i++) {
                const ItemDef *it = &d->def->items[i];
                Rect r = it->r;
                OffsetRect(&r, d->def->bounds.left, d->def->bounds.top);
                if (!it->enabled || !PtInRect(ev.where, &r))
                    continue;
                if (it->type == kButton && !TrackButton(d, i))
                    break;
                if (it->type == kEdit)
                    break;
                *itemHit = i + 1;
                return;
            }
        } else if (ev.what == keyDown || ev.what == autoKey) {
            int ch = (int)(ev.message & charCodeMask);
            int e = EditItem(d);
            if (ch == 13 || ch == 3) {
                Redraw(d, 0, true);
                uint32_t t = TickCount() + 8;
                while (TickCount() < t) {}
                Redraw(d, 0, false);
                *itemHit = 1;
                return;
            }
            if (e >= 0 && !(ev.modifiers & cmdKey)) {
                size_t n = strlen(d->edit);
                if (ch == 8 && n)
                    d->edit[n - 1] = 0;
                else if (ch >= 32 && ch < 127 && n < 255)
                    d->edit[n] = (char)ch, d->edit[n + 1] = 0;
                Redraw(d, e, false);
                *itemHit = e + 1;
                return;
            }
        }
    }
}
