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
out = ['0 nolog']
t = 8000
def at(time, s):
    out.append(f'{time} {s}')
def ev(dt, s):
    global t
    t += dt
    at(t, s)
def press(prefix, time, key, hold=60):
    at(f'{prefix}{time}', f'key {key} down'); at(f'{prefix}{time + hold}', f'key {key} up')
def cmd(time, *keys):
    at(f'orig {time}', 'mod cmd on')
    for i, k in enumerate(keys):
        press('orig ', time + 10 + 20 * i, k, 5)
    at(f'orig {time + 10 + 20 * len(keys)}', 'mod cmd off')
def sync():
    """Each program reaches the level load its own way; times restart there."""
    global t
    out.append('sync')
    t = 0
    ev(6000, 'key Space down'); ev(100, 'key Space up')

# Start at the level: the port's Space menu, the original's Cmd-O.
at(t, 'arm')
press('port ', t, 'Space'); press('port ', t + 1500, 'Down'); press('port ', t + 2000, 'Return')
for i, ch in enumerate(PASSWORDS[level - 1]):
    press('port ', t + 3000 + 60 * i, ch, 30)
press('port ', t + 4000, 'Return')
cmd(t, 'O')
at(f'orig {t + 1000}', 'mod shift on')
for i, ch in enumerate(PASSWORDS[level - 1]):
    press('orig ', t + 1100 + 60 * i, ch, 30)
at(f'orig {t + 1900}', 'mod shift off')
press('orig ', t + 2000, 'Return')
sync()

held = set()
moves = [['Left'], ['Right'], ['Up'], ['Down'], ['Space'], ['Return'], ['A'], ['D'], ['W'], ['S'],
         ['Up', 'Space'], ['Down', 'Space'], ['Down', 'Return'], ['Up', 'Return'], ['Left'], ['Right']]
elapsed = 0
while elapsed < seconds * 1000:
    t0 = t
    r = rng.random()
    if r < 0.01:
        # Reset Level. Keypad Enter picks it: Return would also dismiss a level title.
        ev(10, 'arm')
        press('port ', t, 'Escape'); press('port ', t + 600, 'Down'); press('port ', t + 1200, 'Keypad_Enter')
        cmd(t, 'R')
        sync()
        elapsed += 8000
        continue
    keys = rng.choice(moves)
    for k in keys:
        ev(rng.randint(0, 40), f'key {k} down')
    # taps (< 3 ticks) turn without walking; long holds walk
    ev(rng.choice([20, 30, 60, 150, 400, 900, 2000]), 'mod shift off')
    for k in keys:
        ev(rng.randint(0, 30), f'key {k} up')
    ev(rng.randint(0, 600), 'mod shift off')
    elapsed += t - t0
ev(500, 'quit')
print('\n'.join(out))
