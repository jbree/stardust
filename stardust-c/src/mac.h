/*
 * A small re-implementation of the parts of the classic Macintosh Toolbox
 * that Stardust 1.1 uses, so the translated game code can keep the shape of
 * the original program. Coordinates, rect conventions and call semantics
 * follow QuickDraw; pixels are stored as 32-bit 0x00RRGGBB.
 */
#ifndef MAC_H
#define MAC_H

#include <stdbool.h>
#include <stdint.h>

typedef bool Boolean;

typedef struct { int16_t top, left, bottom, right; } Rect;
typedef struct { int16_t v, h; } Point;
typedef struct { uint16_t red, green, blue; } RGBColor;

/* A region is a bitmask over its bounding box. */
typedef struct Region {
    Rect bbox;
    uint8_t *mask; /* (bbox.right-bbox.left) * (bbox.bottom-bbox.top) */
} Region, *RgnHandle;

/* A GWorld doubles as a graphics port; the window is one too. */
typedef struct GWorld {
    int w, h;
    uint32_t *px;
    RGBColor fg, bg;
    RgnHandle clip;
    Point pen;
    int16_t penW, penH;
    Boolean penGray;
    int16_t txFont, txSize, txFace, txMode;
} GWorld, *GWorldPtr, *CGrafPtr;

/* ------------------------------------------------------------------ */
/* QuickDraw */

enum { blackColor = 33, whiteColor = 30 };
enum { srcCopy = 0, srcOr = 1 };
enum { normal = 0, bold = 1 };

extern GWorldPtr thePort;
extern int32_t randSeed;

void SetRect(Rect *r, int left, int top, int right, int bottom);
void OffsetRect(Rect *r, int dh, int dv);
void InsetRect(Rect *r, int dh, int dv);
Boolean PtInRect(Point p, const Rect *r);
Boolean SectRect(const Rect *a, const Rect *b, Rect *out);

GWorldPtr NewGWorld(int width, int height);
void DisposeGWorld(GWorldPtr gw);
void SetGWorld(GWorldPtr port);

void ForeColor(int color);
void BackColor(int color);
void RGBForeColor(const RGBColor *c);
void GetForeColor(RGBColor *c);
void PaintRect(const Rect *r);
void EraseRect(const Rect *r);
void InvertRect(const Rect *r);
void InvertOval(const Rect *r);
void FrameRect(const Rect *r);
void FrameRoundRect(const Rect *r, int ovalW, int ovalH);
void PaintRoundRect(const Rect *r, int ovalW, int ovalH);
void PenNormal(void);
void PenSize(int w, int h);
void PenPatGray(void);
void MoveTo(int h, int v);
void LineTo(int h, int v);
void SetCPixel(int h, int v, const RGBColor *c);
void CopyBits(GWorldPtr src, GWorldPtr dst, const Rect *srcRect, const Rect *dstRect,
              int mode, RgnHandle maskRgn);
int16_t Random(void);

/* Pictures are the extracted PICT resources. DrawPicture scales to dst. */
typedef struct Picture { int16_t id; int w, h; uint32_t *px; } Picture, **PicHandle;
PicHandle GetPicture(int id);
PicHandle GetIconPicture(int id);
void DrawPicture(PicHandle pic, const Rect *dst);
void ReleasePicture(PicHandle pic);
Rect PictureFrame(PicHandle pic);

RgnHandle NewRgn(void);
void DisposeRgn(RgnHandle r);
void SetEmptyRgn(RgnHandle r);
void RectRgn(RgnHandle r, const Rect *rect);
void SetRectRgn(RgnHandle r, int left, int top, int right, int bottom);
void OffsetRgn(RgnHandle r, int dh, int dv);
void CopyRgn(RgnHandle src, RgnHandle dst);
void UnionRgn(RgnHandle a, RgnHandle b, RgnHandle dst);
void DiffRgn(RgnHandle a, RgnHandle b, RgnHandle dst);
Boolean PtInRgn(Point p, RgnHandle r);
void BitMapToRegion(RgnHandle r, GWorldPtr gw);
void GetClip(RgnHandle r);
void SetClip(RgnHandle r);

/* Text: font 0 = system font (Chicago), 1 = application font (Geneva). */
void TextFont(int font);
void TextFace(int face);
void TextMode(int mode);
void TextSize(int size);
int StringWidth(const char *macRomanString);
void DrawString(const char *macRomanString);

/* ------------------------------------------------------------------ */
/* Events */

typedef struct {
    int16_t what;
    uint32_t message;
    uint32_t when;
    Point where;
    uint16_t modifiers;
} EventRecord;

enum { nullEvent = 0, mouseDown = 1, mouseUp = 2, keyDown = 3, keyUp = 4, autoKey = 5,
       updateEvt = 6, diskEvt = 7, activateEvt = 8, osEvt = 15 };
enum { cmdKey = 0x100, shiftKey = 0x200, alphaLock = 0x400, optionKey = 0x800 };
enum { charCodeMask = 0xFF, everyEvent = 0xFFFF };

typedef uint8_t KeyMap[16];

uint32_t TickCount(void);
void GetKeys(KeyMap keys);
Boolean KeyDown(const KeyMap keys, int macKeyCode);
Boolean Button(void);
Boolean GetNextEvent(int mask, EventRecord *ev);
Boolean GetOSEvent(int mask, EventRecord *ev);
void FlushEvents(int whatMask, int stopMask);
void GetMouse(Point *p);
enum { inDesk = 0, inMenuBar = 1, inSysWindow = 2, inContent = 3, inDrag = 4 };
int FindWindow(Point p);
void HideCursor(void);
void ShowCursor(void);

/* ------------------------------------------------------------------ */
/* Menus */

typedef struct MenuItemDef { const char *text; char key; Boolean enabled; Boolean checked; } MenuItemDef;
typedef struct Menu {
    int16_t id;
    const char *title;
    Boolean enabled;
    int nitems;
    MenuItemDef items[8];
} Menu, **MenuHandle;

void InstallMenuBar(void);
MenuHandle GetMenuHandle(int id);
void EnableItem(MenuHandle m, int item);
void DisableItem(MenuHandle m, int item);
void CheckItem(MenuHandle m, int item, Boolean checked);
void DrawMenuBar(void);
void HiliteMenu(int id);
int32_t MenuSelect(Point start);
int32_t MenuKey(char ch);

/* ------------------------------------------------------------------ */
/* Dialogs */

typedef struct Dialog *DialogPtr;
typedef void (*UserItemProc)(DialogPtr d, int item);

DialogPtr GetNewDialog(int id);
void DrawDialog(DialogPtr d);
void DisposeDialog(DialogPtr d);
void ModalDialog(int *itemHit);
void GetDialogItemRect(DialogPtr d, int item, Rect *r);
void SetDialogItemProc(DialogPtr d, int item, UserItemProc proc);
void GetDialogItemText(DialogPtr d, int item, char *out, int outSize);
GWorldPtr DialogPort(DialogPtr d); /* local-coordinate port of the dialog */

/* ------------------------------------------------------------------ */
/* Sound and resources */

typedef struct SndChannel *SndChannelPtr;
SndChannelPtr SndNewChannel(void);
void SndDisposeChannel(SndChannelPtr chan);
void SndPlay(SndChannelPtr chan, int sndID, Boolean async);
Boolean SndChannelBusy(SndChannelPtr chan);
int GetSoundVol(void);

/* Returns a malloc'd copy of TEXT resource `id` (NUL-terminated) or NULL. */
char *GetTextResource(int id);

/* ------------------------------------------------------------------ */
/* Platform */

int PlatformInit(void);
void PlatformQuit(void);
GWorldPtr ScreenPort(void);   /* the 640x480 screen the window draws into */
void PlatformYield(void);     /* present the screen and let the host run */
void ExitToShell(void);

#endif
