#!/bin/sh
# Random play on every passworded level, several seeds, original vs port.
#   tests/fuzzall.sh [SEEDS] [SECONDS]
seeds=${1:-3}; secs=${2:-120}
here=$(cd "$(dirname "$0")" && pwd)
dir=/tmp/stardust-fuzz; rm -rf "$dir"; mkdir -p "$dir"
for l in $(seq 1 49); do for s in $(seq 1 "$seeds"); do echo "$l $s"; done; done |
  xargs -P 8 -n 2 sh -c '
    python3 "'"$here"'/fuzz.py" $0 $1 '"$secs"' > "'"$dir"'/l$0s$1.txt"
    if OUT="'"$dir"'/l$0s$1" "'"$here"'/difftest.sh" "'"$dir"'/l$0s$1.txt" > "'"$dir"'/l$0s$1.out" 2>&1
    then echo "ok   level $0 seed $1"; else echo "FAIL level $0 seed $1"; fi'
