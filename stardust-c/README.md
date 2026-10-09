# Stardust 1.1 — C port

Stardust (1995, James Burton) was a THINK Pascal game for the classic Mac OS.
This directory is a **routine-by-routine translation of its 68k code into C**,
running on a small re-implementation of the Mac Toolbox over SDL2. It builds as a
native program and, through Emscripten, for the browser.

The port is checked against the original: `stardust-orig` runs the untouched
68k `CODE 1` resource in a 68k emulator with the *same* Toolbox layer, and the
test scripts compare both programs frame by frame (see [Verification](#verification)).

## Build and run

Native (needs SDL2, e.g. `brew install sdl2`):

```sh
make            # builds ./stardust
./stardust
```

> On this Mac the Command Line Tools linker is older than the macOS 27 SDK and
> fails with `tapi error: ... unknown architecture`. Point it at an older SDK:
> `SDKROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk make`

Browser (needs Emscripten; `source ~/Developer/emsdk/emsdk_env.sh`):

```sh
make web
cd web && python3 -m http.server 8000   # then open http://localhost:8000
```

`assets/` holds the game's pictures, sounds and level texts, copied from
`../extracted` by `tools/make_assets.py`, plus `geneva.ttf` taken from macOS
(the game's application font; it is Apple's, so think twice before publishing
the web build).

### Controls

As in the original: arrows or W/A/S/D move, Space or Return is magic (combine
with Up or Down), tap a direction to turn in place, Caps Lock shows the menus
and pauses. Menu shortcuts use ⌘, and Ctrl works as ⌘ too (browsers keep ⌘N/⌘Q
for themselves). On the title screen, hold J+I+M.

## Layout

| Path | What |
|---|---|
| `src/stardust.c` | The game. One C function per original routine, each labeled with its CODE 1 offset; globals keep their A5 offsets. |
| `src/mac.h`, `qd.c`, `menus.c`, `dialogs.c` | The Toolbox subset the game uses: GWorlds, CopyBits with mask regions, regions as bitmasks, QuickDraw's `Random`, text, the menu bar, DLOG/DITL 128–131. |
| `src/platform.c` | SDL2 host: window, events and Mac key codes, ticks, sound channels, assets, Emscripten yielding, test mode. |
| `emu/orig.c` | Runs the original `CODE 1` under [Musashi](https://github.com/kstenerud/Musashi) (vendored in `emu/musashi`), servicing every A-line trap with the C Toolbox layer. |
| `tests/` | `difftest.sh` (port vs original on one script), `fuzzall.sh` (random play on all 49 passworded levels), scripts and tiny test levels. |
| `re/` | Reverse-engineering aids: `code1.asm` (compacted disassembly), `raw.py` (raw bytes), `m68kdis.py` (Capstone listing). |

## Verification

`STARDUST_TEST=1` switches both programs to a virtual clock that advances with
every OS call (`TickCount`, `GetKeys`, `Button`, event calls…), so two programs
that make the same calls see identical time. Input comes from a script, and
`STARDUST_FRAMELOG` records a hash of the screen at every tick plus every sound
played. A faithful translation must produce the same log as the original.

```sh
make stardust stardust-orig
tests/difftest.sh tests/scripts/level1.txt
STARDUST_LEVELS=$PWD/tests/levels tests/difftest.sh tests/scripts/tour.txt
tests/fuzzall.sh 5 300      # 5 seeds x 5 virtual minutes on levels 1-49
```

Current results: all scripts match exactly, including 245/245 fuzz runs.
Judging by the sounds logged, the fuzz runs exercise walking, turning, blue and
green blocks, falls, elevators, warps, warp pockets, red blocks, fallwalls,
landings and level exits, on levels with both heroes. The tour covers About, The
Plot, Instructions, the J+I+M sonnet, a rejected password, sound and speed
settings, a level exit, the victory sequence, and abort/quit confirmations.

## Quirks of the original, kept on purpose

- Title effect mode 2 (bouncing polygons) is unreachable: clicks toggle 1 ↔ 3.
- The hero-choice setting is skipped (the routine branches over it); the hero
  changes after level 25 regardless.
- Level 50 has an empty password, so it can't be started from "Start At Level".
- The level wipe's interpolation overflows 16-bit `Integer` arithmetic.
- Created blocks are redrawn from the level picture, which can show stale
  graphics in rare elevator cases.
- After the victory picture the game plays "Death by the Coals".
- Sounds below ID 200 play synchronously, so input is ignored while they play.

## Deliberate differences

- The victory flash ran unpaced (as fast as a 1995 Mac could draw); each step is
  now presented so it stays visible.
- Fonts: Geneva TrueType for everything; system-font text (menus, dialogs) uses
  Geneva drawn bold in place of Chicago.
- The menu bar, dialogs and their framing are re-implementations, not Apple's
  code; they follow the resources but won't be pixel-identical to System 7.
- Always the 640×480 "full screen" mode; no small-screen window, no desk
  accessories. Dialogs restore the pixels under them instead of relying on
  update events.
