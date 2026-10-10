/* Overlay panels drawn over a dimmed copy of the screen. */
#include <ctype.h>
#include <stdlib.h>
#include <string.h>

#include "panel.h"
#include "platform.h"

enum { kPad = 24, kTitleH = 52, kRowH = 30, kHeadH = 28, kDividerH = 13, kHintH = 34, kMinW = 300 };
enum { kKeyS = 0x01, kKeyW = 0x0D, kReturn = 0x24, kSpace = 0x31, kBackspace = 0x33, kEscape = 0x35,
       kEnter = 0x4C, kDownArrow = 0x7D, kUpArrow = 0x7E };

/* Text colors come from the system palette the game draws with; fills are
 * written straight to the screen. */
static const RGBColor kWhite = {0xFFFF, 0xFFFF, 0xFFFF}, kText = {0xCCCC, 0xCCCC, 0xCCCC},
                      kHot = {0xFFFF, 0xFFFF, 0x6666}, kDim = {0x5555, 0x5555, 0x5555},
                      kHeading = {0x9999, 0x9999, 0xFFFF}, kHint = {0x8888, 0x8888, 0x8888};
enum { kFill = 0x000022, kBorder = 0x6666FF, kBar = 0x333399, kField = 0x000000 };

static struct {
    GWorldPtr port;
    RGBColor fg, bg;
    int16_t font, size, face, mode;
    RgnHandle clip;
} saved;

/* Within PanelBegin/PanelEnd one panel replaces the next without the
 * screen being restored in between, which would flicker. */
static int session;
static uint32_t *under, *dimmed;

static GWorldPtr Screen(void) { return ScreenPort(); }

static void Fill(const Rect *r, uint32_t c)
{
    GWorldPtr s = Screen();
    for (int v = r->top < 0 ? 0 : r->top; v < r->bottom && v < s->h; v++)
        for (int h = r->left < 0 ? 0 : r->left; h < r->right && h < s->w; h++)
            s->px[v * s->w + h] = c;
    ScreenDirty();
}

static void Box(const Rect *r)
{
    Rect in = *r;
    Fill(r, kBorder);
    InsetRect(&in, 2, 2);
    Fill(&in, kFill);
}

static void SetText(int size, int face, const RGBColor *c)
{
    TextFont(1);
    TextSize(size);
    TextFace(face);
    RGBForeColor(c);
}

static void Text(const char *s, int h, int v)
{
    MoveTo(h, v);
    DrawString(s);
}

static void Centered(const Rect *r, const char *s, int v) { Text(s, (r->left + r->right - StringWidth(s)) / 2, v); }

/* Word-wraps `s` into `width`; draws only if `draw`. Returns the lines used. */
static int Wrapped(const char *s, int h, int v, int width, int lineH, Boolean draw)
{
    char line[256];
    int lines = 0;
    while (*s) {
        int n = 0, fit = 0;
        while (s[n]) {
            int end = n;
            while (s[end] && s[end] != ' ')
                end++;
            memcpy(line, s, (size_t)end);
            line[end] = 0;
            if (fit && StringWidth(line) > width)
                break;
            fit = n = end;
            if (s[n] == ' ')
                n++;
        }
        memcpy(line, s, (size_t)fit);
        line[fit] = 0;
        if (draw)
            Text(line, h, v + lines * lineH);
        lines++;
        s += n ? n : (int)strlen(s);
    }
    return lines;
}

static void WaitRelease(void)
{
    for (;;) {
        KeyMap k;
        GetKeys(k);
        Boolean any = Button();
        for (int i = 0; i < 128; i++)
            if (KeyDown(k, i) && (i < 0x37 || i > 0x3B)) /* modifiers don't count */
                any = true;
        if (!any)
            break;
        PlatformIdle();
    }
    FlushEvents(everyEvent, 0);
}

static void Open(void)
{
    saved.port = thePort;
    SetGWorld(Screen());
    saved.fg = thePort->fg, saved.bg = thePort->bg;
    saved.font = thePort->txFont, saved.size = thePort->txSize;
    saved.face = thePort->txFace, saved.mode = thePort->txMode;
    saved.clip = NewRgn();
    GetClip(saved.clip);
    SetRectRgn(thePort->clip, 0, 0, thePort->w, thePort->h);
    TextMode(srcOr);

    size_t n = (size_t)thePort->w * thePort->h;
    if (!under) {
        under = malloc(n * 4);
        dimmed = malloc(n * 4);
        memcpy(under, thePort->px, n * 4);
        for (size_t i = 0; i < n; i++) {
            uint32_t p = under[i];
            dimmed[i] = ((p >> 16 & 0xFF) * 3 / 8) << 16 | ((p >> 8 & 0xFF) * 3 / 8) << 8 | (p & 0xFF) * 3 / 8;
        }
    }
    memcpy(thePort->px, dimmed, n * 4);
    ScreenDirty();
}

static void Restore(void)
{
    GWorldPtr s = Screen();
    memcpy(s->px, under, (size_t)s->w * s->h * 4);
    free(under);
    free(dimmed);
    under = dimmed = NULL;
    ScreenDirty();
}

void PanelBegin(void) { session++; }

void PanelEnd(void)
{
    if (--session == 0 && under)
        Restore();
}

static void Close(void)
{
    if (!session)
        Restore();
    SetClip(saved.clip);
    DisposeRgn(saved.clip);
    thePort->fg = saved.fg, thePort->bg = saved.bg;
    thePort->txFont = saved.font, thePort->txSize = saved.size;
    thePort->txFace = saved.face, thePort->txMode = saved.mode;
    SetGWorld(saved.port);
    /* Keys still held would otherwise reach the game (Space is magic). */
    WaitRelease();
}

static Rect CenteredBox(int w, int h)
{
    Rect r;
    SetRect(&r, (Screen()->w - w) / 2, (Screen()->h - h) / 2, (Screen()->w + w) / 2, (Screen()->h + h) / 2);
    return r;
}

static void DrawTitle(const Rect *box, const char *title)
{
    SetText(24, bold, &kWhite);
    Centered(box, title, box->top + 36);
    Rect rule;
    SetRect(&rule, box->left + kPad, box->top + kTitleH - 8, box->right - kPad, box->top + kTitleH - 7);
    Fill(&rule, kBorder);
}

static void DrawHint(const Rect *box, const char *hint)
{
    SetText(10, normal, &kHint);
    Centered(box, hint, box->bottom - 14);
}

/* ------------------------------------------------------------------ */
/* Menus */

typedef struct {
    const char *title, *hint;
    const PanelItem *items;
    int n;
    Rect box;
    int16_t top[32];
} Menu;

static int RowHeight(const PanelItem *it)
{
    return it->kind == kPanelHeading ? kHeadH : it->kind == kPanelDivider ? kDividerH : kRowH;
}

static Boolean Selectable(const PanelItem *it)
{
    return it->kind != kPanelHeading && it->kind != kPanelDivider && !it->disabled;
}

static void Layout(Menu *m)
{
    SetText(24, bold, &kWhite);
    int w = StringWidth(m->title);
    int h = kTitleH;
    for (int i = 0; i < m->n; i++) {
        const PanelItem *it = &m->items[i];
        m->top[i] = (int16_t)h;
        h += RowHeight(it);
        if (it->kind == kPanelDivider)
            continue;
        SetText(it->kind == kPanelHeading ? 12 : 18, it->kind == kPanelHeading ? bold : normal, &kText);
        int iw = StringWidth(it->label) + (it->kind == kPanelChoice ? 28 : 0);
        if (iw > w)
            w = iw;
    }
    SetText(10, normal, &kHint);
    if (StringWidth(m->hint) > w)
        w = StringWidth(m->hint);
    w += 2 * kPad;
    m->box = CenteredBox(w < kMinW ? kMinW : w, h + kHintH);
    for (int i = 0; i < m->n; i++)
        m->top[i] += m->box.top;
}

static void DrawMenu(const Menu *m, int sel)
{
    Box(&m->box);
    DrawTitle(&m->box, m->title);
    for (int i = 0; i < m->n; i++) {
        const PanelItem *it = &m->items[i];
        int y = m->top[i];
        if (it->kind == kPanelDivider) {
            Rect rule;
            SetRect(&rule, m->box.left + kPad, y + kDividerH / 2, m->box.right - kPad, y + kDividerH / 2 + 1);
            Fill(&rule, kBar);
            continue;
        }
        if (it->kind == kPanelHeading) {
            SetText(12, bold, &kHeading);
            Text(it->label, m->box.left + kPad, y + 20);
            continue;
        }
        if (i == sel) {
            Rect bar;
            SetRect(&bar, m->box.left + 10, y + 2, m->box.right - 10, y + kRowH - 2);
            Fill(&bar, kBar);
        }
        SetText(18, normal, it->disabled ? &kDim : i == sel ? &kHot : &kText);
        if (it->kind == kPanelChoice) {
            Rect dot;
            SetRect(&dot, m->box.left + kPad + 2, y + 9, m->box.left + kPad + 14, y + 21);
            FrameRoundRect(&dot, 12, 12);
            if (it->checked) {
                InsetRect(&dot, 3, 3);
                PaintRoundRect(&dot, 6, 6);
            }
            Text(it->label, m->box.left + kPad + 24, y + 21);
        } else {
            Centered(&m->box, it->label, y + 21);
        }
    }
    DrawHint(&m->box, m->hint);
}

static int RowAt(const Menu *m, Point p)
{
    if (p.h < m->box.left || p.h >= m->box.right)
        return -1;
    for (int i = 0; i < m->n; i++)
        if (p.v >= m->top[i] && p.v < m->top[i] + RowHeight(&m->items[i]))
            return i;
    return -1;
}

static int Step(const Menu *m, int sel, int d)
{
    for (int k = 0; k < m->n; k++) {
        sel = (sel + d + m->n) % m->n;
        if (Selectable(&m->items[sel]))
            return sel;
    }
    return sel;
}

int PanelChoose(const char *title, const char *hint, const PanelItem *items, int n, int *sel)
{
    Menu m = {title, hint, items, n < 32 ? n : 32, {0, 0, 0, 0}, {0}};
    Open();
    Layout(&m);
    if (*sel < 0 || *sel >= m.n || !Selectable(&items[*sel]))
        *sel = Step(&m, *sel < 0 ? -1 : *sel, 1);
    DrawMenu(&m, *sel);
    Point last;
    GetMouse(&last);
    int result = -2;
    while (result == -2) {
        int was = *sel;
        Point p;
        GetMouse(&p);
        if (p.h != last.h || p.v != last.v) {
            int i = RowAt(&m, p);
            if (i >= 0 && Selectable(&items[i]))
                *sel = i;
            last = p;
        }
        EventRecord ev;
        if (GetNextEvent(everyEvent, &ev)) {
            int key = (int)(ev.message >> 8 & 0xFF);
            if (ev.what == keyDown || ev.what == autoKey) {
                if (key == kUpArrow || key == kKeyW)
                    *sel = Step(&m, *sel, -1);
                else if (key == kDownArrow || key == kKeyS)
                    *sel = Step(&m, *sel, 1);
                else if (ev.what == keyDown && (key == kReturn || key == kEnter || key == kSpace))
                    result = *sel;
                else if (ev.what == keyDown && key == kEscape)
                    result = -1;
            } else if (ev.what == mouseDown) {
                int i = RowAt(&m, ev.where);
                if (i >= 0 && Selectable(&items[i]))
                    result = *sel = i;
                else if (!PtInRect(ev.where, &m.box))
                    result = -1;
            }
        }
        if (*sel != was)
            DrawMenu(&m, *sel);
        PlatformIdle();
    }
    Close();
    return result;
}

/* ------------------------------------------------------------------ */
/* Text entry */

enum { kAskW = 400, kFieldH = 34, kButtonW = 96, kButtonH = 28 };

typedef struct { Rect box, field, cancel, ok; int promptLines; } Ask;

static void DrawButton(const Rect *r, const char *label, Boolean isDefault)
{
    Fill(r, isDefault ? kBorder : kBar);
    Rect in = *r;
    InsetRect(&in, 1, 1);
    Fill(&in, isDefault ? kBar : kFill);
    SetText(14, isDefault ? bold : normal, isDefault ? &kHot : &kText);
    Centered(r, label, r->top + 19);
}

static void DrawAsk(const Ask *a, const char *title, const char *prompt, const char *text, Boolean caret)
{
    Box(&a->box);
    DrawTitle(&a->box, title);
    SetText(12, normal, &kText);
    Wrapped(prompt, a->box.left + kPad, a->box.top + kTitleH + 14, kAskW - 2 * kPad, 16, true);
    Fill(&a->field, kBorder);
    Rect in = a->field;
    InsetRect(&in, 1, 1);
    Fill(&in, kField);
    SetText(18, normal, &kWhite);
    Text(text, a->field.left + 10, a->field.top + 24);
    if (caret) {
        Rect c;
        int h = a->field.left + 11 + StringWidth(text);
        SetRect(&c, h, a->field.top + 7, h + 2, a->field.bottom - 7);
        Fill(&c, 0xFFFFFF);
    }
    DrawButton(&a->cancel, "Cancel", false);
    DrawButton(&a->ok, "OK", true);
    DrawHint(&a->box, "Return: OK      Esc: cancel");
}

Boolean PanelAskText(const char *title, const char *prompt, char *buf, int size)
{
    Ask a;
    Open();
    SetText(12, normal, &kText);
    a.promptLines = Wrapped(prompt, 0, 0, kAskW - 2 * kPad, 16, false);
    int fieldTop = kTitleH + a.promptLines * 16 + 8;
    int h = fieldTop + kFieldH + 16 + kButtonH + kHintH;
    a.box = CenteredBox(kAskW, h);
    SetRect(&a.field, a.box.left + kPad, a.box.top + fieldTop, a.box.right - kPad, a.box.top + fieldTop + kFieldH);
    int by = a.field.bottom + 16;
    SetRect(&a.ok, a.box.right - kPad - kButtonW, by, a.box.right - kPad, by + kButtonH);
    a.cancel = a.ok;
    OffsetRect(&a.cancel, -(kButtonW + 12), 0);

    int len = (int)strlen(buf);
    int result = -1;
    Boolean caret = true, drawn = false;
    while (result < 0) {
        Boolean blink = (TickCount() / 30) % 2 == 0;
        if (!drawn || blink != caret) {
            caret = blink;
            DrawAsk(&a, title, prompt, buf, caret);
            drawn = true;
        }
        EventRecord ev;
        if (GetNextEvent(everyEvent, &ev)) {
            int key = (int)(ev.message >> 8 & 0xFF), ch = (int)(ev.message & charCodeMask);
            if (ev.what == keyDown || ev.what == autoKey) {
                if (key == kReturn || key == kEnter)
                    result = 1;
                else if (ev.what == keyDown && key == kEscape)
                    result = 0;
                else if (key == kBackspace && len > 0)
                    buf[--len] = 0, drawn = false;
                else if (isalpha(ch) && len < size - 1)
                    buf[len++] = (char)toupper(ch), buf[len] = 0, drawn = false;
            } else if (ev.what == mouseDown) {
                if (PtInRect(ev.where, &a.ok))
                    result = 1;
                else if (PtInRect(ev.where, &a.cancel) || !PtInRect(ev.where, &a.box))
                    result = 0;
            }
        }
        PlatformIdle();
    }
    Close();
    return result == 1;
}

/* ------------------------------------------------------------------ */
/* Notices */

void PanelMessageOpen(const char *text)
{
    Open();
    SetText(18, bold, &kWhite);
    int w = StringWidth(text) + 2 * kPad;
    Rect box = CenteredBox(w < kMinW ? kMinW : w, 40 + kHintH);
    Box(&box);
    Centered(&box, text, box.top + 34);
    DrawHint(&box, "click or press a key");
}

void PanelMessageWait(void)
{
    for (;;) {
        EventRecord ev;
        if (GetNextEvent(everyEvent, &ev) && (ev.what == keyDown || ev.what == mouseDown))
            break;
        PlatformIdle();
    }
    Close();
}
