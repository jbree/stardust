#!/usr/bin/env python3
"""dis.py START END : capstone disassembly of CODE 1 (offsets after the 4-byte header)."""
import sys, capstone
d = open(__file__.rsplit('/', 1)[0] + '/../../extracted/Stardust 1.1.app_CODE_1_Main.bin', 'rb').read()[4:]
s, e = int(sys.argv[1], 16), int(sys.argv[2], 16)
md = capstone.Cs(capstone.CS_ARCH_M68K, capstone.CS_MODE_BIG_ENDIAN | capstone.CS_MODE_M68K_020)
for i in md.disasm(d[s:e], s):
    print(f'{i.address:04X} {i.bytes.hex():<20} {i.mnemonic} {i.op_str}')
