#!/usr/bin/env python3
"""raw.py OFF LEN [w] : dump CODE 1 bytes at disassembly offset (header skipped)."""
import sys
d = open(__file__.rsplit('/', 2)[0] + '/../extracted/Stardust 1.1.app_CODE_1_Main.bin', 'rb').read()[4:]
off, n = int(sys.argv[1], 16), int(sys.argv[2], 0)
b = d[off:off + n]
if len(sys.argv) > 3:
    print(' '.join(f'{int.from_bytes(b[i:i+2],"big"):04X}' for i in range(0, n, 2)))
else:
    print(b.hex(' '))
