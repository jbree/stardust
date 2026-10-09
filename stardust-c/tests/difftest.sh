#!/bin/sh
# Run the C port and the original 68k code on the same input script with a
# virtual clock, then compare their frame/sound logs.
#   tests/difftest.sh tests/scripts/foo.txt
set -e
here=$(cd "$(dirname "$0")/.." && pwd)
script=$(cd "$(dirname "$1")" && pwd)/$(basename "$1")
out=${OUT:-/tmp/stardust-difftest}
mkdir -p "$out"
export STARDUST_TEST=1 STARDUST_SCRIPT="$script" SDL_VIDEODRIVER=${SDL_VIDEODRIVER:-dummy} SDL_AUDIODRIVER=dummy
cd "$here"
STARDUST_FRAMELOG="$out/port.log" ./stardust
STARDUST_FRAMELOG="$out/orig.log" ./stardust-orig
if cmp -s "$out/port.log" "$out/orig.log"; then
    echo "MATCH: $(grep -c frame "$out/port.log") frames, $(grep -c snd "$out/port.log") sounds"
else
    echo "DIFFER:"
    diff "$out/orig.log" "$out/port.log" | head -20
    exit 1
fi
