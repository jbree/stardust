# Stardust 1.1 — C port

Stardust (© 1995 James Burton, who created all of it) was a THINK Pascal game
for the classic Mac OS. This directory is an AI-generated (Claude)
**routine-by-routine translation of its 68k code into C**,
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
`../extracted` by `tools/make_assets.py`. No font is bundled: the native build
loads the first installed of Geneva (the original's, on a Mac), Verdana,
DejaVu Sans or Liberation Sans, or the `.ttf` named by `STARDUST_FONT`; the
browser build draws text with the same choice of the user's fonts through a
canvas. The page waits for a click before starting, since browsers only
allow sound after one and the title's opening chime matters.

### Controls

As in the original: arrows or W/A/S/D move, Space or Return is magic (combine
with Up or Down), and tapping a direction turns in place. On the title screen,
hold J+I+M.

The original's menu bar (shown with Caps Lock) is replaced by panels:

- **Space, Return or Esc** on the title screen: New Game, Start At Level…,
  Settings, Instructions, The Plot.
- **Esc** during a game pauses it: Reset Level, Abort Game, Settings,
  Instructions, The Plot. Esc again resumes. Esc on a "Level N" screen goes
  into the level paused, with this menu open.
- **Settings**: Full / Partial / No Sound and Fast / Normal / Slow Animation,
  with the same effects as the original's Settings menu.

Panels take arrows (or W/S), Return/Space/Enter to choose, Esc to go back, or
the mouse. Passwords are upper-cased as you type. Instructions and The Plot close on
any key or click, Esc included, without waiting for their music to finish.
Esc also closes the victory picture and the J+I+M sonnet.

## Layout

| Path | What |
|---|---|
| `src/stardust.c` | The game. One C function per original routine, each labeled with its CODE 1 offset; globals keep their A5 offsets. |
| `src/panel.c` | The menu, settings, password and notice panels that replace the original's menu bar and dialogs. |
| `src/mac.h`, `qd.c` | The Toolbox subset the game uses: GWorlds, CopyBits with mask regions, regions as bitmasks, QuickDraw's `Random`, text. |
| `src/platform.c` | SDL2 host: window, events and Mac key codes, ticks, sound channels, assets, Emscripten yielding, test mode. |
| `emu/orig.c` | Runs the original `CODE 1` under [Musashi](https://github.com/kstenerud/Musashi) (vendored in `emu/musashi`), servicing every A-line trap with the C Toolbox layer. |
| `emu/menus.c`, `dialogs.c` | The System 7 menu bar and DLOG/DITL 128–131, needed only by the emulated original. |
| `tests/` | `difftest.sh` (port vs original on one script), `fuzzall.sh` (random play on all 49 passworded levels), scripts and tiny test levels. |
| `re/` | Reverse-engineering aids: `code1.asm` (compacted disassembly), `raw.py` (raw bytes), `m68kdis.py` (Capstone listing). |

## Verification

`STARDUST_TEST=1` switches both programs to a virtual clock that advances with
every OS call (`TickCount`, `GetKeys`, `Button`, event calls…), so two programs
that make the same calls see identical time. Input comes from a script, and
`STARDUST_FRAMELOG` records a hash of the screen at every tick plus every sound
played. A faithful translation must produce the same log as the original.

Since the port's menus are not the original's, a script reaches each game
through lines prefixed `port` or `orig`, between an `arm` and a `sync` line.
The level load that follows restarts both programs on the same clock and
random seed, and the logs compare everything from there: the play, level
exits, the victory sequence, and the effect of each setting. The title screen
and the menus themselves are not compared.

```sh
make stardust stardust-orig
tests/difftest.sh tests/scripts/level1.txt
STARDUST_LEVELS=$PWD/tests/levels tests/difftest.sh tests/scripts/tour.txt
tests/fuzzall.sh 5 300      # 5 seeds x 5 virtual minutes on levels 1-49
```

Current results: all scripts match exactly, including 245/245 fuzz runs.
Judging by the sounds logged, the fuzz runs exercise walking, turning, blue and
green blocks, falls, elevators, warps, warp pockets, red blocks, fallwalls,
landings, level exits and resets, on levels with both heroes. The tour also
drives the port's panels (The Plot, Instructions, a rejected password, every
setting, abort) and compares play under each sound and speed setting, a level
exit and the victory sequence.

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
- Fonts: Geneva or the closest installed font for everything, also in place of Chicago.
- No menu bar or Caps Lock: the Space and Esc panels above replace the menus
  and dialogs. The About box and Quit are gone (close the window to quit). The
  title screen shows "press space, return or esc for menu" where the menu bar
  was.
- Always the 640×480 "full screen" mode; no small-screen window, no desk
  accessories.
