/*
 * Stardust 1.1 (c) 1995 James Burton: the game, translated routine by
 * routine from the 68k code. See stardust.h for conventions.
 */
#include <stdlib.h>
#include <string.h>

#include "mac.h"
#include "stardust.h"

/* ------------------------------------------------------------------ */
/* Globals, by A5 offset */

static int16_t heroX, heroY;              /* -0x3C6, -0x3C4 */
static uint8_t heroState;                 /* -0x3C2 */
static Boolean facingRight;               /* -0x3C1 */
static Boolean justWarped;                /* -0x3C0: don't warp straight back */
static uint8_t heroKind;                  /* -0x3BD: 0 = XY hero, 1 = XX hero */
static uint8_t heroKindSetting;           /* -0x3BE */
static uint8_t grid[18][14];              /* -0x3BC: grid[x][y], border included */
static Boolean cursorVisible;             /* -0x2C0 */
static Boolean titleFirstDraw;            /* -0x2BE */
static const char *levelNames[51];        /* -0x2BC */
static const char *passwords[51];         /* -0x2B8, stored Atbash-encoded */
static RgnHandle logoRgn;                 /* -0x2B4 */
static RgnHandle clipMinusLogo;           /* -0x2B0 */
static RgnHandle scratchRgn;              /* -0x2AC */
static RgnHandle savedClip;               /* -0x2A8 */
static int16_t titleMode;                 /* -0x2A4 */
static Point chaosPoint;                  /* -0x2A2 */
static Point chaosVertex[4];              /* -0x29E.. [1..3] */
typedef struct { Point pos1, vel1, pos2, vel2; } Bouncer;
static Bouncer bouncers[6];               /* -0x2A2 + 16*i, i = 1..5 */
static Point dotA, dotB, dotVelA, dotVelB;/* -0x242, -0x23E, -0x23A, -0x236 */
static int16_t logoFrame;                 /* -0x232 */
static int16_t titleCounter;              /* -0x230 */
static uint32_t nextLogoTick;             /* -0x22E */
static Rect logoRects[4];                 /* -0x232 + 8*i, i = 1..3 */
static Rect logoDst;                      /* -0x212 */
static uint32_t nextFrameTime;            /* -0x20A */
typedef struct { Boolean active; int16_t x, y, frame; uint32_t time; } Fallwall;
static Fallwall fallwalls[21];            /* -0x210 + 12*i, i = 1..20 */
static Boolean screenShown;               /* -0x206 */
static Boolean firstEntrance;             /* -0x205 */
static int16_t animDelay;                 /* -0x114 */
static int16_t walkDelay;                 /* -0x112 */
static int16_t fallDelay;                 /* -0x110 */
static int16_t blockDelay;                /* -0x10E */
static int16_t victoryDelay;              /* -0x10C */
static int16_t fallwallDelay;             /* -0x10A */
static uint32_t turnTime;                 /* -0x108 */
static int16_t level;                     /* -0x3CC */
static uint8_t speed;                     /* -0x3CA: 0 fast, 1 slow, 2 normal */
static Boolean soundOn;                   /* -0x3C9 */
static Boolean partialSound;              /* -0x3C8 */
static Boolean soundUnavailable;          /* -0x3C7 */
static SndChannelPtr channels[6];         /* -0x422 + 4*i, i = 1..5 */
static Rect screenRect;                   /* -0x42A */
static GWorldPtr window;                  /* -0x432 */
static Boolean menusVisible;              /* -0x437 */
static Boolean levelDone;                 /* -0x438 */
static Boolean inGame;                    /* -0x439 */
static Boolean running;                   /* -0x43A */
static RgnHandle tempRgn;                 /* -0x43E */
static RgnHandle heroMask;                /* -0x442 */
static RgnHandle levelRgn;                /* -0x446 */
static GWorldPtr heroGW;                  /* -0x44A */
static GWorldPtr tilesGW;                 /* -0x44E */
static GWorldPtr levelGW;                 /* -0x452: level picture, also the logos */
static GWorldPtr backGW;                  /* -0x456 */

/* Pascal sets of grid codes, from the constants at 0x3946.. and 0x47EE.. */
#define SET(c) (1u << (c))
static const uint32_t kPassUp = SET(0) | SET(9) | SET(14) | SET(15);                 /* 3946 */
static const uint32_t kPassElevator = kPassUp | SET(13);                               /* 3948 */
static const uint32_t kPassLeft = kPassElevator | SET(3) | SET(4) | SET(11);           /* 394A */
static const uint32_t kPassRight = kPassElevator | SET(3) | SET(4) | SET(12);          /* 394C */
static const uint32_t kFallThrough = SET(0) | SET(3) | SET(4) | SET(7) | SET(9) | SET(14) | SET(15); /* 47EE */
static Boolean In(uint32_t set, int code) { return code >= 0 && code < 32 && (set >> code & 1); }

static int16_t Abs16(int16_t v) { return v < 0 ? (int16_t)-v : v; }
static Boolean KeysDown(const KeyMap k, int a, int b) { return KeyDown(k, a) || KeyDown(k, b); }

enum { kLeftArrow = 0x7B, kRightArrow = 0x7C, kDownArrow = 0x7D, kUpArrow = 0x7E,
       kKeyA = 0x00, kKeyS = 0x01, kKeyD = 0x02, kKeyW = 0x0D, kKeyQ = 0x0C,
       kKeyI = 0x22, kKeyJ = 0x26, kKeyM = 0x2E, kSpace = 0x31, kReturn = 0x24 };

/* The "click mouse or hit spacebar" wait that several screens share. */
static void WaitForClickOrKey(void)
{
    KeyMap keys;
    GetKeys(keys);
    while (!Button() && !KeyDown(keys, kSpace) && !KeyDown(keys, kKeyQ) && !KeyDown(keys, kReturn)) {
        GetKeys(keys);
        FlushEvents(everyEvent, 0);
    }
}

/* ------------------------------------------------------------------ */
/* Sound */

/* fn0310: play on the first idle channel of 1-4, if any. */
static void PlaySoundAsync(int id)
{
    int i = 1;
    Boolean busy = false;
    for (;;) {
        busy = SndChannelBusy(channels[i]);
        if (!busy)
            break;
        if (++i > 4) {
            i = 4;
            break;
        }
    }
    if (!busy)
        SndPlay(channels[i], id, true);
}

/* fn03D2. Sounds below 200 play synchronously on channel 5. */
static void PlaySound(int id)
{
    /* Set at 0x43E: sounds skipped with "Partial Sound". */
    static const int partialSkips[] = {112, 207, 208, 209, 211, 212, 214};
    if (id == 108 && partialSound)
        id = 111;
    Boolean skippable = false;
    for (size_t i = 0; i < sizeof partialSkips / sizeof *partialSkips; i++)
        if (partialSkips[i] == id)
            skippable = true;
    if (skippable && partialSound)
        return;
    if (!soundOn)
        return;
    if (id < 200)
        SndPlay(channels[5], id, false);
    else
        PlaySoundAsync(id);
}

/* fn0384: a random number from 1 to n. */
static int16_t Random1(int16_t n)
{
    int16_t r = (int16_t)(Random() % n);
    return (int16_t)(Abs16(r) + 1);
}

/* fn03AA, fn03B8, fn03CA */
static void HideCursorOnce(void)
{
    if (cursorVisible) {
        HideCursor();
        cursorVisible = false;
    }
}

static void ShowCursorOnce(void)
{
    if (!cursorVisible) {
        ShowCursor();
        cursorVisible = true;
    }
}

static void CursorIsVisible(void) { cursorVisible = true; }

/* ------------------------------------------------------------------ */
/* Title screen */

/* fn045E: The Plot / Simple Instructions (PICT 301, 303). */
static void ShowInfoPicture(int n)
{
    PicHandle pic = GetPicture(300 + n);
    SetGWorld(window);
    if (!pic)
        return;
    Rect r;
    SetRect(&r, 0, 20, 640, 480);
    DrawPicture(pic, &r);
    ReleasePicture(pic);
    PlaySound(107);
    WaitForClickOrKey();
}

/* fn0506: build the logo region used to keep effects off the logo. */
static void InitLogoRegion(void)
{
    titleFirstDraw = true;
    PicHandle pic = GetPicture(100);
    Rect r = PictureFrame(pic);
    GWorldPtr gw = NewGWorld(r.right, r.bottom);
    SetGWorld(gw);
    DrawPicture(pic, &r);
    ReleasePicture(pic);
    logoRgn = NewRgn();
    savedClip = NewRgn();
    GetClip(savedClip);
    clipMinusLogo = NewRgn();
    BitMapToRegion(logoRgn, gw);
    OffsetRgn(logoRgn, 84, 100);
    SetGWorld(window);
    DisposeGWorld(gw);
    GetClip(savedClip);
    CopyRgn(logoRgn, clipMinusLogo);
    DiffRgn(savedClip, logoRgn, clipMinusLogo);
}

/* fn061E: draw the logo frames and reset the title effects. */
static void InitTitle(void)
{
    SetGWorld(levelGW);
    for (int i = 1; i <= 3; i++) {
        PicHandle pic = GetPicture(100 + i);
        Rect f = PictureFrame(pic);
        int h = f.bottom - f.top, w = f.right - f.left;
        SetRect(&logoRects[i], 0, (i - 1) * h, w, i * h);
        DrawPicture(pic, &logoRects[i]);
        ReleasePicture(pic);
    }
    SetGWorld(backGW);
    BackColor(whiteColor);
    ForeColor(blackColor);
    PaintRect(&screenRect);
    SetRect(&logoDst, 84, 100, logoRects[1].right + 84 - logoRects[1].left,
            logoRects[1].bottom + 100 - logoRects[1].top);
    CopyBits(levelGW, backGW, &logoRects[1], &logoDst, srcCopy, NULL);
    SetGWorld(window);

    titleMode = 1;
    chaosPoint = (Point){240, 320};
    chaosVertex[1] = (Point){21, 320};
    chaosVertex[2] = (Point){475, 21};
    chaosVertex[3] = (Point){475, 619};
    logoFrame = 1;
    nextLogoTick = 0;
    bouncers[1].vel1 = (Point){5, -8};
    bouncers[2].vel1 = (Point){9, -9};
    bouncers[3].vel1 = (Point){5, 9};
    bouncers[4].vel1 = (Point){-12, 8};
    bouncers[5].vel1 = (Point){-5, -5};
    for (int i = 1; i <= 5; i++) {
        Bouncer *b = &bouncers[i];
        b->pos1 = (Point){240, 320};
        b->pos2 = b->pos1;
        b->vel2 = b->vel1;
    }
    titleCounter = 0;
}

/* fn07DE: a click on the title screen switches effect and starts over. */
static void RestartTitle(void)
{
    titleMode = (int16_t)(4 - titleMode);
    SetGWorld(backGW);
    ForeColor(blackColor);
    BackColor(whiteColor);
    PaintRect(&screenRect);
    CopyBits(levelGW, backGW, &logoRects[1], &logoDst, srcCopy, NULL);
    SetGWorld(window);
    Rect r;
    SetRect(&r, 0, 20, 640, 480);
    CopyBits(backGW, window, &r, &r, srcCopy, NULL);
    for (int i = 1; i <= 5; i++) {
        Bouncer *b = &bouncers[i];
        b->pos1 = (Point){240, 320};
        do
            b->vel1.h = (int16_t)(Abs16(Random1(27)) - 13);
        while (Abs16(b->vel1.h) < 5);
        do
            b->vel1.v = (int16_t)(Abs16(Random1(27)) - 13);
        while (Abs16(b->vel1.v) < 5);
        b->pos2 = b->pos1;
        b->vel2 = b->vel1;
    }
    titleCounter = 0;
    dotA = (Point){240, 320};
    dotB = dotA;
    do
        dotVelA.h = (int16_t)(Abs16(Random1(51)) - 25);
    while (Abs16(dotVelA.h) < 2);
    do
        dotVelA.v = (int16_t)(Abs16(Random1(51)) - 25);
    while (Abs16(dotVelA.v) < 2);
    do
        dotVelB.h = (int16_t)(Abs16(Random1(51)) - 25);
    while (Abs16(dotVelB.h) < 2 || dotVelB.h == dotVelA.h);
    do
        dotVelB.v = (int16_t)(Abs16(Random1(51)) - 25);
    while (Abs16(dotVelB.v) < 2 || dotVelB.v == dotVelA.v);
}

/* fn0A5E */
static Point Midpoint(Point a, Point b)
{
    Point m;
    m.v = (int16_t)((a.v + b.v) / 2);
    m.h = (int16_t)((a.h + b.h) / 2);
    return m;
}

/* fn0A90: move a point and bounce it off the screen edges. */
static void Bounce(Point *pos, Point *vel)
{
    pos->v += vel->v;
    pos->h += vel->h;
    if (pos->h < 0) {
        pos->h = 0;
        vel->h = Abs16(vel->h);
    }
    if (pos->v < 21) {
        pos->v = 21;
        vel->v = Abs16(vel->v);
    }
    if (pos->h > 640) {
        pos->h = 640;
        vel->h = (int16_t)-Abs16(vel->h);
    }
    if (pos->v > 480) {
        pos->v = 480;
        vel->v = (int16_t)-Abs16(vel->v);
    }
}

static RGBColor RandomShade(void)
{
    RGBColor c;
    c.red = 0;
    c.blue = (uint16_t)(-1 - (Random1(4) - 1) * 10000);
    c.green = (uint16_t)(-1 - (Random1(4) - 1) * 10000);
    return c;
}

/* fn0B0C: one step of the title screen animation. */
static void TitleStep(void)
{
    if (!titleFirstDraw) {
        switch (titleMode) {
        case 1: { /* Sierpinski triangle by the chaos game */
            chaosPoint = Midpoint(chaosPoint, chaosVertex[Random1(3)]);
            if (PtInRgn(chaosPoint, logoRgn)) {
                SetGWorld(window);
                break;
            }
            RGBColor c = RandomShade();
            SetGWorld(backGW);
            SetCPixel(chaosPoint.h, chaosPoint.v, &c);
            SetGWorld(window);
            SetCPixel(chaosPoint.h, chaosPoint.v, &c);
            break;
        }
        case 2: { /* bouncing polygon with an erasing trail (unreachable: mode toggles 1 <-> 3) */
            if (++titleCounter > 3000)
                titleCounter = 2000;
            for (int i = 1; i <= 5; i++)
                Bounce(&bouncers[i].pos1, &bouncers[i].vel1);
            if (titleCounter > 5)
                for (int i = 1; i <= 5; i++)
                    Bounce(&bouncers[i].pos2, &bouncers[i].vel2);
            RGBColor c = RandomShade();
            RGBForeColor(&c);
            SetGWorld(backGW);
            SetClip(clipMinusLogo);
            MoveTo(bouncers[5].pos1.h, bouncers[5].pos1.v);
            for (int i = 1; i <= 5; i++)
                LineTo(bouncers[i].pos1.h, bouncers[i].pos1.v);
            MoveTo(bouncers[5].pos2.h, bouncers[5].pos2.v);
            for (int i = 1; i <= 5; i++)
                LineTo(bouncers[i].pos2.h, bouncers[i].pos2.v);
            SetClip(savedClip);
            SetGWorld(window);
            SetClip(clipMinusLogo);
            MoveTo(bouncers[5].pos1.h, bouncers[5].pos1.v);
            for (int i = 1; i <= 5; i++)
                LineTo(bouncers[i].pos1.h, bouncers[i].pos1.v);
            ForeColor(blackColor);
            MoveTo(bouncers[5].pos2.h, bouncers[5].pos2.v);
            for (int i = 1; i <= 5; i++)
                LineTo(bouncers[i].pos2.h, bouncers[i].pos2.v);
            SetClip(savedClip);
            break;
        }
        case 3: { /* midpoint of two bouncing dots */
            Bounce(&dotA, &dotVelA);
            Bounce(&dotB, &dotVelB);
            chaosPoint = Midpoint(dotA, dotB);
            SetGWorld(window);
            SetGWorld(backGW);
            RGBColor c;
            c.green = 0;
            c.blue = (uint16_t)(1 - (Random1(4) - 1) * 10000);
            c.red = (uint16_t)(1 - (Random1(4) - 1) * 10000);
            if (!PtInRgn(chaosPoint, logoRgn))
                SetCPixel(chaosPoint.h, chaosPoint.v, &c);
            SetGWorld(window);
            if (!PtInRgn(chaosPoint, logoRgn))
                SetCPixel(chaosPoint.h, chaosPoint.v, &c);
            break;
        }
        }
    }

    /* The logo shimmers A, B, C, B every 20 ticks. */
    if (TickCount() > nextLogoTick) {
        nextLogoTick = TickCount() + 20;
        if (++logoFrame > 4)
            logoFrame = 1;
        if (logoFrame < 4)
            CopyBits(levelGW, window, &logoRects[logoFrame], &logoDst, srcCopy, logoRgn);
        else
            CopyBits(levelGW, window, &logoRects[2], &logoDst, srcCopy, logoRgn);
        if (titleFirstDraw) {
            titleFirstDraw = false;
            PlaySound(101);
        }
    }
}

/* ------------------------------------------------------------------ */
/* Dialogs */

/* export 6 (fn0F12): user item that outlines the default button. */
static void OutlineDefaultButton(DialogPtr d, int item)
{
    (void)item;
    Rect r;
    GetDialogItemRect(d, 1, &r);
    GWorldPtr save = thePort;
    SetGWorld(DialogPort(d));
    int16_t penW = thePort->penW, penH = thePort->penH;
    Boolean penGray = thePort->penGray;
    PenNormal();
    InsetRect(&r, -4, -4);
    FrameRoundRect(&r, 16, 16);
    int corner = (r.bottom - r.top) / 2 + 2;
    thePort->penGray = false; /* PenPat(qd.black) */
    PenSize(3, 3);
    FrameRoundRect(&r, corner, corner);
    thePort->penW = penW, thePort->penH = penH, thePort->penGray = penGray;
    SetGWorld(save);
}

/* fn1122: passwords are stored with A..Z mirrored (Atbash). */
static void Atbash(const char *in, char *out)
{
    size_t n = strlen(in);
    for (size_t i = 0; i < n; i++)
        out[i] = (char)(0x9B - (unsigned char)in[i]);
    out[n] = 0;
}

/* fn0FA4: "Start At Level..." Returns the level, or 0. */
static int AskForPassword(void)
{
    ShowCursorOnce();
    DialogPtr d = GetNewDialog(130);
    SetDialogItemProc(d, 6, OutlineDefaultButton);
    int item = 0;
    while (item != 2 && item != 1)
        ModalDialog(&item);
    if (item == 2) {
        DisposeDialog(d);
        return 0;
    }
    char typed[256], encoded[256];
    GetDialogItemText(d, 3, typed, sizeof typed);
    Atbash(typed, encoded);
    if (!encoded[0]) {
        DisposeDialog(d);
        return 0;
    }
    DisposeDialog(d);
    int found = 0;
    for (int i = 1; i <= 50; i++)
        if (strcmp(passwords[i], encoded) == 0)
            found = i;
    if (found == 0) {
        d = GetNewDialog(131);
        DrawDialog(d);
        PlaySound(105);
        WaitForClickOrKey();
        DisposeDialog(d);
    }
    return found;
}

/* fn1182: "Are you sure you want to end this game?" */
static Boolean ConfirmEndGame(void)
{
    ShowCursorOnce();
    DialogPtr d = GetNewDialog(129);
    SetDialogItemProc(d, 5, OutlineDefaultButton);
    int item = 0;
    while (item != 2 && item != 1)
        ModalDialog(&item);
    DisposeDialog(d);
    return item == 1;
}

/* fn11FE */
static void InitStrings(void)
{
    static const char *names[] = {
        "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten",
        "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen",
        "Nineteen", "Twenty", "Twenty-One", "Twenty-Two", "Twenty-Three", "Twenty-Four", "Twenty-Five",
        "Twenty-Six", "Twenty-Seven", "Twenty-Eight", "Twenty-Nine", "Thirty", "Thirty-One",
        "Thirty-Two", "Thirty-Three", "Thirty-Four", "Thirty-Five", "Thirty-Six", "Thirty-Seven",
        "Thirty-Eight", "Thirty-Nine", "Forty", "Forty-One", "Forty-Two", "Forty-Three", "Forty-Four",
        "Forty-Five", "Forty-Six", "Forty-Seven", "Forty-Eight", "Forty-Nine", "Fifty"};
    static const char *codes[] = {
        "VSOMV", "XVMVMXRLM", "VXFRG", "HLYVX", "GRMGVP", "GLNRIZFM", "ZVGFURYFO", "KZOUBGI",
        "EVIMVHOVXH", "XVIRX", "TILR", "ILMLR", "FORNR", "IVGZRNZ", "BRGS", "HRRH", "ZRTZ", "YVOZY",
        "XVOWIZ", "EZMFOX", "HRIVZ", "OFMGZGZH", "NVMWZTVB", "UVIFORX", "IZFMGVX", "MZIZVOV", "IFHGFM",
        "XLNZOWVH", "HZVWZOFW", "WLWR", "PRMWFV", "YZSNYFZ", "MLISWBGV", "PZOZERNZM", "IZFWZH",
        "WZVNLMWIZ", "NRMROVU", "YZOAVYFIVY", "NZORTLKZMB", "WVVNZ", "OREVIRTFH", "HLIRHR", "EROZMRZ",
        "RIHFWR", "WZROVSO", "GRSORO", "HFNVI", "NFOFILH", "YIRMGLQFN",
        "" /* level 50 has no password */};
    for (int i = 1; i <= 50; i++) {
        levelNames[i] = names[i - 1];
        passwords[i] = codes[i - 1];
    }
    scratchRgn = NewRgn();
}

/* ------------------------------------------------------------------ */
/* Level screens */

/* fn1C1A: "Level N:" and its password. */
static void ShowLevelTitle(int lvl, Boolean newGame)
{
    char title[256], pw[256];
    strcpy(title, "Level ");
    strcat(title, levelNames[lvl]);
    strcat(title, ":");
    SetGWorld(window);
    RGBColor c = {0, 0x4E20, 0};
    RGBForeColor(&c);
    BackColor(blackColor);
    EraseRect(&screenRect);
    TextFont(1);
    TextFace(normal);
    TextMode(srcOr);
    TextSize(64);
    MoveTo(320 - StringWidth(title) / 2 + 2, 122);
    DrawString(title);
    c.blue = 0, c.green = 0xFFFF;
    RGBForeColor(&c);
    MoveTo(320 - StringWidth(title) / 2, 120);
    DrawString(title);

    Atbash(passwords[lvl], pw);
    TextSize(80);
    for (int size = 80; StringWidth(pw) > 640;)
        TextSize(--size);
    c.green = 0, c.blue = 0xFFFF, c.red = 0xFFFF;
    RGBForeColor(&c);
    MoveTo(320 - StringWidth(pw) / 2, 270);
    DrawString(pw);

    c.green = 0, c.blue = 0, c.red = 0xD8F0;
    RGBForeColor(&c);
    const char *click = "click mouse or hit spacebar to continue";
    TextSize(9);
    MoveTo(320 - StringWidth(click) / 2, 478);
    DrawString(click);
    PlaySound(newGame ? 108 : 111);
    WaitForClickOrKey();
    ForeColor(blackColor);
    BackColor(whiteColor);
    menusVisible = false;
}

/* from + (to - from) * i / div in THINK Pascal 16-bit Integer arithmetic:
 * the product wraps before the division (muls.w; ext.l; divs.w). */
static int16_t Lerp16(int from, int to, int i, int div)
{
    int16_t product = (int16_t)((int16_t)(to - from) * i);
    return (int16_t)(from + (int16_t)(product / div));
}

/* fn1E92: black rectangle growing out of the exit portal. */
static void LevelWipe(void)
{
    SetGWorld(window);
    uint32_t next = 0;
    ForeColor(blackColor);
    BackColor(whiteColor);
    Rect from, r;
    SetRect(&from, heroX * 40 - 40, heroY * 40 - 40, heroX * 40, heroY * 40);
    for (int i = 1; i <= 100; i++) {
        while (TickCount() < next)
            FlushEvents(everyEvent, 0);
        next = TickCount() + 1;
        r.top = Lerp16(from.top, screenRect.top, i, 50);
        r.bottom = Lerp16(from.bottom, screenRect.bottom, i, 50);
        r.left = Lerp16(from.left, screenRect.left, i, 50);
        r.right = Lerp16(from.right, screenRect.right, i, 50);
        PaintRect(&r);
    }
}

/* fn1F82: the final flash around the two reunited heroes. The original
 * ran these loops without waiting, as fast as the Mac could draw; each
 * step is presented here so the effect stays visible on modern machines. */
static void VictoryFlash(void)
{
    SetGWorld(window);
    GetClip(savedClip);
    SetRectRgn(scratchRgn, heroX * 40 - 80, heroY * 40 - 40, heroX * 40, heroY * 40);
    DiffRgn(savedClip, scratchRgn, scratchRgn);
    SetClip(scratchRgn);
    Point c;
    c.h = (int16_t)(heroX * 40 + 7 - 40);
    c.v = (int16_t)(heroY * 40 + 20 - 40);
    Rect r;
    for (int i = 1; i <= 54; i++) {
        r.top = Lerp16(c.v, screenRect.top, i, 36);
        r.bottom = Lerp16(c.v, screenRect.bottom, i, 36);
        r.left = Lerp16(c.h, screenRect.left, i, 36);
        r.right = Lerp16(c.h, screenRect.right, i, 36);
        InvertRect(&r);
        InvertOval(&r);
        PlatformYield();
    }
    for (int i = 1; i <= 50; i++) {
        r.top = Lerp16(c.v, screenRect.top, i, 50);
        r.bottom = Lerp16(c.v, screenRect.bottom, i, 50);
        r.left = Lerp16(c.h, screenRect.left, i, 50);
        r.right = Lerp16(c.h, screenRect.right, i, 50);
        PaintRect(&r);
        PlatformYield();
    }
    SetClip(savedClip);
}

/* fn2104: the closing picture. */
static void ShowVictory(void)
{
    uint32_t t = TickCount();
    while (t > TickCount())
        FlushEvents(everyEvent, 0);
    PicHandle pic = GetPicture(305);
    SetGWorld(window);
    DrawPicture(pic, &screenRect);
    ReleasePicture(pic);
    PlaySound(109);
    WaitForClickOrKey();
    PlaySound(206);
}

/* ------------------------------------------------------------------ */
/* Drawing the playfield */

/* fn21B0 */
static void BlitToWindow(const Rect *r)
{
    SetGWorld(window);
    CopyBits(backGW, window, r, r, srcCopy, NULL);
}

static void DrawCell(int x, int y);
static void DrawTile(const Rect *src, const Rect *dst);
static void TileRect(Rect *r, int col, int row, int flip);

/* fn21F6: advance a crumbling fallwall. */
static void FallwallStep(Fallwall *fw)
{
    if (grid[fw->x][fw->y] != kFallwall)
        return;
    Rect dst, src;
    TileRect(&dst, fw->x, fw->y, 0);
    if (++fw->frame < 8)
        fw->frame = 8;
    if (fw->frame > 10) {
        grid[fw->x][fw->y] = kEmpty;
        DrawCell(fw->x, fw->y);
        BlitToWindow(&dst);
        fw->active = false;
    } else {
        TileRect(&src, 5, fw->frame, 0);
        DrawTile(&src, &dst);
        BlitToWindow(&dst);
        fw->active = true;
        fw->time = TickCount() + fallwallDelay;
    }
}

/* fn394E: repaint one grid cell in the back buffer. */
static void DrawCell(int x, int y)
{
    Rect r;
    TileRect(&r, x, y, 0);
    SetGWorld(backGW);
    if (grid[x][y] == kEmpty)
        PaintRect(&r);
    else
        CopyBits(levelGW, backGW, &r, &r, srcCopy, NULL);
}

/* fn39B6: draw a hero frame through the mask region. */
static void DrawHero(const Rect *src, const Rect *dst)
{
    OffsetRgn(heroMask, dst->left - src->left, dst->top - src->top);
    CopyBits(heroGW, backGW, src, dst, srcCopy, heroMask);
    OffsetRgn(heroMask, src->left - dst->left, src->top - dst->top);
}

/* fn3A2E: wait for the frame time, show `r`, then service fallwalls. */
static void ShowRect(const Rect *r, int delay)
{
    while (TickCount() < nextFrameTime) {}
    SetGWorld(window);
    CopyBits(backGW, window, r, r, srcCopy, NULL);
    nextFrameTime = TickCount() + delay;
    for (int i = 1; i <= 20; i++)
        if ((TickCount() >= fallwalls[i].time) & fallwalls[i].active) /* Pascal "and": no short circuit */
            FallwallStep(&fallwalls[i]);
}

/* fn3ADE, fn3B48, fn3BB6: 40x40, 80x40 and 40x80 cells. A positive `flip`
 * mirrors the rect within that width (the hero sheet's left-facing half). */
static void Mirror(Rect *r, int flip)
{
    if (flip > 0) {
        int left = r->left;
        r->left = (int16_t)(flip - r->right);
        r->right = (int16_t)(flip - left);
    }
}

static void TileRect(Rect *r, int col, int row, int flip)
{
    SetRect(r, col * 40 - 40, row * 40 - 40, col * 40, row * 40);
    Mirror(r, flip);
}

static void WideRect(Rect *r, int col, int row, int flip)
{
    SetRect(r, col * 40 - 40, row * 40 - 40, col * 40 + 40, row * 40);
    Mirror(r, flip);
}

static void TallRect(Rect *r, int col, int row, int flip)
{
    SetRect(r, col * 40 - 40, row * 40 - 40, col * 40, row * 40 + 40);
    Mirror(r, flip);
}

/* fn3C24, fn3C62, fn3CA0: hero sheet frames for the way the hero faces. */
static void HeroFrame(Rect *r, int col, int row) { TileRect(r, col, row, facingRight ? 0 : 480); }
static void HeroFrameWide(Rect *r, int col, int row) { WideRect(r, col, row, facingRight ? 0 : 480); }
static void HeroFrameTall(Rect *r, int col, int row) { TallRect(r, col, row, facingRight ? 0 : 480); }

/* fn3CDE */
static void DrawTile(const Rect *src, const Rect *dst)
{
    SetGWorld(backGW);
    CopyBits(tilesGW, backGW, src, dst, srcCopy, NULL);
}

/* fn3D2E: the victory sprites replace the tile sheet. */
static void LoadVictoryPicture(void)
{
    DisposeGWorld(tilesGW);
    tilesGW = NewGWorld(160, 680);
    SetGWorld(tilesGW);
    PicHandle pic = GetPicture(134);
    Rect r;
    SetRect(&r, 0, 0, 160, 680);
    DrawPicture(pic, &r);
    ReleasePicture(pic);
    SetGWorld(window);
}

/* fn3DBE: draw a level character into the level picture and set its code. */
static void PlaceTile(char ch, uint8_t *cell, const Rect *dst)
{
    Rect src = {0, 0, 0, 0};
    switch (ch) {
    case '1': TileRect(&src, 1, Abs16((int16_t)(Random() % 9)) + 2, 0); *cell = kStarWall; break;
    case '2': TileRect(&src, 2, Abs16((int16_t)(Random() % 9)) + 2, 0); *cell = kGrayWall; break;
    case '3': TileRect(&src, 4, 10, 0); *cell = kEntrance; break;
    case '4': TileRect(&src, 4, 11, 0); *cell = kExit; break;
    case '5': TileRect(&src, 5, 4, 0); *cell = kWarpPocket; break;
    case '6': TileRect(&src, 5, 5, 0); *cell = kRedBlock; break;
    case '7': TileRect(&src, 5, 6, 0); *cell = kStars; break;
    case '8': TileRect(&src, 5, 7, 0); *cell = kFallwall; break;
    case '!': TileRect(&src, 6, 1, 0); *cell = kLeftWall; break;
    case '@': TileRect(&src, 6, 2, 0); *cell = kRightWall; break;
    case '#': TileRect(&src, 6, 3, 0); *cell = kElevator; break;
    case '$': TileRect(&src, 6, 7, 0); *cell = kTunnel; break;
    case '%': TileRect(&src, 6, 9, 0); *cell = kWarp; break;
    case '(': TileRect(&src, 6, 8, 0); *cell = kVictory; break;
    case '/': TileRect(&src, 4, 10, 0); *cell = kStars; break;
    case '^': TileRect(&src, 6, 10, 0); *cell = kStars; break;
    case '&': TileRect(&src, 6, 11, 0); *cell = kStars; break;
    }
    SetGWorld(levelGW);
    CopyBits(tilesGW, levelGW, &src, dst, srcCopy, NULL);
    SetGWorld(window);
}

/* fn406C: first free fallwall slot (or the last one). */
static int FreeFallwall(void)
{
    for (int i = 1; i <= 20; i++)
        if (!fallwalls[i].active)
            return i;
    return 20;
}

/* fn40A0: the hero stepped onto a fallwall. */
static void StartFallwall(void)
{
    for (int i = 1; i <= 20; i++)
        if (fallwalls[i].active && fallwalls[i].x == heroX && fallwalls[i].y == heroY + 1)
            return;
    int i = FreeFallwall();
    fallwalls[i].active = true;
    fallwalls[i].x = heroX;
    fallwalls[i].y = (int16_t)(heroY + 1);
    fallwalls[i].frame = 0;
    fallwalls[i].time = TickCount() + fallwallDelay;
    PlaySound(210);
}

/* ------------------------------------------------------------------ */
/* The hero: fn22CC performs one action, with its whole animation. */

/* One frame of a hero animation drawn over the cell(s) behind it. */
static void HeroStepFrame(const Rect *src, const Rect *dst, int x1, int y1, int x2, int y2, int delay)
{
    DrawCell(x1, y1);
    if (x2 >= 0)
        DrawCell(x2, y2);
    DrawHero(src, dst);
    ShowRect(dst, delay);
}

/* Tile-sheet animation in column `col`, rows first..last, over `dst`. */
static void TileAnimation(const Rect *dst, int col, int first, int last, int delay)
{
    Rect src;
    for (int i = first; i <= last; i++) {
        TileRect(&src, col, i, 0);
        DrawTile(&src, dst);
        ShowRect(dst, delay);
    }
}

/* A block at (x,y) dissolves through tile column `col`, rows first..last. */
static void EraseBlock(int x, int y, int sound, int col, int first, int last)
{
    Rect dst;
    TileRect(&dst, x, y, 0);
    if (sound)
        PlaySound(sound);
    TileAnimation(&dst, col, first, last, animDelay);
    grid[x][y] = kEmpty;
    DrawCell(x, y);
    ShowRect(&dst, 0);
}

/* A blue block slides out of the hero's hand into (x,y) (2ACA, 2F64).
 * It burns up at once if it lands on a red block. */
static void CreateBlueBlock(int x, int y)
{
    Rect dst, src;
    TileRect(&dst, x, y, 0);
    if (facingRight) {
        TileRect(&src, 2, 11, 0);
        dst.right = dst.left;
        src.left = src.right;
        PlaySound(207);
        for (int i = 1; i <= 8; i++) {
            src.left -= 5;
            dst.right += 5;
            DrawTile(&src, &dst);
            ShowRect(&dst, blockDelay);
        }
        for (int i = 1; i <= 8; i++) {
            OffsetRect(&src, -5, 0);
            DrawTile(&src, &dst);
            ShowRect(&dst, blockDelay);
        }
    } else {
        TileRect(&src, 2, 1, 0);
        dst.left = dst.right;
        src.right = src.left;
        PlaySound(207);
        for (int i = 1; i <= 8; i++) {
            src.right += 5;
            dst.left -= 5;
            DrawTile(&src, &dst);
            ShowRect(&dst, blockDelay);
        }
        for (int i = 1; i <= 8; i++) {
            OffsetRect(&src, 5, 0);
            DrawTile(&src, &dst);
            ShowRect(&dst, blockDelay);
        }
    }
    grid[x][y] = kBlueBlock;
    if (y + 1 < 13 && grid[x][y + 1] == kRedBlock) {
        TileRect(&dst, x, y, 0);
        TileAnimation(&dst, 3, 7, 10, animDelay);
        grid[x][y] = kEmpty;
        DrawCell(x, y);
        ShowRect(&dst, 0);
    }
}

static void HeroAction(int action)
{
    Rect src, dst;
    switch (action) {
    case aStand: /* 22DC */
        HeroFrame(&src, 1, 1);
        TileRect(&dst, heroX, heroY, 0);
        HeroStepFrame(&src, &dst, heroX, heroY, -1, 0, animDelay);
        heroState = kStanding;
        break;

    case aWalk: /* 232A */
        justWarped = false;
        if (facingRight) {
            if (In(kPassRight, grid[heroX + 1][heroY])) {
                WideRect(&dst, heroX, heroY, 0);
                for (int i = 1; i <= 9; i++) {
                    HeroFrameWide(&src, 1, i);
                    HeroStepFrame(&src, &dst, heroX, heroY, heroX + 1, heroY, walkDelay);
                }
                heroX++;
                heroState = kStanding;
                break;
            }
        } else {
            if (In(kPassLeft, grid[heroX - 1][heroY])) {
                WideRect(&dst, heroX - 1, heroY, 0);
                for (int i = 1; i <= 9; i++) {
                    HeroFrameWide(&src, 1, i);
                    HeroStepFrame(&src, &dst, heroX, heroY, heroX - 1, heroY, walkDelay);
                }
                heroX--;
                heroState = kStanding;
                break;
            }
        }
        /* Blocked: bump against the wall. */
        TileRect(&dst, heroX, heroY, 0);
        for (int i = 1; i <= 2; i++) {
            HeroFrame(&src, 1, i);
            HeroStepFrame(&src, &dst, heroX, heroY, -1, 0, walkDelay);
        }
        for (int i = 2; i >= 1; i--) {
            HeroFrame(&src, 1, i);
            HeroStepFrame(&src, &dst, heroX, heroY, -1, 0, walkDelay);
        }
        heroState = kStanding;
        break;

    case aLookUp: /* 259E */
        HeroFrame(&src, 5, 8);
        TileRect(&dst, heroX, heroY, 0);
        HeroStepFrame(&src, &dst, heroX, heroY, -1, 0, animDelay);
        heroState = kLookingUp;
        break;

    case aCrouch: /* 25EE */
        TileRect(&dst, heroX, heroY, 0);
        for (int i = 7; i <= 8; i++) {
            HeroFrame(&src, 3, i);
            HeroStepFrame(&src, &dst, heroX, heroY, -1, 0, animDelay);
        }
        heroState = kCrouching;
        break;

    case aStayCrouched: /* 2646 */
        HeroFrame(&src, 3, 8);
        TileRect(&dst, heroX, heroY, 0);
        HeroStepFrame(&src, &dst, heroX, heroY, -1, 0, animDelay);
        heroState = kCrouching;
        break;

    case aStandUp: /* 2696 */
        TileRect(&dst, heroX, heroY, 0);
        for (int i = 8; i >= 7; i--) {
            HeroFrame(&src, 3, i);
            HeroStepFrame(&src, &dst, heroX, heroY, -1, 0, animDelay);
        }
        heroState = kStanding;
        break;

    case aFall: /* 26EC */
        heroState = kFalling;
        justWarped = false;
        TallRect(&dst, heroX, heroY, 0);
        for (int i = 1; i <= 4; i++) {
            HeroFrameTall(&src, 4, i * 2 - 1);
            HeroStepFrame(&src, &dst, heroX, heroY, heroX, heroY + 1, fallDelay);
        }
        if (++heroY > 12) {
            heroState = kGone;
            PlaySound(110);
        }
        break;

    case aElevator: /* 2780 */
        if (In(kPassElevator, grid[heroX][heroY - 1])) {
            justWarped = false;
            TallRect(&dst, heroX, heroY - 1, 0);
            for (int i = 3; i >= 1; i--) {
                HeroFrameTall(&src, 4, i * 2 - 1);
                HeroStepFrame(&src, &dst, heroX, heroY - 1, heroX, heroY, animDelay);
            }
            heroY--;
            HeroFrame(&src, 4, 8);
            DrawCell(heroX, heroY);
            DrawCell(heroX, heroY + 1);
            TileRect(&dst, heroX, heroY, 0);
            DrawHero(&src, &dst);
            TallRect(&dst, heroX, heroY, 0);
            ShowRect(&dst, fallDelay);
            heroState = kFalling;
        } else {
            /* Blocked above: the elevator gives out. */
            TileRect(&dst, heroX, heroY, 0);
            PlaySound(202);
            for (int i = 4; i <= 6; i++) {
                TileRect(&src, 6, i, 0);
                DrawTile(&src, &dst);
                HeroFrame(&src, 4, 8);
                DrawHero(&src, &dst);
                ShowRect(&dst, animDelay * 2);
            }
            grid[heroX][heroY] = kEmpty;
            DrawCell(heroX, heroY);
            DrawHero(&src, &dst);
            ShowRect(&dst, animDelay * 2);
            heroState = kFalling;
        }
        break;

    case aMagicSide: { /* 2954 */
        TileRect(&dst, heroX, heroY, 0);
        for (int i = 1; i <= 6; i++) {
            HeroFrame(&src, 3, i);
            HeroStepFrame(&src, &dst, heroX, heroY, -1, 0, animDelay);
        }
        int tx = facingRight ? heroX + 1 : heroX - 1;
        switch (grid[tx][heroY]) {
        case kEmpty: CreateBlueBlock(tx, heroY); break;
        case kStarWall: EraseBlock(tx, heroY, 214, 3, 2, 6); break;
        case kBlueBlock: EraseBlock(tx, heroY, 214, 3, 7, 10); break;
        case kGreenBlock: EraseBlock(tx, heroY, 211, 4, 4, 9); break;
        case kWarpPocket: { /* 29CE */
            PlaySound(203);
            TileRect(&dst, tx, heroY, 0);
            if (grid[tx][heroY] == kWarpPocket) {
                TileRect(&src, 5, 11, 0);
                DrawTile(&src, &dst);
                ShowRect(&dst, animDelay);
            }
            grid[tx][heroY] = kEmpty;
            DrawCell(tx, heroY);
            ShowRect(&dst, 0);
            break;
        }
        default: PlaySound(208); break;
        }
        TileRect(&dst, heroX, heroY, 0);
        for (int i = 6; i >= 1; i--) {
            HeroFrame(&src, 3, i);
            HeroStepFrame(&src, &dst, heroX, heroY, -1, 0, animDelay);
        }
        heroState = kStanding;
        break;
    }

    case aMagicDown: { /* 2DFE */
        if (grid[heroX][heroY + 1] == kGreenBlock) {
            /* Crouching on a green block destroys it. */
            TileRect(&dst, heroX, heroY, 0);
            HeroFrame(&src, 3, 9);
            PlaySound(211);
            HeroStepFrame(&src, &dst, heroX, heroY, -1, 0, animDelay);
            TileRect(&dst, heroX, heroY + 1, 0);
            TileAnimation(&dst, 4, 4, 9, animDelay);
            grid[heroX][heroY + 1] = kEmpty;
            DrawCell(heroX, heroY + 1);
            ShowRect(&dst, 0);
            break;
        }
        TileRect(&dst, heroX, heroY, 0);
        for (int i = 1; i <= 4; i++) {
            HeroFrame(&src, 5, i);
            HeroStepFrame(&src, &dst, heroX, heroY, -1, 0, animDelay);
        }
        int tx = facingRight ? heroX + 1 : heroX - 1;
        int ty = heroY + 1;
        switch (grid[tx][ty]) {
        case kEmpty: CreateBlueBlock(tx, ty); break;
        case kStarWall: EraseBlock(tx, ty, 214, 3, 2, 6); break;
        case kBlueBlock: EraseBlock(tx, ty, 214, 3, 7, 10); break;
        case kGreenBlock: EraseBlock(tx, ty, 211, 4, 4, 9); break;
        default: PlaySound(208); break;
        }
        TileRect(&dst, heroX, heroY, 0);
        for (int i = 4; i >= 1; i--) {
            HeroFrame(&src, 5, i);
            HeroStepFrame(&src, &dst, heroX, heroY, -1, 0, animDelay);
        }
        heroState = kCrouching;
        break;
    }

    case aMagicUp: /* 3346 */
        TileRect(&dst, heroX, heroY, 0);
        for (int i = 5; i <= 7; i++) {
            HeroFrame(&src, 5, i);
            HeroStepFrame(&src, &dst, heroX, heroY, -1, 0, animDelay);
        }
        if (grid[heroX][heroY] == kEmpty && In(kPassUp, grid[heroX][heroY - 1]) &&
            grid[heroX][heroY + 1] != kGreenBlock) {
            /* Levitate on a growing green block. */
            PlaySound(209);
            TallRect(&dst, heroX, heroY - 1, 0);
            TallRect(&src, 4, 1, 0);
            if (!facingRight)
                OffsetRect(&src, 40, 0);
            for (int i = 1; i <= 8; i++) {
                OffsetRect(&src, 0, 5);
                DrawTile(&src, &dst);
                ShowRect(&dst, animDelay);
            }
            heroY--;
            grid[heroX][heroY + 1] = kGreenBlock;
        } else if (grid[heroX][heroY - 1] == kGreenBlock) {
            EraseBlock(heroX, heroY - 1, 211, 4, 4, 9);
        } else {
            PlaySound(208);
        }
        TileRect(&dst, heroX, heroY, 0);
        for (int i = 7; i >= 5; i--) {
            HeroFrame(&src, 5, i);
            HeroStepFrame(&src, &dst, heroX, heroY, -1, 0, animDelay);
        }
        heroState = kLookingUp;
        break;

    case aDissolve: /* 35A2: warp pocket or red block */
        justWarped = false;
        TileRect(&dst, heroX, heroY, 0);
        for (int i = 1; i <= 8; i++) {
            HeroFrame(&src, 6, i);
            HeroStepFrame(&src, &dst, heroX, heroY, -1, 0, animDelay);
        }
        DrawCell(heroX, heroY);
        ShowRect(&dst, 0);
        heroState = kGone;
        break;

    case aWarp: { /* 3614: to the next '%' down the column, wrapping */
        int ty = heroY + 1;
        while (grid[heroX][ty] != kWarp)
            if (++ty > 12)
                ty = 1;
        for (int i = 1; i <= 8; i++) {
            TileRect(&dst, heroX, heroY, 0);
            HeroFrame(&src, 6, i);
            HeroStepFrame(&src, &dst, heroX, heroY, -1, 0, 2);
            TileRect(&dst, heroX, ty, 0);
            HeroFrame(&src, 6, 9 - i);
            HeroStepFrame(&src, &dst, heroX, ty, -1, 0, 2);
            TileRect(&dst, heroX, heroY, 0);
        }
        DrawCell(heroX, heroY);
        ShowRect(&dst, 0);
        heroY = (int16_t)ty;
        heroState = kStanding;
        justWarped = true;
        break;
    }

    case aReappear: { /* 370A */
        justWarped = false;
        uint32_t t = TickCount() + 30;
        while (t > TickCount()) {}
        TileRect(&dst, heroX, heroY, 0);
        if (firstEntrance) {
            firstEntrance = false;
            PlaySound(204);
        } else {
            PlaySound(213);
        }
        for (int i = 8; i >= 1; i--) {
            HeroFrame(&src, 6, i);
            HeroStepFrame(&src, &dst, heroX, heroY, -1, 0, animDelay);
        }
        heroState = kStanding;
        break;
    }

    case aExitLevel: /* 3790 */
        justWarped = false;
        TileRect(&dst, heroX, heroY, 0);
        for (int i = 5; i <= 7; i++) {
            HeroFrame(&src, 5, i);
            HeroStepFrame(&src, &dst, heroX, heroY, -1, 0, animDelay);
        }
        PlaySound(201);
        for (int i = 4; i <= 7; i++) {
            HeroFrame(&src, i, 9);
            HeroStepFrame(&src, &dst, heroX, heroY, -1, 0, animDelay * 2);
        }
        heroState = kGone;
        levelDone = true;
        break;

    case aVictory: /* 383A */
        facingRight = false;
        HeroFrame(&src, 1, 1);
        TileRect(&dst, heroX, heroY, 0);
        HeroStepFrame(&src, &dst, heroX, heroY, -1, 0, animDelay);
        WideRect(&dst, heroX - 1, heroY, 0);
        LoadVictoryPicture();
        PlaySound(201);
        for (int i = 1; i <= 17; i++) {
            WideRect(&src, heroKind == 1 ? 3 : 1, i, 0);
            CopyBits(tilesGW, backGW, &src, &dst, srcCopy, NULL);
            ShowRect(&dst, victoryDelay);
        }
        heroState = kWon;
        levelDone = true;
        break;
    }
}

/* fn4162: read the keyboard and pick the hero's next action. */
static void HeroStep(void)
{
    KeyMap k;
    GetKeys(k);
    switch (speed) {
    case 0: /* fast */
        animDelay = 2, fallDelay = 2, walkDelay = 1, fallwallDelay = 2, blockDelay = 1, victoryDelay = 7;
        break;
    case 2: /* normal */
        animDelay = 3;
        fallDelay = (int16_t)(3 - (heroState == kFalling));
        walkDelay = 2, fallwallDelay = 4, blockDelay = 1, victoryDelay = 8;
        break;
    case 1: /* slow */
        animDelay = 4, fallDelay = 4, walkDelay = 3, fallwallDelay = 5, blockDelay = 2, victoryDelay = 10;
        break;
    }

    Boolean left = KeysDown(k, kLeftArrow, kKeyA), right = KeysDown(k, kRightArrow, kKeyD);
    Boolean up = KeysDown(k, kUpArrow, kKeyW), down = KeysDown(k, kDownArrow, kKeyS);
    Boolean magic = KeysDown(k, kSpace, kReturn);
    uint8_t here = grid[heroX][heroY], below = grid[heroX][heroY + 1];
    int act = aStand;

    switch (heroState) {
    case kStanding:
    case kWalked:
    case kFalling:
        act = aStand;
        /* A quick tap only turns the hero around. */
        if (left) {
            if (facingRight) {
                facingRight = false;
                turnTime = TickCount();
            } else if (TickCount() > turnTime + 2) {
                act = aWalk;
            }
        }
        if (right) {
            if (!facingRight) {
                facingRight = true;
                turnTime = TickCount();
            } else if (TickCount() > turnTime + 2) {
                act = aWalk;
            }
        }
        if (magic)
            act = aMagicSide;
        if (down)
            act = aCrouch;
        if (up)
            act = aLookUp;
        if (In(kFallThrough, below) && !(here == kTunnel && heroState != kFalling))
            act = aFall;
        if (here == kElevator)
            act = aElevator;
        if (here == kWarpPocket) {
            act = aDissolve;
            PlaySound(205);
        } else if (below == kRedBlock) {
            act = aDissolve;
            PlaySound(206);
        } else if (here == kWarp && !justWarped) {
            act = aWarp;
            PlaySound(215);
        } else if (grid[heroX - 1][heroY] == kVictory) {
            act = aVictory;
        }
        if (heroState == kFalling && act != aFall && act != aElevator && act != aDissolve)
            PlaySound(212);
        break;

    case kCrouching:
        act = aStandUp;
        if (down)
            act = aStayCrouched;
        if (up)
            act = aStandUp;
        if (magic && down)
            act = aMagicDown;
        if (In(kFallThrough, below) && here != kTunnel)
            act = aFall;
        if (here == kElevator)
            act = aElevator;
        if (here == kWarpPocket) {
            act = aDissolve;
            PlaySound(205);
        } else if (below == kRedBlock) {
            act = aDissolve;
            PlaySound(206);
        } else if (here == kWarp && !justWarped) {
            act = aWarp;
            PlaySound(215);
        }
        break;

    case kLookingUp:
        act = aStand;
        if (up)
            act = aLookUp;
        if (left)
            facingRight = false;
        if (right)
            facingRight = true;
        if (magic && up)
            act = aMagicUp;
        if (here == kExit)
            act = aExitLevel;
        if (In(kFallThrough, below) && here != kTunnel)
            act = aFall;
        if (here == kElevator || grid[heroX][heroY - 1] == kElevator)
            act = aElevator;
        if (here == kWarpPocket) {
            act = aDissolve;
            PlaySound(205);
        } else if (below == kRedBlock) {
            act = aDissolve;
            PlaySound(206);
        } else if (here == kWarp && !justWarped) {
            act = aWarp;
            PlaySound(215);
        }
        break;

    case kGone: /* reappear at the (last) entrance portal */
        act = aReappear;
        heroX = 1, heroY = 1;
        for (int x = 1; x <= 16; x++)
            for (int y = 1; y <= 12; y++)
                if (grid[x][y] == kEntrance)
                    heroX = (int16_t)x, heroY = (int16_t)y;
        break;
    }
    HeroAction(act);
}

/* fn47F6: hero sprites, mask and tiles for the current hero.
 * After level 25 the player becomes the other hero. */
static void LoadHeroGraphics(void)
{
    /* The code for choosing the hero from heroKindSetting (0, 1 or random)
     * is still in the binary, but the routine branches over it (47FC). */
    heroKind = level < 26 ? 0 : 1;

    PicHandle pic = GetPicture(130 + 3 * heroKind);
    Rect r = PictureFrame(pic);
    DisposeGWorld(tilesGW);
    tilesGW = NewGWorld(r.right, r.bottom);
    SetGWorld(tilesGW);
    DrawPicture(pic, &r);
    ReleasePicture(pic);

    pic = GetPicture(129 + 3 * heroKind);
    r = PictureFrame(pic);
    DisposeGWorld(heroGW);
    heroGW = NewGWorld(r.right, r.bottom);
    SetGWorld(heroGW);
    DrawPicture(pic, &r);
    InvertRect(&r);
    BitMapToRegion(heroMask, heroGW);
    SetGWorld(heroGW);
    ReleasePicture(pic);
    pic = GetPicture(128 + 3 * heroKind);
    DrawPicture(pic, &r);
    ReleasePicture(pic);
    SetGWorld(window);
}

/* fn4A20: one tick of whatever is on screen. */
static void Tick(void)
{
    if (menusVisible) {
        ShowCursorOnce();
        if (!inGame)
            TitleStep();
        return;
    }
    HideCursorOnce();
    SetGWorld(window);
    if (!screenShown) {
        CopyBits(backGW, window, &screenRect, &screenRect, srcCopy, NULL);
        screenShown = true;
    }
    HeroStep();
    if (grid[heroX][heroY + 1] == kFallwall && heroState != kGone)
        StartFallwall();
    for (int i = 1; i <= 20; i++)
        if ((TickCount() >= fallwalls[i].time) & fallwalls[i].active) /* Pascal "and": no short circuit */
            FallwallStep(&fallwalls[i]);
}

/* fn4B02 */
static void InitHero(void)
{
    for (int i = 1; i <= 20; i++)
        fallwalls[i].active = false;
    heroX = 1, heroY = 1;
    heroState = kGone;
    facingRight = Abs16((int16_t)(Random() % 2)) == 1;
}

/* fn4B58: build level `lvl` from TEXT resource 200+lvl. */
static void LoadLevel(int lvl, Boolean loadHero, Boolean newGame)
{
    SetGWorld(window);
    if (loadHero)
        LoadHeroGraphics();
    level = (int16_t)lvl;
    levelDone = false;
    /* The original looked for a background PICT 200+lvl, falling back to
     * lower IDs until one existed; it found PICT 134 and released it unused. */

    SetEmptyRgn(levelRgn);
    SetGWorld(levelGW);
    for (int x = 0; x <= 17; x++)
        for (int y = 0; y <= 13; y++) {
            grid[x][y] = kEmpty;
            if (y == 0 || x == 0 || x == 17)
                grid[x][y] = kGrayWall;
        }

    char *text = GetTextResource(200 + lvl);
    int pos = -2;
    for (int y = 1; y <= 12; y++) {
        pos++;
        for (int x = 1; x <= 16; x++) {
            pos++;
            char ch = text ? text[pos] : '0';
            if (ch == '0' || ch == ')')
                continue;
            Rect r;
            TileRect(&r, x, y, 0);
            RectRgn(tempRgn, &r);
            UnionRgn(levelRgn, tempRgn, levelRgn);
            PlaceTile(ch, &grid[x][y], &r);
        }
    }
    free(text);

    nextFrameTime = 0;
    InitHero();
    SetGWorld(backGW);
    PaintRect(&screenRect);
    CopyBits(levelGW, backGW, &screenRect, &screenRect, srcCopy, levelRgn);
    SetGWorld(window);
    screenShown = false;
    firstEntrance = true;
    ShowLevelTitle(level, newGame);
    CopyBits(backGW, window, &screenRect, &screenRect, srcCopy, NULL);
}

/* fn4D38 */
static void InitGraphics(void)
{
    PicHandle pic = GetPicture(130);
    Rect r = PictureFrame(pic);
    tilesGW = NewGWorld(r.right, r.bottom);
    SetGWorld(tilesGW);
    DrawPicture(pic, &r);
    ReleasePicture(pic);

    pic = GetPicture(129);
    r = PictureFrame(pic);
    heroGW = NewGWorld(r.right, r.bottom);
    SetGWorld(heroGW);
    DrawPicture(pic, &r);
    InvertRect(&r);
    heroMask = NewRgn();
    BitMapToRegion(heroMask, heroGW);
    ReleasePicture(pic);
    levelRgn = NewRgn();
    tempRgn = NewRgn();
    pic = GetPicture(128);
    SetGWorld(heroGW);
    DrawPicture(pic, &r);
    ReleasePicture(pic);
    SetGWorld(window);
    speed = 2;
    heroKindSetting = 2;
    InitStrings();
    turnTime = 0;
}

/* ------------------------------------------------------------------ */
/* Screen and menus */

static void EnableMenus(void);

/* fn4F10 */
static void SayGoodbye(void) { PlaySound(112); }

/* fn4F1A */
static void RedrawScreen(void)
{
    if (menusVisible) {
        EnableMenus();
        DrawMenuBar();
    }
    if (inGame) {
        screenShown = false;
    } else {
        Rect r;
        SetRect(&r, 0, 20, 640, 480);
        CopyBits(backGW, window, &r, &r, srcCopy, NULL);
    }
}

/* fn4F6E */
static void RestoreScreen(void)
{
    Rect r;
    SetRect(&r, 0, 20, 640, 480);
    CopyBits(backGW, window, &r, &r, srcCopy, NULL);
    screenShown = false;
    if (menusVisible)
        DrawMenuBar();
}

/* fn4FB4: idle time. Caps Lock (or being on the title screen) shows the menus. */
static void Idle(const EventRecord *ev)
{
    Boolean show = (ev->modifiers & alphaLock) != 0 || !inGame;
    if (show != menusVisible) {
        menusVisible = show;
        if (menusVisible)
            HiliteMenu(0);
        RedrawScreen();
    }
    if (levelDone) {
        if (heroState == kWon) {
            VictoryFlash();
            ShowVictory();
            inGame = false;
            levelDone = false;
            heroState = kWalked;
            inGame = false;
            levelDone = false;
            InitTitle();
            RedrawScreen();
        } else {
            LevelWipe();
            LoadLevel(level + 1, true, false);
        }
    } else {
        Tick();
    }
}

static void Credits(void);
static void DoMenuCommand(int32_t result);

/* fn50A8 */
static void KeyPressed(const EventRecord *ev)
{
    char ch = (char)(ev->message & charCodeMask);
    if (ev->modifiers & cmdKey) {
        EnableMenus();
        DoMenuCommand(MenuKey(ch));
        if (!running)
            return;
        RedrawScreen();
    }
    if (inGame)
        return;
    KeyMap k;
    GetKeys(k);
    if (KeyDown(k, kKeyJ) && KeyDown(k, kKeyI) && KeyDown(k, kKeyM))
        Credits();
}

/* fn5136: one centered line of the credits, with a shadow. */
static void CreditLine(const char *s, int16_t *y)
{
    RGBColor c = {0x7FFF, 0x7FFF, 0x7FFF};
    RGBForeColor(&c);
    MoveTo(320 - StringWidth(s) / 2 + 1, *y + 1);
    DrawString(s);
    c.red = c.green = c.blue = 0xFFFF;
    RGBForeColor(&c);
    MoveTo(320 - StringWidth(s) / 2, *y);
    DrawString(s);
    *y += 21;
}

/* fn51E4: J+I+M on the title screen shows Shakespeare's Sonnet 27. */
static void Credits(void)
{
    static const char *sonnet[] = {
        "Weary with toil, I haste me to my bed,",
        "The dear repose for limbs with travel tired;",
        "But then begins a journey in my head,",
        "To work my mind, when body\xD5s work\xD5s expired:",
        "For then my thoughts, far from where I abide,",
        "Intend a zealous pilgrimage to thee",
        "And keep my drooping eyelids open wide,",
        "Looking on darkness which the blind do see:",
        "Save that my soul\xD5s imaginary sight",
        "Presents thy shadow to my sightless view,",
        "Which, like a jewel hung in ghastly night,",
        "Makes black night beauteous and her old face new.",
        "Lo!  thus, by day my limbs, by night my mind,",
        "For thee and for myself no quiet find.",
    };
    SetGWorld(window);
    Rect r;
    SetRect(&r, 0, 0, 640, 480);
    PaintRect(&r);
    BackColor(blackColor);
    TextFont(1);
    TextFace(normal);
    TextMode(srcOr);
    TextSize(18);
    int16_t y = 103;
    for (size_t i = 0; i < sizeof sonnet / sizeof *sonnet; i++)
        CreditLine(sonnet[i], &y);
    ForeColor(blackColor);
    BackColor(whiteColor);
    PlaySound(106);
    WaitForClickOrKey();
    RestoreScreen();
}

/* fn55EA */
static void CheckSetting(int item, Boolean checked) { CheckItem(GetMenuHandle(3), item, checked); }

/* fn5608: menu items for the current mode, then DrawMenuBar. */
static void EnableMenus(void)
{
    EnableItem(GetMenuHandle(1), 0);
    EnableItem(GetMenuHandle(2), 0);
    if (inGame) {
        DisableItem(GetMenuHandle(2), 1);
        EnableItem(GetMenuHandle(2), 2);
        EnableItem(GetMenuHandle(2), 5);
        DisableItem(GetMenuHandle(2), 4);
        DisableItem(GetMenuHandle(4), 0);
        DisableItem(GetMenuHandle(4), 1);
        DisableItem(GetMenuHandle(4), 3);
        DisableItem(GetMenuHandle(4), 4);
    } else {
        EnableItem(GetMenuHandle(2), 1);
        DisableItem(GetMenuHandle(2), 2);
        DisableItem(GetMenuHandle(2), 5);
        EnableItem(GetMenuHandle(2), 4);
        EnableItem(GetMenuHandle(4), 0);
        EnableItem(GetMenuHandle(4), 1);
        EnableItem(GetMenuHandle(4), 3);
        EnableItem(GetMenuHandle(4), 4);
    }
    if (soundUnavailable) {
        DisableItem(GetMenuHandle(3), 1);
        DisableItem(GetMenuHandle(3), 2);
        DisableItem(GetMenuHandle(3), 3);
    } else {
        EnableItem(GetMenuHandle(3), 1);
        EnableItem(GetMenuHandle(3), 2);
        EnableItem(GetMenuHandle(3), 3);
    }
    EnableItem(GetMenuHandle(3), 0);
    EnableItem(GetMenuHandle(3), 5);
    EnableItem(GetMenuHandle(3), 6);
    EnableItem(GetMenuHandle(3), 7);
    CheckSetting(1, soundOn && !partialSound);
    CheckSetting(2, soundOn && partialSound);
    CheckSetting(3, !soundOn);
    CheckSetting(5, speed == 0);
    CheckSetting(6, speed == 2);
    CheckSetting(7, speed == 1);
    EnableItem(GetMenuHandle(2), 7);
    DrawMenuBar();
}

/* fn5B14 */
static void StopRunning(void) { running = false; }

/* fn582C */
static void DoMenuCommand(int32_t result)
{
    int menu = (int)(result >> 16), item = (int)(result & 0xFFFF);
    if (menusVisible) {
        EnableMenus();
        DrawMenuBar();
        HiliteMenu(0);
    }
    switch (menu) {
    case 1: /* Apple */
        if (item == 1) {
            DialogPtr d = GetNewDialog(128);
            DrawDialog(d);
            PlaySound(103);
            while (!Button())
                FlushEvents(everyEvent, 0);
            PlaySound(102);
            DisposeDialog(d);
            RestoreScreen();
        }
        /* Other items were desk accessories. */
        break;
    case 2: /* Game */
        switch (item) {
        case 1: /* New Game */
            inGame = true;
            LoadLevel(1, true, true);
            break;
        case 2: /* Abort Game */
            if (ConfirmEndGame()) {
                inGame = false;
                InitTitle();
                RedrawScreen();
            }
            break;
        case 4: { /* Start At Level... */
            int lvl = AskForPassword();
            if (lvl > 0) {
                level = (int16_t)lvl;
                inGame = true;
                LoadLevel(level, true, true);
            }
            RedrawScreen();
            break;
        }
        case 5: /* Reset Level */
            if (inGame)
                LoadLevel(level, false, false);
            break;
        case 7: /* Quit */
            if (inGame && !ConfirmEndGame()) {
                HiliteMenu(0);
                return;
            }
            inGame = false;
            StopRunning();
            break;
        }
        break;
    case 3: /* Settings */
        switch (item) {
        case 1: soundOn = true, partialSound = false; break;
        case 2: soundOn = true, partialSound = true; break;
        case 3: soundOn = false, partialSound = false; break;
        case 5: speed = 0; break;
        case 6: speed = 2; break;
        case 7: speed = 1; break;
        }
        break;
    case 4: /* Information */
        ShowInfoPicture(item);
        RestoreScreen();
        break;
    }
    if (menusVisible) {
        EnableMenus();
        DrawMenuBar();
        HiliteMenu(0);
    }
}

/* fn5A36 */
static void MouseDown(const EventRecord *ev)
{
    switch (FindWindow(ev->where)) {
    case inMenuBar:
        if (menusVisible) {
            EnableMenus();
            DoMenuCommand(MenuSelect(ev->where));
        }
        break;
    case inContent:
        if (!inGame && menusVisible)
            RestartTitle();
        break;
    }
}

/* fn5B46 */
static void InitApp(void)
{
    CursorIsVisible();
    randSeed = (int32_t)TickCount();
    window = ScreenPort();
    SetGWorld(window);
    ForeColor(blackColor);
    BackColor(whiteColor);
    SetRect(&screenRect, 0, 0, 640, 480);
    InstallMenuBar();
    menusVisible = true;
    backGW = NewGWorld(640, 480);
    levelGW = NewGWorld(640, 480);
    SetGWorld(window);
    InitLogoRegion();
    InitGraphics();
    InitTitle();
    RedrawScreen();
}

/* fn5CB4 */
static void DoEvent(void)
{
    EventRecord ev;
    Boolean got = inGame ? GetOSEvent(everyEvent, &ev) : GetNextEvent(everyEvent, &ev);
    if (got) {
        switch (ev.what) {
        case mouseDown: MouseDown(&ev); break;
        case keyDown:
        case autoKey: KeyPressed(&ev); break;
        case updateEvt: RestoreScreen(); break;
        case diskEvt:
        case activateEvt:
        case osEvt: break;
        default: Idle(&ev); break;
        }
    }
    if (running)
        Idle(&ev);
}

/* fn5D78 */
static void CleanUp(void) { SayGoodbye(); }

/* export 0 (fn5DA8) */
int StardustMain(void)
{
    if (GetSoundVol() == 0) {
        soundUnavailable = true;
        soundOn = false;
    } else {
        soundUnavailable = false;
        soundOn = true;
    }
    partialSound = false;
    for (int i = 1; i <= 5; i++)
        channels[i] = SndNewChannel();
    InitApp();
    running = true;
    inGame = false;
    while (running)
        DoEvent();
    CleanUp();
    for (int i = 1; i <= 5; i++)
        SndDisposeChannel(channels[i]);
    return 0;
}
