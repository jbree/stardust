/* Menu Manager subset: the MBAR 130 menu bar drawn over the top of the screen. */
#include <ctype.h>
#include <stdlib.h>
#include <string.h>

#include "macui.h"
#include "../src/platform.h"

enum { kBarHeight = 20, kItemHeight = 16 };

/* MENU resources 1-5. Enable flags are applied by the game before use. */
static Menu menus[] = {
    {1, "\x14", true, 2, {{"About Stardust...", 0, true, false}, {"-", 0, false, false}}},
    {2, "Game", true, 7,
     {{"New Game", 'N', true, false}, {"Abort Game", 'A', true, false}, {"-", 0, false, false},
      {"Start At Level...", 'O', true, false}, {"Reset Level", 'R', true, false}, {"-", 0, false, false},
      {"Quit", 'Q', true, false}}},
    {3, "Settings", true, 7,
     {{"Full Sound", '1', false, true}, {"Partial Sound", '2', false, false}, {"No Sound", '3', false, false},
      {"-", 0, false, false}, {"Fast Animation", '4', false, false}, {"Normal Animation ", '5', false, false},
      {"Slow Animation", '6', false, false}}},
    {4, "Information", true, 3,
     {{"The Plot", 0, false, false}, {"-", 0, false, false}, {"Simple Instructions", 0, false, false}}},
    {5, "-Use CAPS LOCK to toggle menus.-", false, 0, {{0}}},
};
enum { kMenuCount = sizeof menus / sizeof *menus };
static Menu *handles[kMenuCount];
static int titleLeft[kMenuCount + 1];
static int hilited;

static const uint16_t appleIcon[14] = {0x0030, 0x0060, 0x0040, 0x0EEE, 0x1FFF, 0x3FFE, 0x3FFC,
                                       0x3FFC, 0x3FFE, 0x1FFF, 0x1FFF, 0x0FFE, 0x07BC, 0x0000};
static const uint8_t cmdIcon[9] = {0x63, 0x94, 0x94, 0x7F, 0x14, 0x7F, 0x94, 0x94, 0x63};
static const uint8_t checkIcon[9] = {0x01, 0x01, 0x02, 0x02, 0x44, 0x44, 0x28, 0x28, 0x10};

MenuHandle GetMenuHandle(int id)
{
    for (int i = 0; i < kMenuCount; i++)
        if (menus[i].id == id) {
            handles[i] = &menus[i];
            return &handles[i];
        }
    return NULL;
}

void EnableItem(MenuHandle m, int item)
{
    if (item == 0)
        (*m)->enabled = true;
    else if (item <= (*m)->nitems)
        (*m)->items[item - 1].enabled = true;
}

void DisableItem(MenuHandle m, int item)
{
    if (item == 0)
        (*m)->enabled = false;
    else if (item <= (*m)->nitems)
        (*m)->items[item - 1].enabled = false;
}

void CheckItem(MenuHandle m, int item, Boolean checked)
{
    if (item >= 1 && item <= (*m)->nitems)
        (*m)->items[item - 1].checked = checked;
}

static void DrawBits(int x, int y, const void *bits, int rows, int wide, uint32_t c)
{
    for (int r = 0; r < rows; r++) {
        unsigned v = wide ? ((const uint16_t *)bits)[r] : ((const uint8_t *)bits)[r];
        for (int b = 0; b < (wide ? 16 : 8); b++)
            if (v >> ((wide ? 15 : 7) - b) & 1) {
                int px = x + b, py = y + r;
                if (px >= 0 && py >= 0 && px < thePort->w && py < thePort->h)
                    thePort->px[py * thePort->w + px] = c;
            }
    }
    ScreenDirty();
}

static void Layout(void)
{
    int x = 10;
    for (int i = 0; i < kMenuCount; i++) {
        titleLeft[i] = x;
        x += (i == 0 ? 16 : StringWidth(menus[i].title)) + 16;
    }
    titleLeft[kMenuCount] = x;
}

static void DrawTitle(int i)
{
    Rect r;
    SetRect(&r, titleLeft[i], 0, titleLeft[i + 1], kBarHeight - 1);
    EraseRect(&r);
    RGBColor gray = {0x7777, 0x7777, 0x7777};
    if (menus[i].enabled)
        ForeColor(blackColor);
    else
        RGBForeColor(&gray);
    if (i == 0)
        DrawBits(titleLeft[i] + 8, 3, appleIcon, 14, 1, 0);
    else {
        MoveTo(titleLeft[i] + 8, 14);
        DrawString(menus[i].title);
    }
    ForeColor(blackColor);
    if (hilited == menus[i].id)
        InvertRect(&r);
}

void DrawMenuBar(void)
{
    GWorldPtr save = thePort;
    SetGWorld(ScreenPort());
    RGBColor fg = thePort->fg, bg = thePort->bg;
    int font = thePort->txFont, size = thePort->txSize, face = thePort->txFace;
    TextFont(0), TextSize(12), TextFace(0);
    ForeColor(blackColor), BackColor(whiteColor);
    Region *clip = NewRgn();
    GetClip(clip);
    SetRectRgn(thePort->clip, 0, 0, thePort->w, thePort->h);
    Layout();
    Rect bar;
    SetRect(&bar, 0, 0, thePort->w, kBarHeight - 1);
    EraseRect(&bar);
    MoveTo(0, kBarHeight - 1);
    LineTo(thePort->w - 1, kBarHeight - 1);
    for (int i = 0; i < kMenuCount; i++)
        DrawTitle(i);
    SetClip(clip);
    DisposeRgn(clip);
    TextFont(font), TextSize(size), TextFace(face);
    thePort->fg = fg, thePort->bg = bg;
    SetGWorld(save);
}

/* Only the affected titles are redrawn, as the real Menu Manager does. */
void HiliteMenu(int id)
{
    if (id == hilited)
        return;
    GWorldPtr save = thePort;
    SetGWorld(ScreenPort());
    RGBColor fg = thePort->fg, bg = thePort->bg;
    int font = thePort->txFont, size = thePort->txSize, face = thePort->txFace;
    Region *clip = NewRgn();
    GetClip(clip);
    SetRectRgn(thePort->clip, 0, 0, thePort->w, thePort->h);
    TextFont(0), TextSize(12), TextFace(0);
    ForeColor(blackColor), BackColor(whiteColor);
    Layout();
    int old = hilited;
    hilited = id;
    for (int i = 0; i < kMenuCount; i++)
        if (menus[i].id == old || menus[i].id == id)
            DrawTitle(i);
    SetClip(clip);
    DisposeRgn(clip);
    TextFont(font), TextSize(size), TextFace(face);
    thePort->fg = fg, thePort->bg = bg;
    SetGWorld(save);
}

void InstallMenuBar(void) { hilited = 0; }

/* ------------------------------------------------------------------ */
/* Pull-down tracking */

typedef struct { Rect r; uint32_t *saved; } Under;

static Rect DropRect(int i)
{
    int w = 0;
    for (int k = 0; k < menus[i].nitems; k++) {
        int iw = StringWidth(menus[i].items[k].text) + (menus[i].items[k].key ? 40 : 0);
        if (iw > w)
            w = iw;
    }
    Rect r;
    SetRect(&r, titleLeft[i], kBarHeight - 1, titleLeft[i] + w + 32, kBarHeight + menus[i].nitems * kItemHeight + 1);
    return r;
}

static void SaveUnder(Under *u, Rect r)
{
    r.right += 1, r.bottom += 1; /* shadow */
    u->r = r;
    int w = r.right - r.left, h = r.bottom - r.top;
    u->saved = malloc((size_t)w * h * 4);
    for (int y = 0; y < h; y++)
        for (int x = 0; x < w; x++) {
            int px = r.left + x, py = r.top + y;
            u->saved[y * w + x] = (px < thePort->w && py < thePort->h) ? thePort->px[py * thePort->w + px] : 0;
        }
}

static void RestoreUnder(Under *u)
{
    if (!u->saved)
        return;
    int w = u->r.right - u->r.left, h = u->r.bottom - u->r.top;
    for (int y = 0; y < h; y++)
        for (int x = 0; x < w; x++) {
            int px = u->r.left + x, py = u->r.top + y;
            if (px < thePort->w && py < thePort->h)
                thePort->px[py * thePort->w + px] = u->saved[y * w + x];
        }
    free(u->saved);
    u->saved = NULL;
    ScreenDirty();
}

static void DrawItem(int i, int k, Boolean hi)
{
    Rect dr = DropRect(i), ir;
    SetRect(&ir, dr.left + 1, dr.top + 1 + k * kItemHeight, dr.right - 1, dr.top + 1 + (k + 1) * kItemHeight);
    const MenuItemDef *it = &menus[i].items[k];
    EraseRect(&ir);
    RGBColor gray = {0x7777, 0x7777, 0x7777};
    if (it->text[0] == '-') {
        thePort->penGray = true;
        RGBForeColor(&gray);
        MoveTo(ir.left, ir.top + kItemHeight / 2);
        LineTo(ir.right - 1, ir.top + kItemHeight / 2);
        thePort->penGray = false;
        ForeColor(blackColor);
        return;
    }
    Boolean on = it->enabled && menus[i].enabled;
    if (on)
        ForeColor(blackColor);
    else
        RGBForeColor(&gray);
    uint32_t c = on ? 0 : 0x777777;
    if (it->checked)
        DrawBits(ir.left + 3, ir.top + 4, checkIcon, 9, 0, c);
    MoveTo(ir.left + 14, ir.top + 12);
    DrawString(it->text);
    if (it->key) {
        char key[2] = {it->key, 0};
        DrawBits(ir.right - 30, ir.top + 4, cmdIcon, 9, 0, c);
        MoveTo(ir.right - 18, ir.top + 12);
        DrawString(key);
    }
    ForeColor(blackColor);
    if (hi)
        InvertRect(&ir);
}

static void DrawDrop(int i)
{
    Rect r = DropRect(i);
    EraseRect(&r);
    FrameRect(&r);
    MoveTo(r.left + 1, r.bottom);
    LineTo(r.right, r.bottom);
    LineTo(r.right, r.top + 1);
    for (int k = 0; k < menus[i].nitems; k++)
        DrawItem(i, k, false);
}

int32_t MenuSelect(Point start)
{
    (void)start;
    GWorldPtr save = thePort;
    SetGWorld(ScreenPort());
    RGBColor fg = thePort->fg, bg = thePort->bg;
    int font = thePort->txFont, size = thePort->txSize, face = thePort->txFace;
    Region *clip = NewRgn();
    GetClip(clip);
    SetRectRgn(thePort->clip, 0, 0, thePort->w, thePort->h);
    TextFont(0), TextSize(12), TextFace(0);
    ForeColor(blackColor), BackColor(whiteColor);
    Layout();

    Under under = {{0, 0, 0, 0}, NULL};
    int open = -1, item = -1;
    int32_t result = 0;
    Point p;
    do {
        GetMouse(&p);
        int over = -1;
        if (p.v < kBarHeight)
            for (int i = 0; i < kMenuCount; i++)
                if (p.h >= titleLeft[i] && p.h < titleLeft[i + 1])
                    over = i;
        if (over >= 0 && over != open) {
            RestoreUnder(&under);
            hilited = menus[over].id;
            if (open >= 0)
                DrawTitle(open);
            open = over, item = -1;
            DrawTitle(open);
            if (menus[open].nitems) {
                SaveUnder(&under, DropRect(open));
                DrawDrop(open);
            }
        }
        int newItem = -1;
        if (open >= 0 && menus[open].enabled && menus[open].nitems) {
            Rect dr = DropRect(open);
            if (PtInRect(p, &dr)) {
                int k = (p.v - dr.top - 1) / kItemHeight;
                if (k >= 0 && k < menus[open].nitems && menus[open].items[k].enabled &&
                    menus[open].items[k].text[0] != '-')
                    newItem = k;
            }
        }
        if (newItem != item) {
            if (item >= 0)
                DrawItem(open, item, false);
            item = newItem;
            if (item >= 0)
                DrawItem(open, item, true);
        }
        PlatformIdle();
    } while (Button());

    if (open >= 0 && item >= 0) {
        for (int blink = 0; blink < 3; blink++) {
            DrawItem(open, item, blink & 1);
            uint32_t t = TickCount() + 3;
            while (TickCount() < t) {}
        }
        result = (int32_t)menus[open].id << 16 | (item + 1);
    }
    RestoreUnder(&under);
    if (!result) {
        hilited = 0;
        if (open >= 0)
            DrawTitle(open);
    }
    SetClip(clip);
    DisposeRgn(clip);
    TextFont(font), TextSize(size), TextFace(face);
    thePort->fg = fg, thePort->bg = bg;
    SetGWorld(save);
    return result;
}

int32_t MenuKey(char ch)
{
    ch = (char)toupper((unsigned char)ch);
    for (int i = 0; i < kMenuCount; i++)
        for (int k = 0; k < menus[i].nitems; k++)
            if (ch && menus[i].items[k].key == ch && menus[i].enabled && menus[i].items[k].enabled) {
                HiliteMenu(menus[i].id);
                return (int32_t)menus[i].id << 16 | (k + 1);
            }
    return 0;
}
