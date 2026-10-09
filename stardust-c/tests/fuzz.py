#!/usr/bin/env python3
"""Generate random-play scripts for tests/difftest.sh.
   fuzz.py LEVEL SEED SECONDS > script.txt"""
import random, sys

PASSWORDS = ['EHLNE', 'CENENCION', 'ECUIT', 'SOBEC', 'TINTEK', 'TOMIRAUN', 'AETUFIBUL', 'PALFYTR',
             'VERNESLECS', 'CERIC', 'GROI', 'RONOI', 'ULIMI', 'RETAIMA', 'YITH', 'SIIS', 'AIGA', 'BELAB',
             'CELDRA', 'VANULC', 'SIREA', 'LUNTATAS', 'MENDAGEY', 'FERULIC', 'RAUNTEC', 'NARAELE',
             'RUSTUN', 'COMALDES', 'SAEDALUD', 'DODI', 'KINDUE', 'BAHMBUA', 'NORHDYTE', 'KALAVIMAN',
             'RAUDAS', 'DAEMONDRA', 'MINILEF', 'BALZEBUREB', 'MALIGOPANY', 'DEEMA', 'LIVERIGUS', 'SORISI',
             'VILANIA', 'IRSUDI', 'DAILEHL', 'TIHLIL', 'SUMER', 'MULUROS', 'BRINTOJUM']

level, seed, seconds = int(sys.argv[1]), int(sys.argv[2]), int(sys.argv[3])
rng = random.Random(seed * 1000 + level)
t = 3000
out = []
def ev(dt, s):
    global t
    t += dt
    out.append(f'{t} {s}')

def cmd(key):
    ev(10, 'mod cmd on'); ev(10, f'key {key} down'); ev(10, f'key {key} up'); ev(10, 'mod cmd off')

cmd('O')
ev(1000, 'mod shift on')
for ch in PASSWORDS[level - 1]:
    ev(30, f'key {ch} down'); ev(30, f'key {ch} up')
ev(30, 'mod shift off')
ev(100, 'key Return down'); ev(50, 'key Return up')
ev(7000, 'key Space down'); ev(100, 'key Space up')

held = set()
moves = [['Left'], ['Right'], ['Up'], ['Down'], ['Space'], ['Return'], ['A'], ['D'], ['W'], ['S'],
         ['Up', 'Space'], ['Down', 'Space'], ['Down', 'Return'], ['Up', 'Return'], ['Left'], ['Right']]
end = t + seconds * 1000
while t < end:
    r = rng.random()
    if r < 0.01:
        cmd('R'); ev(8000, 'key Space down'); ev(100, 'key Space up')
        continue
    if r < 0.02:
        ev(10, 'mod caps on'); ev(rng.randint(300, 2000), 'mod caps off')
        continue
    keys = rng.choice(moves)
    for k in keys:
        ev(rng.randint(0, 40), f'key {k} down')
    # taps (< 3 ticks) turn without walking; long holds walk
    ev(rng.choice([20, 30, 60, 150, 400, 900, 2000]), 'key Return up' if False else 'mod shift off')
    for k in keys:
        ev(rng.randint(0, 30), f'key {k} up')
    ev(rng.randint(0, 600), 'mod shift off')
ev(500, 'quit')
print('\n'.join(out))
