/* SDL2 host: window, input, timing, sound and asset files. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <SDL.h>
#ifdef __EMSCRIPTEN__
#include <emscripten.h>
#endif

#include "mac.h"
#include "platform.h"

enum { kScreenW = 640, kScreenH = 480 };

static SDL_Window *window;
static SDL_Renderer *renderer;
static SDL_Texture *texture;
static GWorldPtr screen;
static Boolean dirty;
static uint32_t lastPresent, lastPoll, startMs;
static char assetDir[1024];

/* Test mode (STARDUST_TEST=1): time is virtual, advancing a quarter
 * millisecond per OS call, so two programs that make the same calls see the
 * same clock. STARDUST_FRAMELOG gets a hash of the screen at every tick. */
static Boolean testMode;
static uint64_t vclock;
static FILE *frameLog;
static uint32_t lastLoggedTick = 0xFFFFFFFF;
static Boolean frameChanged;
static Boolean logging = true;
Boolean platformIsOriginal;

/* Script times count from startup, or from the last "sync". */
static Boolean syncArmed;
static uint32_t scriptBase, syncBase;
static int syncs;

static uint32_t NowMs(void)
{
    return testMode ? (uint32_t)(vclock / 4) : SDL_GetTicks() - startMs;
}

static void Advance(void)
{
    if (testMode)
        vclock++;
}

static uint32_t Ticks(void) { return (uint32_t)((uint64_t)NowMs() * 60 / 1000); }

void PlatformLog(const char *fmt, int value)
{
    if (frameLog && logging) {
        fprintf(frameLog, "%u ", Ticks());
        fprintf(frameLog, fmt, value);
        fputc('\n', frameLog);
    }
}

/* ------------------------------------------------------------------ */
/* Assets */

unsigned char *LoadAssetFile(const char *name, long *size)
{
    char path[1200];
    snprintf(path, sizeof path, "%s%s", assetDir, name);
    FILE *f = fopen(path, "rb");
    if (!f)
        return NULL;
    fseek(f, 0, SEEK_END);
    *size = ftell(f);
    fseek(f, 0, SEEK_SET);
    unsigned char *buf = malloc((size_t)*size + 1);
    if (fread(buf, 1, (size_t)*size, f) != (size_t)*size) {
        fclose(f);
        free(buf);
        return NULL;
    }
    buf[*size] = 0;
    fclose(f);
    return buf;
}

/* The port's menus and the original's differ, so a script reaches a level
 * by different inputs in each. A "sync" line makes the next level load
 * restart both on the same clock and random seed, and logging resumes. */
static void Sync(void)
{
    syncArmed = false;
    syncs++;
    vclock = (uint64_t)syncs * 10000000 * 4; /* 10^4 s per segment */
    randSeed = 12345;
    syncBase = NowMs();
    logging = true;
    frameChanged = true;
    if (frameLog)
        fprintf(frameLog, "sync\n");
}

int PlatformSyncs(void) { return syncs; }

char *GetTextResource(int id)
{
    char name[1100];
    long size;
    if (syncArmed && id >= 200)
        Sync();
    /* Tests may substitute their own levels. */
    const char *dir = getenv("STARDUST_LEVELS");
    if (dir) {
        snprintf(name, sizeof name, "%s/text_%d.txt", dir, id);
        FILE *f = fopen(name, "rb");
        if (f) {
            char *buf = calloc(1, 4096);
            size_t n = fread(buf, 1, 4095, f);
            buf[n] = 0;
            fclose(f);
            return buf;
        }
    }
    snprintf(name, sizeof name, "text_%d.txt", id);
    return (char *)LoadAssetFile(name, &size);
}

static void FindAssets(void)
{
#ifdef __EMSCRIPTEN__
    strcpy(assetDir, "/assets/");
#else
    const char *candidates[3] = {NULL, "", "../"};
    char *base = SDL_GetBasePath();
    char buf[1024];
    for (int i = 0; i < 3; i++) {
        if (i == 0 && !base)
            continue;
        snprintf(buf, sizeof buf, "%sassets/", i == 0 ? base : candidates[i]);
        snprintf(assetDir, sizeof assetDir, "%s", buf);
        long n;
        unsigned char *probe = LoadAssetFile("text_201.txt", &n);
        if (probe) {
            free(probe);
            break;
        }
    }
    SDL_free(base);
#endif
}

/* ------------------------------------------------------------------ */
/* Screen */

GWorldPtr ScreenPort(void) { return screen; }
static void SaveShotFile(const char *path);
void ScreenDirty(void) { dirty = true, frameChanged = true; }

static void LogFrame(uint32_t tick)
{
    if (!frameLog || !logging || tick == lastLoggedTick)
        return;
    lastLoggedTick = tick;
    if (!frameChanged)
        return;
    frameChanged = false;
    uint32_t h = 2166136261u;
    for (int i = 0; i < kScreenW * kScreenH; i++)
        h = (h ^ (screen->px[i] & 0xFFFFFF)) * 16777619u;
    fprintf(frameLog, "%u frame %08x\n", tick, h);
    char *dump = getenv("STARDUST_DUMP_TICK");
    if (dump && (uint32_t)atoi(dump) == tick) {
        char path[64];
        snprintf(path, sizeof path, "frame_%u.bmp", tick);
        SaveShotFile(path);
    }
}

static void Present(void)
{
    SDL_UpdateTexture(texture, NULL, screen->px, kScreenW * 4);
    SDL_RenderClear(renderer);
    SDL_RenderCopy(renderer, texture, NULL, NULL);
    SDL_RenderPresent(renderer);
    dirty = false;
    lastPresent = SDL_GetTicks();
#ifdef __EMSCRIPTEN__
    EM_ASM({ if (Module.onPresent) Module.onPresent(); }); /* for measuring smoothness */
#endif
}

/* ------------------------------------------------------------------ */
/* Input */

static KeyMap keymap;
static Boolean mouseButton;
static Point mousePos;
static EventRecord queue[64];
static int qhead, qtail;

/* SDL scancode -> Macintosh virtual key code (ADB extended keyboard). */
static int MacKeyCode(SDL_Scancode sc)
{
    static const struct { SDL_Scancode sc; int mac; } map[] = {
        {SDL_SCANCODE_A, 0x00}, {SDL_SCANCODE_S, 0x01}, {SDL_SCANCODE_D, 0x02}, {SDL_SCANCODE_F, 0x03},
        {SDL_SCANCODE_H, 0x04}, {SDL_SCANCODE_G, 0x05}, {SDL_SCANCODE_Z, 0x06}, {SDL_SCANCODE_X, 0x07},
        {SDL_SCANCODE_C, 0x08}, {SDL_SCANCODE_V, 0x09}, {SDL_SCANCODE_B, 0x0B}, {SDL_SCANCODE_Q, 0x0C},
        {SDL_SCANCODE_W, 0x0D}, {SDL_SCANCODE_E, 0x0E}, {SDL_SCANCODE_R, 0x0F}, {SDL_SCANCODE_Y, 0x10},
        {SDL_SCANCODE_T, 0x11}, {SDL_SCANCODE_1, 0x12}, {SDL_SCANCODE_2, 0x13}, {SDL_SCANCODE_3, 0x14},
        {SDL_SCANCODE_4, 0x15}, {SDL_SCANCODE_6, 0x16}, {SDL_SCANCODE_5, 0x17}, {SDL_SCANCODE_EQUALS, 0x18},
        {SDL_SCANCODE_9, 0x19}, {SDL_SCANCODE_7, 0x1A}, {SDL_SCANCODE_MINUS, 0x1B}, {SDL_SCANCODE_8, 0x1C},
        {SDL_SCANCODE_0, 0x1D}, {SDL_SCANCODE_RIGHTBRACKET, 0x1E}, {SDL_SCANCODE_O, 0x1F},
        {SDL_SCANCODE_U, 0x20}, {SDL_SCANCODE_LEFTBRACKET, 0x21}, {SDL_SCANCODE_I, 0x22}, {SDL_SCANCODE_P, 0x23},
        {SDL_SCANCODE_RETURN, 0x24}, {SDL_SCANCODE_L, 0x25}, {SDL_SCANCODE_J, 0x26},
        {SDL_SCANCODE_APOSTROPHE, 0x27}, {SDL_SCANCODE_K, 0x28}, {SDL_SCANCODE_SEMICOLON, 0x29},
        {SDL_SCANCODE_BACKSLASH, 0x2A}, {SDL_SCANCODE_COMMA, 0x2B}, {SDL_SCANCODE_SLASH, 0x2C},
        {SDL_SCANCODE_N, 0x2D}, {SDL_SCANCODE_M, 0x2E}, {SDL_SCANCODE_PERIOD, 0x2F}, {SDL_SCANCODE_TAB, 0x30},
        {SDL_SCANCODE_SPACE, 0x31}, {SDL_SCANCODE_GRAVE, 0x32}, {SDL_SCANCODE_BACKSPACE, 0x33},
        {SDL_SCANCODE_ESCAPE, 0x35}, {SDL_SCANCODE_LGUI, 0x37}, {SDL_SCANCODE_RGUI, 0x37},
        {SDL_SCANCODE_LSHIFT, 0x38}, {SDL_SCANCODE_RSHIFT, 0x38}, {SDL_SCANCODE_CAPSLOCK, 0x39},
        {SDL_SCANCODE_LALT, 0x3A}, {SDL_SCANCODE_RALT, 0x3A}, {SDL_SCANCODE_LCTRL, 0x3B},
        {SDL_SCANCODE_RCTRL, 0x3B}, {SDL_SCANCODE_KP_ENTER, 0x4C}, {SDL_SCANCODE_LEFT, 0x7B},
        {SDL_SCANCODE_RIGHT, 0x7C}, {SDL_SCANCODE_DOWN, 0x7D}, {SDL_SCANCODE_UP, 0x7E},
    };
    for (size_t i = 0; i < sizeof map / sizeof *map; i++)
        if (map[i].sc == sc)
            return map[i].mac;
    return -1;
}

static uint16_t Modifiers(void)
{
    /* Also trust our own key state: SDL's Emscripten port leaves modstate 0. */
    SDL_Keymod m = SDL_GetModState();
    if (KeyDown(keymap, 0x37))
        m |= KMOD_GUI;
    if (KeyDown(keymap, 0x3B))
        m |= KMOD_CTRL;
    if (KeyDown(keymap, 0x38))
        m |= KMOD_SHIFT;
    if (KeyDown(keymap, 0x3A))
        m |= KMOD_ALT;
    uint16_t r = 0;
    /* Only the original's menu shortcuts (under emulation) still use these. */
    if (m & (KMOD_GUI | KMOD_CTRL))
        r |= cmdKey;
    if (m & KMOD_SHIFT)
        r |= shiftKey;
    if (m & KMOD_CAPS)
        r |= alphaLock;
    if (m & KMOD_ALT)
        r |= optionKey;
    return r;
}

static void Post(int what, uint32_t message)
{
    int next = (qtail + 1) % 64;
    if (next == qhead)
        return;
    EventRecord *e = &queue[qtail];
    e->what = (int16_t)what;
    e->message = message;
    e->when = Ticks(); /* not TickCount: scripted input mustn't advance the clock */
    e->where = mousePos;
    e->modifiers = Modifiers();
    qtail = next;
}

static int CharFor(SDL_Keycode k, uint16_t mods)
{
    if (k >= 'a' && k <= 'z')
        return (mods & (shiftKey | alphaLock)) ? k - 32 : k;
    if (k == SDLK_RETURN)
        return 13;
    if (k == SDLK_KP_ENTER)
        return 3;
    if (k == SDLK_BACKSPACE)
        return 8;
    if (k == SDLK_TAB)
        return 9;
    if (k == SDLK_ESCAPE)
        return 27;
    if (k == SDLK_LEFT)
        return 28;
    if (k == SDLK_RIGHT)
        return 29;
    if (k == SDLK_UP)
        return 30;
    if (k == SDLK_DOWN)
        return 31;
    if (k >= 32 && k < 127)
        return k;
    return 0;
}

/* SDL reports mouse positions in logical (640x480) coordinates. */
static void MousePoint(int x, int y)
{
    mousePos.h = (int16_t)x;
    mousePos.v = (int16_t)y;
}

static void HandleEvent(const SDL_Event *ev)
{
    switch (ev->type) {
    case SDL_QUIT:
        ExitToShell();
        break;
    case SDL_KEYDOWN:
    case SDL_KEYUP: {
        int mk = MacKeyCode(ev->key.keysym.scancode);
        Boolean down = ev->type == SDL_KEYDOWN;
        if (mk >= 0) {
            if (down)
                keymap[mk >> 3] |= (uint8_t)(1 << (mk & 7));
            else
                keymap[mk >> 3] &= (uint8_t)~(1 << (mk & 7));
        }
        /* Modifier keys alone never produce keyDown events on a Mac. */
        Boolean modifierKey = mk >= 0x37 && mk <= 0x3B;
        if (down && !modifierKey) {
            int ch = CharFor(ev->key.keysym.sym, Modifiers());
            if (ch || mk >= 0)
                Post(ev->key.repeat ? autoKey : keyDown, (uint32_t)(mk < 0 ? 0 : mk) << 8 | (uint32_t)ch);
        }
        break;
    }
    case SDL_MOUSEMOTION:
        MousePoint(ev->motion.x, ev->motion.y);
        break;
    case SDL_MOUSEBUTTONDOWN:
        MousePoint(ev->button.x, ev->button.y);
        mouseButton = true;
        Post(mouseDown, 0);
        break;
    case SDL_MOUSEBUTTONUP:
        MousePoint(ev->button.x, ev->button.y);
        mouseButton = false;
        Post(mouseUp, 0);
        break;
    case SDL_WINDOWEVENT:
        if (ev->window.event == SDL_WINDOWEVENT_EXPOSED)
            dirty = true;
        break;
    }
}

/* ------------------------------------------------------------------ */
/* Autopilot for testing: STARDUST_SCRIPT names a file of lines
 *   <ms> key <scancode-name> down|up     e.g. "1500 key Space down"
 *   <ms> mod caps|cmd|shift on|off
 *   <ms> click <h> <v>
 *   <ms> mdown|mmove|mup <h> <v>
 *   <ms> shot <file.bmp>
 *   <ms> nolog                           stop logging until the next sync
 *   <ms> arm                             the next level load syncs (see Sync)
 *   <ms> quit
 *   sync                                 wait for that load
 * where <ms> counts from startup or the last sync. A line prefixed "port " or
 * "orig " is only for that program; between arm and sync it stops logging. */

static FILE *script;
static char scriptLine[256];
static Boolean scriptPending;

static void SaveShotFile(const char *path)
{
    SDL_Surface *surf = SDL_CreateRGBSurfaceWithFormatFrom(screen->px, kScreenW, kScreenH, 32, kScreenW * 4,
                                                           SDL_PIXELFORMAT_RGB888);
    SDL_SaveBMP(surf, path);
    SDL_FreeSurface(surf);
}

static void RunScript(uint32_t now)
{
    for (;;) {
        if (!scriptPending) {
            if (!script || !fgets(scriptLine, sizeof scriptLine, script))
                return;
            scriptPending = true;
        }
        char *line = scriptLine;
        if (!strncmp(line, "sync", 4)) {
            /* Wait for the level load; later lines time from it. A load
             * that never comes (the keys fell on a level title) times out. */
            static uint32_t waitFrom;
            if (syncArmed && !waitFrom)
                waitFrom = now ? now : 1;
            if (syncArmed && now - waitFrom < 30000)
                return;
            if (syncArmed)
                syncArmed = false, syncBase = now;
            waitFrom = 0;
            scriptBase = syncBase;
            scriptPending = false;
            continue;
        }
        Boolean mine = true, specific = false;
        if (!strncmp(line, "port ", 5) || !strncmp(line, "orig ", 5)) {
            specific = true;
            mine = (line[0] == 'o') == platformIsOriginal;
            line += 5;
        }
        unsigned ms;
        char cmd[32] = "", a[64] = "", b[64] = "";
        if (!mine || sscanf(line, "%u %31s %63s %63s", &ms, cmd, a, b) < 2) {
            scriptPending = false;
            continue;
        }
        if (now < scriptBase + ms)
            return;
        scriptPending = false;
        /* What follows differs between the programs until the sync. */
        if (specific && syncArmed)
            logging = false;
        SDL_Event ev = {0};
        if (!strcmp(cmd, "key")) {
            ev.type = strcmp(b, "up") ? SDL_KEYDOWN : SDL_KEYUP;
            for (char *c = a; *c; c++)
                if (*c == '_')
                    *c = ' ';
            ev.key.keysym.scancode = SDL_GetScancodeFromName(a);
            ev.key.keysym.sym = SDL_GetKeyFromScancode(ev.key.keysym.scancode);
            HandleEvent(&ev);
        } else if (!strcmp(cmd, "mod")) {
            SDL_Keymod m = !strcmp(a, "caps") ? KMOD_CAPS : !strcmp(a, "cmd") ? KMOD_LGUI : KMOD_LSHIFT;
            SDL_SetModState(strcmp(b, "on") ? (SDL_GetModState() & ~m) : (SDL_GetModState() | m));
        } else if (!strcmp(cmd, "click")) {
            ev.type = SDL_MOUSEBUTTONDOWN;
            ev.button.x = atoi(a), ev.button.y = atoi(b);
            HandleEvent(&ev);
            ev.type = SDL_MOUSEBUTTONUP;
            HandleEvent(&ev);
        } else if (!strcmp(cmd, "mdown") || !strcmp(cmd, "mmove") || !strcmp(cmd, "mup")) {
            ev.type = cmd[1] == 'd' ? SDL_MOUSEBUTTONDOWN : cmd[1] == 'm' ? SDL_MOUSEMOTION : SDL_MOUSEBUTTONUP;
            if (ev.type == SDL_MOUSEMOTION)
                ev.motion.x = atoi(a), ev.motion.y = atoi(b);
            else
                ev.button.x = atoi(a), ev.button.y = atoi(b);
            HandleEvent(&ev);
        } else if (!strcmp(cmd, "arm")) {
            syncArmed = true;
        } else if (!strcmp(cmd, "nolog")) {
            logging = false;
        } else if (!strcmp(cmd, "shot")) {
            SaveShotFile(a);
        } else if (!strcmp(cmd, "quit")) {
            ExitToShell();
        }
    }
}

#ifdef __EMSCRIPTEN__
/* Timer-based sleeps take 4-8 ms or more however short the request (Safari
 * is worst), so: a message round-trip to yield, and the next display frame
 * to wait for time to pass. */
EM_ASYNC_JS(void, YieldToBrowser, (), {
    await new Promise(function (resolve) {
        var c = Module.yieldChannel || (Module.yieldChannel = new MessageChannel());
        c.port1.onmessage = function () { resolve(); };
        c.port2.postMessage(0);
    });
});

EM_ASYNC_JS(void, WaitForFrame, (), {
    await new Promise(function (resolve) { requestAnimationFrame(function () { resolve(); }); });
});
#endif

void PlatformPoll(void)
{
    uint32_t now = SDL_GetTicks();
    if (testMode || now - lastPoll >= 2) {
        lastPoll = now;
        SDL_Event ev;
        while (SDL_PollEvent(&ev))
            if (!script || ev.type == SDL_QUIT)
                HandleEvent(&ev);
        RunScript(NowMs());
    }
    if (testMode) {
        if (dirty && now - lastPresent >= 100)
            Present();
        return;
    }
    if (dirty && now - lastPresent >= 15)
        Present();
    /* Busy-wait loops (waiting for a key, a sound, a tick) must still let
     * the host run: the browser only delivers input while we're yielded. */
    static uint32_t lastYield;
    if (now - lastYield >= 8) {
        lastYield = now;
#ifdef __EMSCRIPTEN__
        YieldToBrowser();
#else
        SDL_Delay(1);
#endif
    }
}

void PlatformIdle(void)
{
    if (testMode) {
        PlatformPoll();
        return;
    }
#ifdef __EMSCRIPTEN__
    if (dirty)
        Present();
    /* A frame wait can overshoot the next tick by most of a frame; when the
     * tick is close, just yield. */
    uint32_t ms = SDL_GetTicks() - startMs, untilTick = 1000 / 60 - ms % 1000 * 60 % 1000 / 60;
    if (untilTick <= 5)
        YieldToBrowser();
    else
        WaitForFrame();
#else
    SDL_Delay(1);
#endif
    PlatformPoll();
}

void PlatformYield(void)
{
    if (dirty)
        Present();
    PlatformIdle();
}

/* ------------------------------------------------------------------ */
/* Event Manager */

/* Busy loops rest every few polls. A browser rest lasts up to a display
 * frame rather than ~1 ms, so it comes that many times less often. */
#ifdef __EMSCRIPTEN__
enum { kRestScale = 16 };
#else
enum { kRestScale = 1 };
#endif

uint32_t TickCount(void)
{
    static uint32_t last;
    Advance();
    PlatformPoll();
    uint32_t t = Ticks();
    LogFrame(t);
    /* Spinning on an unchanged tick: rest now and then, not on every call,
     * so loops that also do work (the title effects) keep a Mac-like pace. */
    static unsigned spins;
    if (t == last && ++spins % (8 * kRestScale) == 0)
        PlatformIdle();
    last = t;
    return t;
}

void GetKeys(KeyMap keys)
{
    Advance();
    PlatformPoll();
    memcpy(keys, keymap, sizeof(KeyMap));
}

Boolean KeyDown(const KeyMap keys, int k) { return (keys[k >> 3] >> (k & 7)) & 1; }

Boolean Button(void)
{
    Advance();
    PlatformPoll();
    return mouseButton;
}

void GetMouse(Point *p)
{
    Advance();
    PlatformPoll();
    *p = mousePos;
}

int FindWindow(Point p) { return p.v < 20 ? inMenuBar : inContent; }

static Boolean NextEvent(int mask, EventRecord *ev)
{
    Advance();
    PlatformPoll();
    while (qhead != qtail) {
        EventRecord e = queue[qhead];
        qhead = (qhead + 1) % 64;
        if (mask & (1 << e.what)) {
            *ev = e;
            return true;
        }
    }
    memset(ev, 0, sizeof *ev);
    ev->what = nullEvent;
    ev->when = TickCount();
    ev->where = mousePos;
    ev->modifiers = Modifiers();
    return false;
}

Boolean GetNextEvent(int mask, EventRecord *ev)
{
    /* A real Mac spent a little time in SystemTask here; sleeping on every
     * fourth empty poll keeps the title animation near its original pace. */
    static int empties;
    Boolean got = NextEvent(mask, ev);
    if (!got && ++empties % (4 * kRestScale) == 0)
        PlatformIdle();
    return got;
}

Boolean GetOSEvent(int mask, EventRecord *ev) { return NextEvent(mask, ev); }

void FlushEvents(int whatMask, int stopMask)
{
    (void)stopMask;
    Advance();
    PlatformPoll();
    EventRecord keep[64];
    int n = 0;
    while (qhead != qtail) {
        if (!(whatMask & (1 << queue[qhead].what)))
            keep[n++] = queue[qhead];
        qhead = (qhead + 1) % 64;
    }
    for (int i = 0; i < n; i++) {
        queue[qtail] = keep[i];
        qtail = (qtail + 1) % 64;
    }
}

void HideCursor(void) { SDL_ShowCursor(SDL_DISABLE); }
void ShowCursor(void) { SDL_ShowCursor(SDL_ENABLE); }

/* ------------------------------------------------------------------ */
/* Sound Manager: up to 6 channels mixed in the audio callback. Busy state is
 * timed by the wall clock so a suspended audio device can't hang the game. */

enum { kRate = 44100, kMaxChannels = 6 };

typedef struct { int16_t *pcm; int len; } Sample;
struct SndChannel { const Sample *s; int pos; uint32_t endMs; Boolean used; };

static Sample samples[256];
static struct SndChannel channels[kMaxChannels];
static SDL_AudioDeviceID audioDev;

static const Sample *LoadSample(int id)
{
    if (id < 0 || id >= 256)
        return NULL;
    Sample *s = &samples[id];
    if (s->pcm)
        return s;
    char name[32];
    long size;
    snprintf(name, sizeof name, "snd_%d.wav", id);
    unsigned char *file = LoadAssetFile(name, &size);
    if (!file)
        return NULL;
    SDL_AudioSpec spec;
    Uint8 *buf;
    Uint32 len;
    if (!SDL_LoadWAV_RW(SDL_RWFromConstMem(file, (int)size), 1, &spec, &buf, &len)) {
        free(file);
        return NULL;
    }
    free(file);
    SDL_AudioCVT cvt;
    SDL_BuildAudioCVT(&cvt, spec.format, spec.channels, spec.freq, AUDIO_S16SYS, 1, kRate);
    cvt.len = (int)len;
    cvt.buf = malloc((size_t)len * cvt.len_mult);
    memcpy(cvt.buf, buf, len);
    SDL_FreeWAV(buf);
    SDL_ConvertAudio(&cvt);
    s->pcm = (int16_t *)cvt.buf;
    s->len = cvt.len_cvt / 2;
    return s;
}

static void AudioCallback(void *ud, Uint8 *stream, int bytes)
{
    (void)ud;
    int16_t *out = (int16_t *)stream;
    int n = bytes / 2;
    for (int i = 0; i < n; i++) {
        int acc = 0;
        for (int c = 0; c < kMaxChannels; c++) {
            struct SndChannel *ch = &channels[c];
            if (ch->s && ch->pos < ch->s->len)
                acc += ch->s->pcm[ch->pos++];
        }
        out[i] = (int16_t)(acc > 32767 ? 32767 : acc < -32768 ? -32768 : acc);
    }
}

SndChannelPtr SndNewChannel(void)
{
    for (int c = 0; c < kMaxChannels; c++)
        if (!channels[c].used) {
            channels[c].used = true;
            return &channels[c];
        }
    return NULL;
}

void SndDisposeChannel(SndChannelPtr chan)
{
    if (!chan)
        return;
    SDL_LockAudioDevice(audioDev);
    chan->s = NULL;
    chan->used = false;
    SDL_UnlockAudioDevice(audioDev);
}

Boolean SndChannelBusy(SndChannelPtr chan)
{
    Advance();
    PlatformPoll();
    return chan && chan->s && NowMs() < chan->endMs;
}

void SndPlay(SndChannelPtr chan, int id, Boolean async)
{
    const Sample *s = LoadSample(id);
    if (!chan || !s)
        return;
    SDL_LockAudioDevice(audioDev);
    chan->s = s;
    chan->pos = 0;
    chan->endMs = NowMs() + (uint32_t)((uint64_t)s->len * 1000 / kRate);
    SDL_UnlockAudioDevice(audioDev);
    PlatformLog("snd %d", id);
    if (!async)
        while (SndChannelBusy(chan))
            PlatformIdle();
}

void SndStop(SndChannelPtr chan)
{
    if (!chan)
        return;
    SDL_LockAudioDevice(audioDev);
    chan->s = NULL;
    SDL_UnlockAudioDevice(audioDev);
}

int GetSoundVol(void) { return audioDev ? 7 : 0; }

/* ------------------------------------------------------------------ */

int PlatformInit(void)
{
    if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_AUDIO | SDL_INIT_TIMER) != 0) {
        fprintf(stderr, "SDL_Init: %s\n", SDL_GetError());
        return -1;
    }
    FindAssets();
    SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, "0");
#ifdef __EMSCRIPTEN__
    /* The page scales the canvas with CSS. */
    window = SDL_CreateWindow("Stardust", 0, 0, kScreenW, kScreenH, 0);
#else
    window = SDL_CreateWindow("Stardust", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, kScreenW * 2,
                              kScreenH * 2, SDL_WINDOW_RESIZABLE | SDL_WINDOW_ALLOW_HIGHDPI);
#endif
    renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
    if (!renderer)
        renderer = SDL_CreateRenderer(window, -1, 0);
    SDL_RenderSetLogicalSize(renderer, kScreenW, kScreenH);
    texture = SDL_CreateTexture(renderer, SDL_PIXELFORMAT_RGB888, SDL_TEXTUREACCESS_STREAMING, kScreenW, kScreenH);
    screen = NewGWorld(kScreenW, kScreenH);

    SDL_AudioSpec want = {0}, have;
    want.freq = kRate;
    want.format = AUDIO_S16SYS;
    want.channels = 1;
    want.samples = 1024;
    want.callback = AudioCallback;
    audioDev = SDL_OpenAudioDevice(NULL, 0, &want, &have, 0);
    if (audioDev)
        SDL_PauseAudioDevice(audioDev, 0);
    testMode = getenv("STARDUST_TEST") != NULL;
    const char *logPath = getenv("STARDUST_FRAMELOG");
    if (logPath)
        frameLog = fopen(logPath, "w");
    const char *scriptPath = getenv("STARDUST_SCRIPT");
    if (scriptPath && !(script = fopen(scriptPath, "r")))
        fprintf(stderr, "cannot open %s\n", scriptPath);
    startMs = SDL_GetTicks();
    return 0;
}

void PlatformQuit(void)
{
    if (frameLog)
        fclose(frameLog), frameLog = NULL;
    if (audioDev)
        SDL_CloseAudioDevice(audioDev);
    SDL_Quit();
}

void ExitToShell(void)
{
    PlatformQuit();
#ifdef __EMSCRIPTEN__
    emscripten_force_exit(0);
#endif
    exit(0);
}
