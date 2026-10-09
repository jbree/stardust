#!/usr/bin/env python3
"""Copy the resources extracted by resource_dasm into stardust-c/assets with plain names."""
import glob, os, re, shutil, sys

here = os.path.dirname(os.path.abspath(__file__))
src = os.path.join(here, '..', '..', 'extracted')
dst = os.path.join(here, '..', 'assets')
os.makedirs(dst, exist_ok=True)

n = 0
for path in glob.glob(os.path.join(src, 'Stardust 1.1.app_*')):
    name = os.path.basename(path)[len('Stardust 1.1.app_'):]
    m = re.match(r'(PICT|snd|TEXT|ICON|cicn)_(-?\d+)', name)
    if not m or name.endswith('_bitmap.png'):
        continue
    kind, rid = m.group(1).lower(), int(m.group(2))
    ext = os.path.splitext(name)[1]
    if kind == 'text' and not 200 < rid <= 250:
        continue
    shutil.copyfile(path, os.path.join(dst, f'{kind}_{rid}{ext}'))
    n += 1

# applFont: the original used Geneva; bundle it from the host when present.
for f in ['/System/Library/Fonts/Geneva.ttf']:
    if os.path.exists(f):
        shutil.copyfile(f, os.path.join(dst, 'geneva.ttf'))
print(f'{n} resources -> {os.path.normpath(dst)}', file=sys.stderr)
