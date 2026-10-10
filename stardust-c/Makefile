# Native build (SDL2) and browser build (Emscripten).
SRC := src/main.c src/stardust.c src/panel.c src/qd.c src/platform.c
CFLAGS ?= -O2 -g -std=c11 -Wall -Wextra -Wno-unused-function

SDL_CFLAGS := $(shell sdl2-config --cflags)
SDL_LIBS := $(shell sdl2-config --libs)

stardust: $(SRC) src/*.h
	$(CC) $(CFLAGS) $(SDL_CFLAGS) -o $@ $(SRC) $(SDL_LIBS) -lm

web: web/stardust.js

web/stardust.js: $(SRC) src/*.h
	emcc -O2 -std=gnu11 -sUSE_SDL=2 -sASYNCIFY -sASYNCIFY_STACK_SIZE=262144 -sSTACK_SIZE=1048576 \
	    -sALLOW_MEMORY_GROWTH -sINITIAL_MEMORY=64MB -sENVIRONMENT=web \
	    --preload-file assets@/assets -o web/stardust.js $(SRC)

assets:
	python3 tools/make_assets.py

clean:
	rm -f stardust web/stardust.js web/stardust.wasm web/stardust.data

.PHONY: web assets clean

# The original 68k program under emulation, for differential testing.
MUSASHI := emu/musashi/m68kcpu.c emu/musashi/m68kops.c emu/musashi/m68kdasm.c emu/musashi/softfloat/softfloat.c
TOOLBOX := src/qd.c src/platform.c emu/menus.c emu/dialogs.c

stardust-orig: emu/orig.c $(MUSASHI) $(TOOLBOX) src/*.h emu/*.h
	$(CC) -O2 -g -std=gnu11 -w $(SDL_CFLAGS) -Iemu/musashi -o $@ emu/orig.c $(MUSASHI) $(TOOLBOX) $(SDL_LIBS) -lm
