/* QuickDraw subset: ports, rects, regions, CopyBits, shapes, pictures, text. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "mac.h"
#include "platform.h"

#define STB_TRUETYPE_IMPLEMENTATION
#include "third_party/stb_truetype.h"
#define STB_IMAGE_IMPLEMENTATION
#define STBI_ONLY_PNG
#include "third_party/stb_image.h"

GWorldPtr thePort;
int32_t randSeed = 1;

static int imin(int a, int b) { return a < b ? a : b; }
static int imax(int a, int b) { return a > b ? a : b; }

/* ------------------------------------------------------------------ */
/* Colors: the game drew into 8-bit GWorlds with the standard system
 * palette, so RGB colors are snapped to that palette. */

static uint32_t palette[256];

static void BuildPalette(void)
{
    static const uint8_t ramp[10] = {0xEE, 0xDD, 0xBB, 0xAA, 0x88, 0x77, 0x55, 0x44, 0x22, 0x11};
    int n = 0;
    for (int r = 0; r < 6; r++)
        for (int g = 0; g < 6; g++)
            for (int b = 0; b < 6; b++)
                if (n < 215)
                    palette[n++] = (uint32_t)(0xFF - 0x33 * r) << 16 | (uint32_t)(0xFF - 0x33 * g) << 8 |
                                   (uint32_t)(0xFF - 0x33 * b);
    for (int c = 0; c < 4; c++)
        for (int i = 0; i < 10; i++) {
            uint32_t v = ramp[i];
            palette[n++] = c == 0 ? v << 16 : c == 1 ? v << 8 : c == 2 ? v : v << 16 | v << 8 | v;
        }
    palette[255] = 0;
}

static uint32_t Snap(const RGBColor *c)
{
    if (!palette[0])
        BuildPalette();
    int r = c->red >> 8, g = c->green >> 8, b = c->blue >> 8;
    uint32_t best = 0;
    int bestd = 1 << 30;
    for (int i = 0; i < 256; i++) {
        int dr = (int)(palette[i] >> 16) - r, dg = (int)(palette[i] >> 8 & 0xFF) - g, db = (int)(palette[i] & 0xFF) - b;
        int d = dr * dr + dg * dg + db * db;
        if (d < bestd)
            bestd = d, best = palette[i];
    }
    return best;
}

static uint32_t FgPixel(void) { return Snap(&thePort->fg); }
static uint32_t BgPixel(void) { return Snap(&thePort->bg); }

/* ------------------------------------------------------------------ */
/* Rects */

void SetRect(Rect *r, int left, int top, int right, int bottom)
{
    r->left = (int16_t)left, r->top = (int16_t)top, r->right = (int16_t)right, r->bottom = (int16_t)bottom;
}

void OffsetRect(Rect *r, int dh, int dv)
{
    r->left += dh, r->right += dh, r->top += dv, r->bottom += dv;
}

void InsetRect(Rect *r, int dh, int dv)
{
    r->left += dh, r->right -= dh, r->top += dv, r->bottom -= dv;
}

Boolean PtInRect(Point p, const Rect *r)
{
    return p.h >= r->left && p.h < r->right && p.v >= r->top && p.v < r->bottom;
}

Boolean SectRect(const Rect *a, const Rect *b, Rect *out)
{
    Rect t;
    SetRect(&t, imax(a->left, b->left), imax(a->top, b->top), imin(a->right, b->right), imin(a->bottom, b->bottom));
    if (t.left >= t.right || t.top >= t.bottom) {
        SetRect(out, 0, 0, 0, 0);
        return false;
    }
    *out = t;
    return true;
}

static Boolean EmptyRect(const Rect *r) { return r->left >= r->right || r->top >= r->bottom; }

/* ------------------------------------------------------------------ */
/* Regions */

RgnHandle NewRgn(void) { return calloc(1, sizeof(Region)); }

void DisposeRgn(RgnHandle r)
{
    if (r)
        free(r->mask), free(r);
}

static void RgnAlloc(RgnHandle r, const Rect *bbox, int fill)
{
    free(r->mask);
    r->mask = NULL;
    if (EmptyRect(bbox)) {
        SetRect(&r->bbox, 0, 0, 0, 0);
        return;
    }
    r->bbox = *bbox;
    size_t n = (size_t)(bbox->right - bbox->left) * (bbox->bottom - bbox->top);
    r->mask = malloc(n);
    memset(r->mask, fill, n);
}

static Boolean RgnHas(RgnHandle r, int h, int v)
{
    if (!r->mask || h < r->bbox.left || h >= r->bbox.right || v < r->bbox.top || v >= r->bbox.bottom)
        return false;
    return r->mask[(v - r->bbox.top) * (r->bbox.right - r->bbox.left) + (h - r->bbox.left)];
}

void SetEmptyRgn(RgnHandle r)
{
    Rect e = {0, 0, 0, 0};
    RgnAlloc(r, &e, 0);
}

void RectRgn(RgnHandle r, const Rect *rect) { RgnAlloc(r, rect, 1); }

void SetRectRgn(RgnHandle r, int left, int top, int right, int bottom)
{
    Rect t;
    SetRect(&t, left, top, right, bottom);
    RgnAlloc(r, &t, 1);
}

void OffsetRgn(RgnHandle r, int dh, int dv)
{
    if (r->mask)
        OffsetRect(&r->bbox, dh, dv);
}

void CopyRgn(RgnHandle src, RgnHandle dst)
{
    if (src == dst)
        return;
    RgnAlloc(dst, &src->bbox, 0);
    if (src->mask)
        memcpy(dst->mask, src->mask, (size_t)(src->bbox.right - src->bbox.left) * (src->bbox.bottom - src->bbox.top));
}

static void Combine(RgnHandle a, RgnHandle b, RgnHandle dst, int op)
{
    Rect bb;
    if (op == 0) { /* union */
        if (!a->mask) { CopyRgn(b, dst); return; }
        if (!b->mask) { CopyRgn(a, dst); return; }
        SetRect(&bb, imin(a->bbox.left, b->bbox.left), imin(a->bbox.top, b->bbox.top),
                imax(a->bbox.right, b->bbox.right), imax(a->bbox.bottom, b->bbox.bottom));
    } else { /* difference */
        bb = a->bbox;
    }
    Region t = {{0, 0, 0, 0}, NULL};
    RgnAlloc(&t, &bb, 0);
    for (int v = bb.top; v < bb.bottom; v++)
        for (int h = bb.left; h < bb.right; h++) {
            Boolean in = op == 0 ? (RgnHas(a, h, v) || RgnHas(b, h, v)) : (RgnHas(a, h, v) && !RgnHas(b, h, v));
            if (t.mask)
                t.mask[(v - bb.top) * (bb.right - bb.left) + (h - bb.left)] = in;
        }
    free(dst->mask);
    *dst = t;
}

void UnionRgn(RgnHandle a, RgnHandle b, RgnHandle dst) { Combine(a, b, dst, 0); }
void DiffRgn(RgnHandle a, RgnHandle b, RgnHandle dst) { Combine(a, b, dst, 1); }

Boolean PtInRgn(Point p, RgnHandle r) { return RgnHas(r, p.h, p.v); }

/* Black pixels of the bitmap become the region. */
void BitMapToRegion(RgnHandle r, GWorldPtr gw)
{
    Rect bb;
    SetRect(&bb, 0, 0, gw->w, gw->h);
    RgnAlloc(r, &bb, 0);
    for (int i = 0; i < gw->w * gw->h; i++) {
        uint32_t c = gw->px[i];
        int lum = (int)(c >> 16 & 0xFF) * 30 + (int)(c >> 8 & 0xFF) * 59 + (int)(c & 0xFF) * 11;
        r->mask[i] = lum < 128 * 100;
    }
}

void GetClip(RgnHandle r) { CopyRgn(thePort->clip, r); }
void SetClip(RgnHandle r) { CopyRgn(r, thePort->clip); }

/* ------------------------------------------------------------------ */
/* Ports */

GWorldPtr NewGWorld(int width, int height)
{
    GWorldPtr gw = calloc(1, sizeof(GWorld));
    gw->w = width, gw->h = height;
    gw->px = calloc((size_t)width * height, sizeof(uint32_t));
    gw->fg = (RGBColor){0, 0, 0};
    gw->bg = (RGBColor){0xFFFF, 0xFFFF, 0xFFFF};
    gw->clip = NewRgn();
    /* QuickDraw's default clip region is "wide open". */
    SetRectRgn(gw->clip, 0, 0, width, height);
    gw->penW = gw->penH = 1;
    gw->txFont = 0, gw->txSize = 12, gw->txMode = srcOr;
    return gw;
}

void DisposeGWorld(GWorldPtr gw)
{
    if (!gw)
        return;
    DisposeRgn(gw->clip);
    free(gw->px);
    free(gw);
}

void SetGWorld(GWorldPtr port) { thePort = port; }

/* Plot one pixel through the port's clip region. */
static inline void Plot(GWorldPtr p, int h, int v, uint32_t c)
{
    if (h < 0 || v < 0 || h >= p->w || v >= p->h || !RgnHas(p->clip, h, v))
        return;
    p->px[v * p->w + h] = c;
    if (p == ScreenPort())
        ScreenDirty();
}

static inline void Invert(GWorldPtr p, int h, int v)
{
    if (h < 0 || v < 0 || h >= p->w || v >= p->h || !RgnHas(p->clip, h, v))
        return;
    p->px[v * p->w + h] ^= 0xFFFFFF;
    if (p == ScreenPort())
        ScreenDirty();
}

void ForeColor(int color)
{
    thePort->fg = color == whiteColor ? (RGBColor){0xFFFF, 0xFFFF, 0xFFFF} : (RGBColor){0, 0, 0};
}

void BackColor(int color)
{
    thePort->bg = color == blackColor ? (RGBColor){0, 0, 0} : (RGBColor){0xFFFF, 0xFFFF, 0xFFFF};
}

void RGBForeColor(const RGBColor *c) { thePort->fg = *c; }
void GetForeColor(RGBColor *c) { *c = thePort->fg; }

static void FillRect(const Rect *r, uint32_t c)
{
    for (int v = r->top; v < r->bottom; v++)
        for (int h = r->left; h < r->right; h++)
            Plot(thePort, h, v, c);
}

void PaintRect(const Rect *r) { FillRect(r, FgPixel()); }
void EraseRect(const Rect *r) { FillRect(r, BgPixel()); }

void InvertRect(const Rect *r)
{
    for (int v = r->top; v < r->bottom; v++)
        for (int h = r->left; h < r->right; h++)
            Invert(thePort, h, v);
}

/* Is pixel (h,v) inside the round rect r with the given oval size? */
static Boolean InRoundRect(const Rect *r, int ow, int oh, int h, int v)
{
    if (h < r->left || h >= r->right || v < r->top || v >= r->bottom)
        return false;
    int w = r->right - r->left, ht = r->bottom - r->top;
    ow = imin(ow, w), oh = imin(oh, ht);
    if (ow <= 0 || oh <= 0)
        return true;
    double rx = ow / 2.0, ry = oh / 2.0;
    double px = h + 0.5, py = v + 0.5;
    double cx = px < r->left + rx ? r->left + rx : px > r->right - rx ? r->right - rx : px;
    double cy = py < r->top + ry ? r->top + ry : py > r->bottom - ry ? r->bottom - ry : py;
    double dx = (px - cx) / rx, dy = (py - cy) / ry;
    return dx * dx + dy * dy <= 1.0;
}

void InvertOval(const Rect *r)
{
    int w = r->right - r->left, h = r->bottom - r->top;
    for (int v = r->top; v < r->bottom; v++)
        for (int x = r->left; x < r->right; x++)
            if (InRoundRect(r, w, h, x, v))
                Invert(thePort, x, v);
}

static Boolean PenPixel(int h, int v) { return !thePort->penGray || ((h + v) & 1) == 0; }

void FrameRoundRect(const Rect *r, int ow, int oh)
{
    Rect in = *r;
    InsetRect(&in, thePort->penW, thePort->penH);
    uint32_t fg = FgPixel(), bg = BgPixel();
    for (int v = r->top; v < r->bottom; v++)
        for (int h = r->left; h < r->right; h++)
            if (InRoundRect(r, ow, oh, h, v) &&
                !InRoundRect(&in, ow - 2 * thePort->penW, oh - 2 * thePort->penH, h, v))
                Plot(thePort, h, v, PenPixel(h, v) ? fg : bg);
}

void PaintRoundRect(const Rect *r, int ow, int oh)
{
    uint32_t fg = FgPixel();
    for (int v = r->top; v < r->bottom; v++)
        for (int h = r->left; h < r->right; h++)
            if (InRoundRect(r, ow, oh, h, v))
                Plot(thePort, h, v, fg);
}

void FrameRect(const Rect *r) { FrameRoundRect(r, 0, 0); }

void PenNormal(void)
{
    thePort->penW = thePort->penH = 1;
    thePort->penGray = false;
}

void PenSize(int w, int h) { thePort->penW = (int16_t)w, thePort->penH = (int16_t)h; }
void PenPatGray(void) { thePort->penGray = true; }

void MoveTo(int h, int v) { thePort->pen.h = (int16_t)h, thePort->pen.v = (int16_t)v; }

void LineTo(int h, int v)
{
    int x0 = thePort->pen.h, y0 = thePort->pen.v;
    int dx = abs(h - x0), dy = -abs(v - y0), sx = x0 < h ? 1 : -1, sy = y0 < v ? 1 : -1, err = dx + dy;
    uint32_t c = FgPixel();
    for (;;) {
        Plot(thePort, x0, y0, c);
        if (x0 == h && y0 == v)
            break;
        int e2 = 2 * err;
        if (e2 >= dy)
            err += dy, x0 += sx;
        if (e2 <= dx)
            err += dx, y0 += sy;
    }
    MoveTo(h, v);
}

void SetCPixel(int h, int v, const RGBColor *c) { Plot(thePort, h, v, Snap(c)); }

/* srcCopy only; the game never relies on colorizing. Pixels outside srcBits
 * are skipped, as are pixels outside the mask region and (when drawing into
 * the current port) its clip region. */
void CopyBits(GWorldPtr src, GWorldPtr dst, const Rect *sr, const Rect *dr, int mode, RgnHandle mask)
{
    (void)mode;
    int sw = sr->right - sr->left, sh = sr->bottom - sr->top;
    int dw = dr->right - dr->left, dh = dr->bottom - dr->top;
    if (sw <= 0 || sh <= 0 || dw <= 0 || dh <= 0)
        return;
    Boolean clip = dst == thePort;
    for (int y = 0; y < dh; y++) {
        int dv = dr->top + y, sv = sr->top + y * sh / dh;
        if (dv < 0 || dv >= dst->h || sv < 0 || sv >= src->h)
            continue;
        for (int x = 0; x < dw; x++) {
            int dhh = dr->left + x, shh = sr->left + x * sw / dw;
            if (dhh < 0 || dhh >= dst->w || shh < 0 || shh >= src->w)
                continue;
            if (mask && !RgnHas(mask, dhh, dv))
                continue;
            if (clip && !RgnHas(dst->clip, dhh, dv))
                continue;
            dst->px[dv * dst->w + dhh] = src->px[sv * src->w + shh];
        }
    }
    if (dst == ScreenPort())
        ScreenDirty();
}

/* QuickDraw's Random: Park-Miller minimal standard generator. */
int16_t Random(void)
{
    int64_t s = randSeed;
    if (s == 0)
        s = 1;
    s = s * 16807 % 0x7FFFFFFF;
    randSeed = (int32_t)s;
    int16_t r = (int16_t)(s & 0xFFFF);
    r = r == -32768 ? 0 : r;
    if (getenv("STARDUST_LOG_RANDOM"))
        PlatformLog("rnd %d", r);
    return r;
}

/* ------------------------------------------------------------------ */
/* Pictures */

static PicHandle LoadPng(const char *name, int id);

PicHandle GetPicture(int id)
{
    char name[32];
    snprintf(name, sizeof name, "pict_%d.png", id);
    return LoadPng(name, id);
}

/* Color dialogs show a 'cicn' in place of an 'ICON' with the same ID.
 * The pixel's high byte keeps the icon mask. */
PicHandle GetIconPicture(int id)
{
    char name[32];
    snprintf(name, sizeof name, "cicn_%d.png", id);
    PicHandle p = LoadPng(name, id);
    if (!p) {
        snprintf(name, sizeof name, "icon_%d.png", id);
        p = LoadPng(name, id);
    }
    return p;
}

static PicHandle LoadPng(const char *name, int id)
{
    long size;
    unsigned char *file = LoadAssetFile(name, &size);
    if (!file)
        return NULL;
    int w, h, n;
    unsigned char *rgba = stbi_load_from_memory(file, (int)size, &w, &h, &n, 4);
    free(file);
    if (!rgba)
        return NULL;
    Picture *pic = malloc(sizeof *pic);
    pic->id = (int16_t)id, pic->w = w, pic->h = h;
    pic->px = malloc((size_t)w * h * 4);
    for (int i = 0; i < w * h; i++)
        pic->px[i] = (uint32_t)rgba[i * 4 + 3] << 24 | (uint32_t)rgba[i * 4] << 16 | (uint32_t)rgba[i * 4 + 1] << 8 | rgba[i * 4 + 2];
    stbi_image_free(rgba);
    Picture **hdl = malloc(sizeof *hdl);
    *hdl = pic;
    return hdl;
}

void ReleasePicture(PicHandle pic)
{
    if (!pic)
        return;
    free((*pic)->px);
    free(*pic);
    free(pic);
}

Rect PictureFrame(PicHandle pic)
{
    Rect r;
    SetRect(&r, 0, 0, (*pic)->w, (*pic)->h);
    return r;
}

void DrawPicture(PicHandle hdl, const Rect *dst)
{
    Picture *pic = *hdl;
    int dw = dst->right - dst->left, dh = dst->bottom - dst->top;
    for (int y = 0; y < dh; y++)
        for (int x = 0; x < dw; x++)
            {
            uint32_t c = pic->px[(y * pic->h / dh) * pic->w + x * pic->w / dw];
            if (c >> 24 >= 128)
                Plot(thePort, dst->left + x, dst->top + y, c & 0xFFFFFF);
        }
}

/* ------------------------------------------------------------------ */
/* Text */

static stbtt_fontinfo font;
static unsigned char *fontData;

static Boolean LoadFont(void)
{
    if (fontData)
        return true;
    long size;
    fontData = LoadAssetFile("geneva.ttf", &size);
    return fontData && stbtt_InitFont(&font, fontData, stbtt_GetFontOffsetForIndex(fontData, 0));
}

void TextFont(int f) { thePort->txFont = (int16_t)f; }
void TextFace(int f) { thePort->txFace = (int16_t)f; }
void TextMode(int m) { thePort->txMode = (int16_t)m; }
void TextSize(int s) { thePort->txSize = (int16_t)s; }

/* Mac Roman bytes that appear in the game's strings. */
static int Unicode(unsigned char c)
{
    switch (c) {
    case 0xD2: return 0x201C;
    case 0xD3: return 0x201D;
    case 0xD4: return 0x2018;
    case 0xD5: return 0x2019;
    case 0xC9: return 0x2026;
    default: return c;
    }
}

/* The system font is Chicago 12; Geneva drawn bold stands in for it. */
static int EffectiveSize(void) { return thePort->txSize ? thePort->txSize : 12; }
static Boolean EffectiveBold(void) { return thePort->txFont == 0 || (thePort->txFace & bold); }

static int CharWidth(int ch, float scale)
{
    int adv, lsb;
    stbtt_GetCodepointHMetrics(&font, ch, &adv, &lsb);
    return (int)(adv * scale + 0.5f) + (EffectiveBold() ? 1 : 0);
}

int StringWidth(const char *s)
{
    if (!LoadFont())
        return 0;
    float scale = stbtt_ScaleForMappingEmToPixels(&font, (float)EffectiveSize());
    int w = 0;
    for (; *s; s++)
        w += CharWidth(Unicode((unsigned char)*s), scale);
    return w;
}

void DrawString(const char *s)
{
    if (!LoadFont())
        return;
    float scale = stbtt_ScaleForMappingEmToPixels(&font, (float)EffectiveSize());
    uint32_t fg = FgPixel();
    for (; *s; s++) {
        int ch = Unicode((unsigned char)*s);
        int gw, gh, xo, yo;
        unsigned char *bmp = stbtt_GetCodepointBitmap(&font, scale, scale, ch, &gw, &gh, &xo, &yo);
        /* No anti-aliasing, as on the Mac; thin small strokes need a lower cutoff. */
        int cutoff = EffectiveSize() <= 12 ? 72 : 128;
        for (int pass = 0; pass < (EffectiveBold() ? 2 : 1); pass++)
            for (int y = 0; y < gh; y++)
                for (int x = 0; x < gw; x++)
                    if (bmp[y * gw + x] >= cutoff)
                        Plot(thePort, thePort->pen.h + xo + x + pass, thePort->pen.v + yo + y, fg);
        stbtt_FreeBitmap(bmp, NULL);
        thePort->pen.h += (int16_t)CharWidth(ch, scale);
    }
}
