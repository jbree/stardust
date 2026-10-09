# near model CODE resource
# jump table entries: 0-6 (7 of them)
export_1:
fn00000000:
0000 move.w D0, [A7 + 0x4]
0004 lea.l A1, [A7 + 0x6]
0008 move.w D1, D0
000A lsl D1.w, 2
000C add.w A1, D1
000E movea.l A0, [A1]
0010 move.l [A1], [A7]
0012 movem.l -[A7], A0,A1,A2
0016 moveq.l D1, 0x00
0018 addq.w A0, 1
001A bra +0x1C /* 00000036 */
label0000001C:
001C movea.l A2, -[A1]
001E moveq.l D2, 0x00
0020 move.b D2, [A2]+
0022 add.b D1, D2
0024 bcc +0xE /* 00000032 */
0026 sub.b D2, D1
0028 subq.b D2, 1
002A moveq.l D0, 0x00
002C moveq.l D1, 0xFFFFFFFF
002E bra +0x4 /* 00000032 */
label00000030:
0030 move.b [A0]+, [A2]+
label00000032:
0032 dbf D2, -0x6 /* 00000030 */
label00000036:
0036 dbf D0, -0x1E /* 0000001C */
003A movem.l A0,A1,A2, [A7]+
003E move.b [A0], D1
0040 movea.l A7, A1
0042 addq.w D1, 1
0044 movea.l A0, [A7]
0046 jmp [A0]
fn00000048:
0048 move.l D0, [A5 - 0x5B0]
004C beq +0x6 /* 00000052 */
004E movea.l A0, D0
0050 jsr [A0]
label00000052:
0052 move.l D0, [A5 - 0x45A]
0056 beq +0x6 /* 0000005C */
0058 movea.l A0, D0
005A jsr [A0]
label0000005C:
005C syscall ExitToShell
fn0000005E:
005E jsr [PC + 0x4E /* 000000AE */]
0062 movea.l A6, A5
0064 subq.w [A5 - 0x22], 1
0068 move.w [A5 - 0x24], 0x2
006E clr.w [A5 - 0x2A]
0072 clr.l [A5 - 0x5B0]
0076 clr.l [A5 - 0x5AC]
007A clr.l [A5 - 0x5A8]
007E clr.l [A5 - 0x5A4]
0082 clr.w [A5 - 0x574]
0086 clr.w [A5 - 0x572]
008A st [A5 - 0x570]
008E st [A5 - 0x56F]
0092 sf [A5 - 0x56E]
0096 sf [A5 - 0x56D]
009A clr.l [A5 - 0x45A]
009E move.w D0, 0x7D0
00A2 jsr [PC + 0x20A /* 000002AE */]
00A6 movea.l A0, [A0]
00A8 move.l [A5 - 0x5B4], A0
00AC rts
fn000000AE:
00AE subq.l A7, 4
00B0 move.l -[A7], 0x5A45524F /* 'ZERO' */
00B6 clr.w -[A7]
00B8 syscall GetResource
00BA move.l D0, [A7]
00BC beq +0x10 /* 000000CC */
00BE clr.w -[A7]
00C0 move.l -[A7], D0
00C2 syscall HomeResFile
00C4 move.w D0, [A7]+
00C6 cmp.w D0, [0x00000900 /* CurApRefNum */]
00CA beq +0x6 /* 000000D0 */
label000000CC:
00CC addq.l A7, 4
00CE rts
label000000D0:
00D0 movea.l A2, [A7]
00D2 subq.l A7, 4
00D4 move.l -[A7], 0x44415441 /* 'DATA' */
00DA clr.w -[A7]
00DC syscall GetResource
00DE movea.l A0, [A7]
00E0 movea.l A0, [A0]
00E2 movea.l A1, [0x00000908 /* CurStackBase */]
00E6 movea.l A2, [A2]
00E8 bra +0x10 /* 000000F8 */
label000000EA:
00EA move.w [A1]+, [A0]+
00EC bne +0xC /* 000000F8 */
00EE move.w D1, [A2]+
00F0 bra +0x4 /* 000000F4 */
label000000F2:
00F2 clr.w [A1]+
label000000F4:
00F4 dbf D1, -0x6 /* 000000F2 */
label000000F8:
00F8 cmpa.l A5, A1
00FA bne -0x10 /* 000000EA */
00FC syscall ReleaseResource
00FE syscall ReleaseResource
0100 subq.l A7, 4
0102 move.l -[A7], 0x4452454C /* 'DREL' */
0108 clr.w -[A7]
010A syscall GetResource
010C movea.l A0, [A7]
010E syscall GetHandleSize
0110 movea.l A0, [A0]
0112 asr D0.w, 1
0114 move.l D2, A5
0116 bra +0x8 /* 0000011E */
label00000118:
0118 move.w D1, [A0]+
011A add.l [A5 + D1.w], D2
label0000011E:
011E dbf D0, -0xA /* 00000118 */
0122 syscall ReleaseResource
0124 rts
fn00000126:
0126 pea.l [PC + 0x10 /* 00000138, value 0xD '\r', cstring "" */]
label0000012A:
012A move.w -[A7], 0x1
012E syscall Pack4/FP68K
0130 rts
0132 pea.l [PC + 0x6 /* 0000013A, value 0xD4E56 '\rNV', cstring "" */]
0136 bra -0xC /* 0000012A */
0138 ori.b D0, 0xD /* '\r' */
fn0000013C:
013C link A6, 0x0000
0140 lea.l A0, [PC + 0x1A /* 0000015C, value 0x4E5E205F 'N^ _' */]
0144 movem.l [A5 - 0x5A0], D3,D4,D5,D6,D7,A0,A2,A3,A4,A6,A7
014A move.l D0, [A6 + 0x8]
014E movea.l A1, [A6 + 0xC]
0152 clr.l [A1]
0154 syscall NewPtrClear, flags=3
0156 jsr [PC + 0x168 /* 000002C0 */]
015A move.l [A1], A0
015C unlink A6
015E movea.l A0, [A7]+
0160 addq.l A7, 8
0162 jmp [A0]
export_2:
fn00000164:
0164 movem.l -[A7], D0,D1,D2,A0,A1
0168 movea.l A1, [A7 + 0x18]
016C movea.l A0, [A7 + 0x1C]
0170 move.l [A7 + 0x1C], [A7 + 0x14]
0176 moveq.l D0, 0x00
0178 move.b D0, [A0]+
017A move.w D2, D0
017C move.b D1, [A1]+
017E cmp.b D1, D0
0180 bcc +0x4 /* 00000184 */
0182 move.b D2, D1
label00000184:
0184 subq.w D2, 1
0186 blt +0xA /* 00000190 */
label00000188:
0188 cmpm.b [A1]+, [A0]+
018A dbne D2, -0x6 /* 00000188 */
018E bne +0x4 /* 00000192 */
label00000190:
0190 cmp.b D1, D0
label00000192:
0192 movem.l D0,D1,D2,A0,A1, [A7]+
0196 addq.l A7, 8
0198 rts
fn0000019A:
019A movem.l -[A7], D0,D1,A0,A1
019E move.w D1, [A7 + 0x14]
01A2 movea.l A0, [A7 + 0x16]
01A6 movea.l A1, A0
01A8 moveq.l D0, 0x00
01AA move.l [A1]+, D0
01AC move.l [A1]+, D0
01AE move.l [A1]+, D0
01B0 move.l [A1]+, D0
01B2 move.l [A1]+, D0
01B4 move.l [A1]+, D0
01B6 move.l [A1]+, D0
01B8 move.l [A1]+, D0
01BA movea.l A1, [A7 + 0x1A]
01BE subq.w D1, 1
01C0 beq +0x20 /* 000001E0 */
01C2 moveq.l D0, 0x1F
01C4 sub.w D0, D1
01C6 lsr D1.w, 1
01C8 lea.l A0, [A0 + D0.w]
label000001CC:
01CC move.w [A0]+, [A1]+
01CE dbf D1, -0x6 /* 000001CC */
label000001D2:
01D2 movem.l D0,D1,A0,A1, [A7]+
01D6 move.l [A7 + 0xA], [A7]
01DA lea.l A7, [A7 + 0xA]
01DE rts
label000001E0:
01E0 move.b [A0 + 0x1F], [A1]+
01E4 bra -0x12 /* 000001D2 */
fn000001E6:
01E6 movem.l -[A7], D0,D1,A0
01EA movea.l A0, [A7 + 0x10]
01EE move.w D0, [A7 + 0x14]
01F2 bmi +0x22 /* 00000214 */
01F4 cmpi.w D0, 0xFF
01F8 bgt +0x1C /* 00000214 */
01FA moveq.l D1, 0x1F
01FC lsr D0.w, 3
01FE sub.w D1, D0
0200 move.w D0, [A7 + 0x14]
0204 andi.w D0, 0x7
0208 move.l [A7 + 0x12], [A7 + 0xC]
020E btst [A0 + D1.w], D0
0212 bra +0xC /* 0000021E */
label00000214:
0214 move.l [A7 + 0x12], [A7 + 0xC]
021A moveq.l D0, 0x00
021C tst.b D0
label0000021E:
021E movem.l D0,D1,A0, [A7]+
0222 addq.w A7, 6
0224 rts
export_3:
fn00000226:
0226 move.l -[A7], A2
0228 movea.l A1, [A7 + 0x8]
022C movea.l A2, [A7 + 0xC]
0230 move.w D0, [A7 + 0x10]
0234 move.w D2, D0
0236 move.b D1, [A2]+
0238 cmp.b D1, D2
023A bcc +0x4 /* 0000023E */
023C move.b D2, D1
label0000023E:
023E move.b [A1]+, D2
0240 bra +0x4 /* 00000244 */
label00000242:
0242 move.b [A1]+, [A2]+
label00000244:
0244 dbf D2, -0x6 /* 00000242 */
0248 cmp.b D0, D1
024A movea.l A2, [A7]+
024C movea.l A0, [A7]+
024E lea.l A7, [A7 + 0xA]
0252 jmp [A0]
0254 addq.l A7, 4
0256 move.w D0, [A7]+
label00000258:
0258 clr.w -[A7]
025A move.w -[A7], D0
025C move.l D0, [A5 - 0x5A8]
0260 beq +0x1C /* 0000027C */
0262 movea.l A0, D0
0264 move.l D0, [A5 - 0x5A4]
0268 beq +0x4 /* 0000026C */
026A move.l -[A7], D0
label0000026C:
026C jsr [A0]
026E tst.w [A7]
0270 bne +0xC /* 0000027C */
0272 movem.l D3,D4,D5,D6,D7,A0,A2,A3,A4,A6,A7, [A5 - 0x5A0]
0278 jmp [A0]
export_4:
027A move.w -[A7], D0
label0000027C:
027C move.w D0, 0x7D1
0280 jsr [PC + 0x2C /* 000002AE */]
0284 bne +0xC /* 00000290 */
0286 move.w D0, 0x7D2
028A jsr [PC + 0x22 /* 000002AE */]
028E beq +0xA /* 00000298 */
label00000290:
0290 movea.l A0, [A0]
0292 jsr [A0]
0294 jmp [PC - 0x24E /* 00000048 */]
label00000298:
0298 pea.l [PC + 0x6 /* 000002A0, value 0xD52554E '\rRUN', pstring "RUNTIME ERROR" */]
029C syscall DebugStr
029E syscall ExitToShell
02A0 bchg [A2], D6
02A2 subq.w A6, 2
02A4 addq.w A1, 2
02A6 chk.w D6, D5
02A8 movea.l A0, D5
02AA addq.w [A2], 1
02AC chk.w D7, [A2]
fn000002AE:
02AE subq.l A7, 4
02B0 move.l -[A7], 0x4C535020 /* 'LSP ' */
02B6 move.w -[A7], D0
02B8 syscall GetResource
02BA movea.l A0, [A7]+
02BC move.l D0, A0
02BE rts
fn000002C0:
02C0 move.w [A5 - 0x574], D0
02C4 bne +0x4 /* 000002C8 */
02C6 rts
label000002C8:
02C8 tst.b [A5 - 0x570]
02CC beq +0x6 /* 000002D2 */
02CE jmp [PC - 0x78 /* 00000258 */]
label000002D2:
02D2 movem.l D3,D4,D5,D6,D7,A0,A2,A3,A4,A6,A7, [A5 - 0x5A0]
02D8 jmp [A0]
fn000002DA:
02DA rts
fn000002DC:
02DC movea.l A1, [A7]+
02DE move.l D0, [A7]+
02E0 syscall NewPtr, flags=1
02E2 move.l [A7], A0
02E4 jmp [A1]
fn000002E6:
02E6 movea.l A1, [A7]+
02E8 movea.l A0, [A7]+
02EA move.w D0, [A7]+
02EC syscall GetOSEvent
02EE addq.w D0, 1
02F0 move.b [A7], D0
02F2 jmp [A1]
fn000002F4:
02F4 movea.l A0, [A7]+
02F6 movea.l A1, [A7]+
02F8 clr.b [A1]+
02FA move.b [A1], [0x00000260 /* SdVolume */]
02FE jmp [A0]
0300 moveq.l D2, 0x02
label00000302:
0302 movea.l A0, [A7]+
0304 move.w -[A7], D2
0306 move.l -[A7], A0
0308 syscall Pack2, auto_pop
fn0000030A:
030A moveq.l D2, 0x00
030C jmp [PC - 0xC /* 00000302 */]
fn00000310:
0310 link A6, -0x002E
0314 movem.l -[A7], D5,D6,D7
0318 clr.b D6
031A moveq.l D7, 0x01
label0000031C:
031C subq.w A7, 2
031E move.w D5, D7
0320 asl D5.w, 2
0322 lea.l A0, [A5 - 0x422]
0326 move.l -[A7], [A0 + D5.w]
032A move.w -[A7], 0x18
032E pea.l [A6 - 0x2A]
0332 move.l D0, 0x100008
0338 syscall SoundDispatch
033A move.w D5, [A7]+
033C move.b D6, [A6 - 0x1E]
0340 move.b D0, D6
0342 subq.b D0, 1
0344 bne +0xA /* 0000034E */
0346 addq.w D7, 1
0348 cmpi.w D7, 0x4
034C ble -0x30 /* 0000031C */
label0000034E:
034E move.b D0, D6
0350 subq.b D0, 1
0352 beq +0x26 /* 00000378 */
0354 subq.w A7, 2
0356 move.w D5, D7
0358 asl D5.w, 2
035A lea.l A0, [A5 - 0x422]
035E move.l -[A7], [A0 + D5.w]
0362 move.w D0, [A6 + 0x8]
0366 asl D0.w, 2
0368 addi.w D0, 0xF8D2
036C move.l -[A7], [A5 + D0.w]
0370 move.b -[A7], 0x1
0374 syscall SndPlay
0376 move.w D5, [A7]+
label00000378:
0378 movem.l D5,D6,D7, [A7]+
037C unlink A6
037E movea.l A0, [A7]+
0380 addq.w A7, 2
0382 jmp [A0]
fn00000384:
0384 link A6, 0x0000
0388 subq.w A7, 2
038A syscall Random
038C move.w D0, [A7]+
038E ext.l D0
0390 divs.w D0, [A6 + 0x8]
0394 swap.w D0
0396 tst.w D0
0398 bpl +0x4 /* 0000039C */
039A neg.w D0
label0000039C:
039C addq.w D0, 1
039E move.w [A6 + 0xA], D0
03A2 unlink A6
03A4 movea.l A0, [A7]+
03A6 addq.w A7, 2
03A8 jmp [A0]
fn000003AA:
03AA tst.b [A5 - 0x2C0]
03AE beq +0x8 /* 000003B6 */
03B0 syscall HideCursor
03B2 clr.b [A5 - 0x2C0]
label000003B6:
03B6 rts
fn000003B8:
03B8 move.b D0, [A5 - 0x2C0]
03BC subq.b D0, 1
03BE beq +0xA /* 000003C8 */
03C0 syscall ShowCursor
03C2 move.b [A5 - 0x2C0], 0x1
label000003C8:
03C8 rts
fn000003CA:
03CA move.b [A5 - 0x2C0], 0x1
03D0 rts
fn000003D2:
03D2 link A6, -0x0016
03D6 movem.l -[A7], D6,D7,A4
03DA move.w D7, [A6 + 0x8]
03DE cmpi.w D7, 0x6C /* 'l' */
03E2 seq D0
03E4 and.b D0, [A5 - 0x3C8]
03E8 beq +0x4 /* 000003EC */
03EA moveq.l D7, 0x6F
label000003EC:
03EC move.w -[A7], D7
03EE pea.l [PC + 0x4E /* 0000043E, value 0x0, cstring "" */]
03F2 jsr [PC - 0x20E /* 000001E6 */]
03F6 sne D0
03F8 and.b D0, [A5 - 0x3C8]
03FC bne +0x36 /* 00000432 */
03FE tst.b [A5 - 0x3C9]
0402 beq +0x30 /* 00000432 */
0404 cmpi.w D7, 0xC8
0408 bge +0x24 /* 0000042C */
040A subq.w A7, 4
040C move.l -[A7], 0x736E6420 /* 'snd ' */
0412 move.w -[A7], D7
0414 syscall GetResource
0416 movea.l A4, [A7]+
0418 subq.w A7, 2
041A move.l -[A7], [A5 - 0x40E]
041E move.l -[A7], A4
0420 clr.b -[A7]
0422 syscall SndPlay
0424 move.w D6, [A7]+
0426 move.l -[A7], A4
0428 syscall ReleaseResource
042A bra +0x8 /* 00000432 */
label0000042C:
042C move.w -[A7], D7
042E jsr [PC - 0x120 /* 00000310 */]
label00000432:
0432 movem.l D6,D7,A4, [A7]+
0436 unlink A6
0438 movea.l A0, [A7]+
043A addq.w A7, 2
043C jmp [A0]
043E ori.b D0, 0x0
0442 ori.w [A3]+, 0x8000
0446 ori.b D0, 0x0
044A ori.b D0, 0x0
044E ori.b D1, 0x0
0452 ori.b D0, 0x0
0456 ori.b D0, 0x0
045A ori.b D0, 0x0
fn0000045E:
045E link A6, -0x002C
0462 move.l -[A7], A4
0464 subq.w A7, 4
0466 move.w D0, [A6 + 0x8]
046A addi.w D0, 0x12C
046E move.w -[A7], D0
0470 syscall GetPicture
0472 movea.l A4, [A7]+
0474 move.l -[A7], [A5 - 0x432]
0478 move.l -[A7], [A5 - 0x42E]
047C move.l D0, 0x80006
0482 syscall QDExtensions
0484 move.l D0, A4
0486 beq +0x76 /* 000004FC */
0488 pea.l [A6 - 0x1C]
048C clr.w -[A7]
048E move.w -[A7], 0x14
0492 move.w -[A7], 0x280
0496 move.w -[A7], 0x1E0
049A syscall SetRect
049C move.l -[A7], A4
049E pea.l [A6 - 0x1C]
04A2 syscall DrawPicture
04A4 move.l -[A7], A4
04A6 syscall ReleaseResource
04A8 move.w -[A7], 0x6B /* 'k' */
04AC jsr [PC - 0xDC /* 000003D2 */]
04B0 pea.l [A6 - 0x2C]
04B4 syscall GetKeys
04B6 bra +0x12 /* 000004C8 */
label000004B8:
04B8 pea.l [A6 - 0x2C]
04BC syscall GetKeys
04BE move.w -[A7], 0xFFFF
04C2 clr.w -[A7]
04C4 move.l D0, [A7]+
04C6 syscall FlushEvents
label000004C8:
04C8 subq.w A7, 2
04CA syscall Button
04CC move.b D0, [A7]+
04CE subq.b D0, 1
04D0 moveq.l D1, 0x31
04D2 move.w D2, D1
04D4 lsr D2.w, 3
04D6 btst [A6 + D2.w - 0x2C], D1
04DA seq D1
04DC and.b D0, D1
04DE moveq.l D1, 0x0C
04E0 move.w D2, D1
04E2 lsr D2.w, 3
04E4 btst [A6 + D2.w - 0x2C], D1
04E8 seq D1
04EA and.b D0, D1
04EC moveq.l D1, 0x24
04EE move.w D2, D1
04F0 lsr D2.w, 3
04F2 btst [A6 + D2.w - 0x2C], D1
04F6 seq D1
04F8 and.b D0, D1
04FA bne -0x42 /* 000004B8 */
label000004FC:
04FC movea.l A4, [A7]+
04FE unlink A6
0500 movea.l A0, [A7]+
0502 addq.w A7, 2
0504 jmp [A0]
fn00000506:
0506 link A6, -0x002A
050A move.l -[A7], A4
050C move.b [A5 - 0x2BE], 0x1
0512 subq.w A7, 4
0514 move.w -[A7], 0x64 /* 'd' */
0518 syscall GetPicture
051A movea.l A4, [A7]+
051C pea.l [A6 - 0x20]
0520 clr.w -[A7]
0522 clr.w -[A7]
0524 movea.l A0, [A4]
0526 movea.l A1, [A4]
0528 move.w D0, [A0 + 0x8]
052C sub.w D0, [A1 + 0x4]
0530 move.w -[A7], D0
0532 movea.l A0, [A4]
0534 movea.l A1, [A4]
0536 move.w D0, [A0 + 0x6]
053A sub.w D0, [A1 + 0x2]
053E move.w -[A7], D0
0540 syscall SetRect
0542 subq.w A7, 2
0544 pea.l [A6 - 0x14]
0548 move.w -[A7], 0x1
054C pea.l [A6 - 0x20]
0550 clr.l -[A7]
0552 clr.l -[A7]
0554 clr.l [A6 - 0x2A]
0558 move.l -[A7], [A6 - 0x2A]
055C move.l D0, 0x160000
0562 syscall QDExtensions
0564 move.w [A6 - 0x22], [A7]+
0568 subq.w A7, 2
056A subq.w A7, 4
056C move.l -[A7], [A6 - 0x14]
0570 move.l D0, 0x40017
0576 syscall QDExtensions
0578 move.l D0, 0x40001
057E syscall QDExtensions
0580 move.b [A6 - 0x23], [A7]+
0584 move.l -[A7], [A6 - 0x14]
0588 clr.l -[A7]
058A move.l D0, 0x80006
0590 syscall QDExtensions
0592 move.l -[A7], A4
0594 pea.l [A6 - 0x20]
0598 syscall DrawPicture
059A move.l -[A7], A4
059C syscall ReleaseResource
059E subq.w A7, 4
05A0 syscall NewRgn
05A2 move.l [A5 - 0x2B4], [A7]+
05A6 subq.w A7, 4
05A8 syscall NewRgn
05AA move.l [A5 - 0x2A8], [A7]+
05AE move.l -[A7], [A5 - 0x2A8]
05B2 syscall GetClip
05B4 subq.w A7, 4
05B6 syscall NewRgn
05B8 move.l [A5 - 0x2B0], [A7]+
05BC subq.w A7, 2
05BE move.l -[A7], [A5 - 0x2B4]
05C2 movea.l A0, [A6 - 0x14]
05C6 pea.l [A0 + 0x2]
05CA syscall BitMapToRegion/BitMapRgn
05CC move.w [A6 - 0x26], [A7]+
05D0 move.l -[A7], [A5 - 0x2B4]
05D4 move.w -[A7], 0x54 /* 'T' */
05D8 move.w -[A7], 0x64 /* 'd' */
05DC syscall OffsetRgn/OfsetRgn
05DE move.l -[A7], [A5 - 0x432]
05E2 move.l -[A7], [A5 - 0x42E]
05E6 move.l D0, 0x80006
05EC syscall QDExtensions
05EE move.l -[A7], [A6 - 0x14]
05F2 move.l D0, 0x40004
05F8 syscall QDExtensions
05FA move.l -[A7], [A5 - 0x2A8]
05FE syscall GetClip
0600 move.l -[A7], [A5 - 0x2B4]
0604 move.l -[A7], [A5 - 0x2B0]
0608 syscall CopyRgn
060A move.l -[A7], [A5 - 0x2A8]
060E move.l -[A7], [A5 - 0x2B4]
0612 move.l -[A7], [A5 - 0x2B0]
0616 syscall DiffRgn
0618 movea.l A4, [A7]+
061A unlink A6
061C rts
fn0000061E:
061E link A6, -0x001E
0622 movem.l -[A7], D7,A3,A4
0626 move.l -[A7], [A5 - 0x452]
062A clr.l -[A7]
062C move.l D0, 0x80006
0632 syscall QDExtensions
0634 moveq.l D7, 0x01
label00000636:
0636 subq.w A7, 4
0638 move.w D0, D7
063A addi.w D0, 0x64 /* 'd' */
063E move.w -[A7], D0
0640 syscall GetPicture
0642 movea.l A4, [A7]+
0644 move.w D0, D7
0646 asl D0.w, 3
0648 addi.w D0, 0xFDCE
064C pea.l [A5 + D0.w]
0650 clr.w -[A7]
0652 move.w D0, D7
0654 subq.w D0, 1
0656 movea.l A0, [A4]
0658 movea.l A1, [A4]
065A move.w D1, [A0 + 0x6]
065E sub.w D1, [A1 + 0x2]
0662 muls.w D0, D1
0664 move.w -[A7], D0
0666 movea.l A0, [A4]
0668 movea.l A1, [A4]
066A move.w D0, [A0 + 0x8]
066E sub.w D0, [A1 + 0x4]
0672 move.w -[A7], D0
0674 movea.l A0, [A4]
0676 movea.l A1, [A4]
0678 move.w D0, [A0 + 0x6]
067C sub.w D0, [A1 + 0x2]
0680 muls.w D0, D7
0682 move.w -[A7], D0
0684 syscall SetRect
0686 move.l -[A7], A4
0688 move.w D0, D7
068A asl D0.w, 3
068C addi.w D0, 0xFDCE
0690 pea.l [A5 + D0.w]
0694 syscall DrawPicture
0696 move.l -[A7], A4
0698 syscall ReleaseResource
069A addq.w D7, 1
069C cmpi.w D7, 0x3
06A0 ble -0x6A /* 00000636 */
06A2 move.l -[A7], [A5 - 0x456]
06A6 clr.l -[A7]
06A8 move.l D0, 0x80006
06AE syscall QDExtensions
06B0 moveq.l D0, 0x1E
06B2 move.l -[A7], D0
06B4 syscall BackColor
06B6 moveq.l D0, 0x21
06B8 move.l -[A7], D0
06BA syscall ForeColor
06BC pea.l [A5 - 0x42A]
06C0 syscall PaintRect
06C2 pea.l [A5 - 0x212]
06C6 move.w -[A7], 0x54 /* 'T' */
06CA move.w -[A7], 0x64 /* 'd' */
06CE move.w D0, [A5 - 0x224]
06D2 addi.w D0, 0x54 /* 'T' */
06D6 sub.w D0, [A5 - 0x228]
06DA move.w -[A7], D0
06DC move.w D0, [A5 - 0x226]
06E0 addi.w D0, 0x64 /* 'd' */
06E4 sub.w D0, [A5 - 0x22A]
06E8 move.w -[A7], D0
06EA syscall SetRect
06EC movea.l A0, [A5 - 0x452]
06F0 pea.l [A0 + 0x2]
06F4 movea.l A0, [A5 - 0x456]
06F8 pea.l [A0 + 0x2]
06FC pea.l [A5 - 0x22A]
0700 pea.l [A5 - 0x212]
0704 clr.w -[A7]
0706 clr.l -[A7]
0708 syscall CopyBits
070A move.l -[A7], [A5 - 0x432]
070E move.l -[A7], [A5 - 0x42E]
0712 move.l D0, 0x80006
0718 syscall QDExtensions
071A move.w [A5 - 0x2A4], 0x1
0720 move.w [A5 - 0x2A0], 0x140
0726 move.w [A5 - 0x2A2], 0xF0
072C move.w [A5 - 0x29C], 0x140
0732 move.w [A5 - 0x29E], 0x15
0738 move.w [A5 - 0x298], 0x15
073E move.w [A5 - 0x29A], 0x1DB
0744 move.w [A5 - 0x294], 0x26B
074A move.w [A5 - 0x296], 0x1DB
0750 move.w [A5 - 0x232], 0x1
0756 clr.l [A5 - 0x22E]
075A move.w [A5 - 0x28C], 0xFFF8
0760 move.w [A5 - 0x28E], 0x5
0766 move.w [A5 - 0x27C], 0xFFF7
076C move.w [A5 - 0x27E], 0x9 /* '\t' */
0772 move.w [A5 - 0x26C], 0x9 /* '\t' */
0778 move.w [A5 - 0x26E], 0x5
077E move.w [A5 - 0x25C], 0x8
0784 move.w [A5 - 0x25E], 0xFFF4
078A move.w [A5 - 0x24C], 0xFFFB
0790 move.w [A5 - 0x24E], 0xFFFB
0796 moveq.l D7, 0x01
label00000798:
0798 move.w D0, D7
079A asl D0.w, 4
079C addi.w D0, 0xFD5E
07A0 lea.l A3, [A5 + D0.w]
07A4 move.w [A3 + 0x2], 0x140
07AA move.w [A3], 0xF0
07AE move.w D0, D7
07B0 asl D0.w, 4
07B2 addi.w D0, 0xFD5E
07B6 move.l [A3 + 0x8], [A5 + D0.w]
07BC move.w D0, D7
07BE asl D0.w, 4
07C0 addi.w D0, 0xFD62
07C4 move.l [A3 + 0xC], [A5 + D0.w]
07CA addq.w D7, 1
07CC cmpi.w D7, 0x5
07D0 ble -0x38 /* 00000798 */
07D2 clr.w [A5 - 0x230]
07D6 movem.l D7,A3,A4, [A7]+
07DA unlink A6
07DC rts
fn000007DE:
07DE link A6, -0x0022
07E2 movem.l -[A7], D7,A4
07E6 moveq.l D0, 0x04
07E8 sub.w D0, [A5 - 0x2A4]
07EC move.w [A5 - 0x2A4], D0
07F0 move.l -[A7], [A5 - 0x456]
07F4 clr.l -[A7]
07F6 move.l D0, 0x80006
07FC syscall QDExtensions
07FE moveq.l D0, 0x21
0800 move.l -[A7], D0
0802 syscall ForeColor
0804 moveq.l D0, 0x1E
0806 move.l -[A7], D0
0808 syscall BackColor
080A pea.l [A5 - 0x42A]
080E syscall PaintRect
0810 movea.l A0, [A5 - 0x452]
0814 pea.l [A0 + 0x2]
0818 movea.l A0, [A5 - 0x456]
081C pea.l [A0 + 0x2]
0820 pea.l [A5 - 0x22A]
0824 pea.l [A5 - 0x212]
0828 clr.w -[A7]
082A clr.l -[A7]
082C syscall CopyBits
082E move.l -[A7], [A5 - 0x432]
0832 move.l -[A7], [A5 - 0x42E]
0836 move.l D0, 0x80006
083C syscall QDExtensions
083E pea.l [A6 - 0x18]
0842 clr.w -[A7]
0844 move.w -[A7], 0x14
0848 move.w -[A7], 0x280
084C move.w -[A7], 0x1E0
0850 syscall SetRect
0852 movea.l A0, [A5 - 0x456]
0856 pea.l [A0 + 0x2]
085A movea.l A0, [A5 - 0x432]
085E pea.l [A0 + 0x2]
0862 pea.l [A6 - 0x18]
0866 pea.l [A6 - 0x18]
086A clr.w -[A7]
086C clr.l -[A7]
086E syscall CopyBits
0870 moveq.l D7, 0x01
label00000872:
0872 move.w D0, D7
0874 asl D0.w, 4
0876 addi.w D0, 0xFD5E
087A lea.l A4, [A5 + D0.w]
087E move.w [A4 + 0x2], 0x140
0884 move.w [A4], 0xF0
0888 subq.w A7, 2
088A move.w -[A7], 0x1B
088E jsr [PC - 0x50C /* 00000384 */]
0892 move.w D0, [A7]+
0894 bpl +0x4 /* 00000898 */
0896 neg.w D0
label00000898:
0898 addi.w D0, 0xFFF3
089C move.w [A4 + 0x6], D0
08A0 bra +0x1A /* 000008BA */
label000008A2:
08A2 subq.w A7, 2
08A4 move.w -[A7], 0x1B
08A8 jsr [PC - 0x526 /* 00000384 */]
08AC move.w D0, [A7]+
08AE bpl +0x4 /* 000008B2 */
08B0 neg.w D0
label000008B2:
08B2 addi.w D0, 0xFFF3
08B6 move.w [A4 + 0x6], D0
label000008BA:
08BA move.w D0, [A4 + 0x6]
08BE bpl +0x4 /* 000008C2 */
08C0 neg.w D0
label000008C2:
08C2 subq.w D0, 5
08C4 blt -0x22 /* 000008A2 */
08C6 subq.w A7, 2
08C8 move.w -[A7], 0x1B
08CC jsr [PC - 0x54A /* 00000384 */]
08D0 move.w D0, [A7]+
08D2 bpl +0x4 /* 000008D6 */
08D4 neg.w D0
label000008D6:
08D6 addi.w D0, 0xFFF3
08DA move.w [A4 + 0x4], D0
08DE bra +0x1A /* 000008F8 */
label000008E0:
08E0 subq.w A7, 2
08E2 move.w -[A7], 0x1B
08E6 jsr [PC - 0x564 /* 00000384 */]
08EA move.w D0, [A7]+
08EC bpl +0x4 /* 000008F0 */
08EE neg.w D0
label000008F0:
08F0 addi.w D0, 0xFFF3
08F4 move.w [A4 + 0x4], D0
label000008F8:
08F8 move.w D0, [A4 + 0x4]
08FC bpl +0x4 /* 00000900 */
08FE neg.w D0
label00000900:
0900 subq.w D0, 5
0902 blt -0x22 /* 000008E0 */
0904 move.w D0, D7
0906 asl D0.w, 4
0908 addi.w D0, 0xFD5E
090C move.l [A4 + 0x8], [A5 + D0.w]
0912 move.w D0, D7
0914 asl D0.w, 4
0916 addi.w D0, 0xFD62
091A move.l [A4 + 0xC], [A5 + D0.w]
0920 addq.w D7, 1
0922 cmpi.w D7, 0x5
0926 ble -0xB4 /* 00000872 */
092A clr.w [A5 - 0x230]
092E move.w [A5 - 0x240], 0x140
0934 move.w [A5 - 0x242], 0xF0
093A move.l [A5 - 0x23E], [A5 - 0x242]
0940 subq.w A7, 2
0942 move.w -[A7], 0x33 /* '3' */
0946 jsr [PC - 0x5C4 /* 00000384 */]
094A move.w D0, [A7]+
094C bpl +0x4 /* 00000950 */
094E neg.w D0
label00000950:
0950 addi.w D0, 0xFFE7
0954 move.w [A5 - 0x238], D0
0958 bra +0x1A /* 00000972 */
label0000095A:
095A subq.w A7, 2
095C move.w -[A7], 0x33 /* '3' */
0960 jsr [PC - 0x5DE /* 00000384 */]
0964 move.w D0, [A7]+
0966 bpl +0x4 /* 0000096A */
0968 neg.w D0
label0000096A:
096A addi.w D0, 0xFFE7
096E move.w [A5 - 0x238], D0
label00000972:
0972 move.w D0, [A5 - 0x238]
0976 bpl +0x4 /* 0000097A */
0978 neg.w D0
label0000097A:
097A subq.w D0, 2
097C blt -0x22 /* 0000095A */
097E subq.w A7, 2
0980 move.w -[A7], 0x33 /* '3' */
0984 jsr [PC - 0x602 /* 00000384 */]
0988 move.w D0, [A7]+
098A bpl +0x4 /* 0000098E */
098C neg.w D0
label0000098E:
098E addi.w D0, 0xFFE7
0992 move.w [A5 - 0x23A], D0
0996 bra +0x1A /* 000009B0 */
label00000998:
0998 subq.w A7, 2
099A move.w -[A7], 0x33 /* '3' */
099E jsr [PC - 0x61C /* 00000384 */]
09A2 move.w D0, [A7]+
09A4 bpl +0x4 /* 000009A8 */
09A6 neg.w D0
label000009A8:
09A8 addi.w D0, 0xFFE7
09AC move.w [A5 - 0x23A], D0
label000009B0:
09B0 move.w D0, [A5 - 0x23A]
09B4 bpl +0x4 /* 000009B8 */
09B6 neg.w D0
label000009B8:
09B8 subq.w D0, 2
09BA blt -0x22 /* 00000998 */
09BC subq.w A7, 2
09BE move.w -[A7], 0x33 /* '3' */
09C2 jsr [PC - 0x640 /* 00000384 */]
09C6 move.w D0, [A7]+
09C8 bpl +0x4 /* 000009CC */
09CA neg.w D0
label000009CC:
09CC addi.w D0, 0xFFE7
09D0 move.w [A5 - 0x234], D0
09D4 bra +0x1A /* 000009EE */
label000009D6:
09D6 subq.w A7, 2
09D8 move.w -[A7], 0x33 /* '3' */
09DC jsr [PC - 0x65A /* 00000384 */]
09E0 move.w D0, [A7]+
09E2 bpl +0x4 /* 000009E6 */
09E4 neg.w D0
label000009E6:
09E6 addi.w D0, 0xFFE7
09EA move.w [A5 - 0x234], D0
label000009EE:
09EE move.w D0, [A5 - 0x234]
09F2 bpl +0x4 /* 000009F6 */
09F4 neg.w D0
label000009F6:
09F6 subq.w D0, 2
09F8 slt D0
09FA move.w D1, [A5 - 0x234]
09FE cmp.w D1, [A5 - 0x238]
0A02 seq D1
0A04 or.b D0, D1
0A06 bne -0x30 /* 000009D6 */
0A08 subq.w A7, 2
0A0A move.w -[A7], 0x33 /* '3' */
0A0E jsr [PC - 0x68C /* 00000384 */]
0A12 move.w D0, [A7]+
0A14 bpl +0x4 /* 00000A18 */
0A16 neg.w D0
label00000A18:
0A18 addi.w D0, 0xFFE7
0A1C move.w [A5 - 0x236], D0
0A20 bra +0x1A /* 00000A3A */
label00000A22:
0A22 subq.w A7, 2
0A24 move.w -[A7], 0x33 /* '3' */
0A28 jsr [PC - 0x6A6 /* 00000384 */]
0A2C move.w D0, [A7]+
0A2E bpl +0x4 /* 00000A32 */
0A30 neg.w D0
label00000A32:
0A32 addi.w D0, 0xFFE7
0A36 move.w [A5 - 0x236], D0
label00000A3A:
0A3A move.w D0, [A5 - 0x236]
0A3E bpl +0x4 /* 00000A42 */
0A40 neg.w D0
label00000A42:
0A42 subq.w D0, 2
0A44 slt D0
0A46 move.w D1, [A5 - 0x236]
0A4A cmp.w D1, [A5 - 0x23A]
0A4E seq D1
0A50 or.b D0, D1
0A52 bne -0x30 /* 00000A22 */
0A54 movem.l D7,A4, [A7]+
0A58 unlink A6
0A5A move.l [A7], [A7]+
0A5C rts
fn00000A5E:
0A5E link A6, 0x0000
0A62 move.w D0, [A6 + 0x12]
0A66 add.w D0, [A6 + 0xE]
0A6A ext.l D0
0A6C divs.w D0, 0x2
0A70 move.w [A6 + 0x16], D0
0A74 move.w D0, [A6 + 0x10]
0A78 add.w D0, [A6 + 0xC]
0A7C ext.l D0
0A7E divs.w D0, 0x2
0A82 move.w [A6 + 0x14], D0
0A86 unlink A6
0A88 movea.l A0, [A7]+
0A8A lea.l A7, [A7 + 0xC]
0A8E jmp [A0]
fn00000A90:
0A90 link A6, 0x0000
0A94 movem.l -[A7], A3,A4
0A98 movea.l A4, [A6 + 0xC]
0A9C movea.l A3, [A6 + 0x10]
0AA0 move.l -[A7], [A4]
0AA2 move.l -[A7], A3
0AA4 syscall AddPt
0AA6 tst.w [A3 + 0x2]
0AAA bge +0x12 /* 00000ABC */
0AAC clr.w [A3 + 0x2]
0AB0 move.w D0, [A4 + 0x2]
0AB4 bpl +0x4 /* 00000AB8 */
0AB6 neg.w D0
label00000AB8:
0AB8 move.w [A4 + 0x2], D0
label00000ABC:
0ABC cmpi.w [A3], 0x15
0AC0 bge +0xE /* 00000ACE */
0AC2 move.w [A3], 0x15
0AC6 move.w D0, [A4]
0AC8 bpl +0x4 /* 00000ACC */
0ACA neg.w D0
label00000ACC:
0ACC move.w [A4], D0
label00000ACE:
0ACE cmpi.w [A3 + 0x2], 0x280
0AD4 ble +0x16 /* 00000AEA */
0AD6 move.w [A3 + 0x2], 0x280
0ADC move.w D0, [A4 + 0x2]
0AE0 bpl +0x4 /* 00000AE4 */
0AE2 neg.w D0
label00000AE4:
0AE4 neg.w D0
0AE6 move.w [A4 + 0x2], D0
label00000AEA:
0AEA cmpi.w [A3], 0x1E0
0AEE ble +0x10 /* 00000AFE */
0AF0 move.w [A3], 0x1E0
0AF4 move.w D0, [A4]
0AF6 bpl +0x4 /* 00000AFA */
0AF8 neg.w D0
label00000AFA:
0AFA neg.w D0
0AFC move.w [A4], D0
label00000AFE:
0AFE movem.l A3,A4, [A7]+
0B02 unlink A6
0B04 movea.l A0, [A7]+
0B06 lea.l A7, [A7 + 0xC]
0B0A jmp [A0]
fn00000B0C:
0B0C link A6, -0x0018
0B10 move.l -[A7], D7
0B12 move.b D0, [A5 - 0x2BE]
0B16 subq.b D0, 1
0B18 beq +0x35C /* 00000E74 */
0B1C move.w D0, [A5 - 0x2A4]
0B20 bra +0x342 /* 00000E62 */
label00000B24:
0B24 subq.w A7, 4
0B26 move.l -[A7], [A5 - 0x2A2]
0B2A subq.w A7, 2
0B2C move.w -[A7], 0x3
0B30 jsr [PC - 0x7AE /* 00000384 */]
0B34 move.w D0, [A7]+
0B36 asl D0.w, 2
0B38 addi.w D0, 0xFD5E
0B3C move.l -[A7], [A5 + D0.w]
0B40 move.l -[A7], A6
0B42 jsr [PC - 0xE6 /* 00000A5E */]
0B46 move.l [A5 - 0x2A2], [A7]+
0B4A subq.w A7, 2
0B4C move.l -[A7], [A5 - 0x2A2]
0B50 move.l -[A7], [A5 - 0x2B4]
0B54 syscall PtInRgn
0B56 tst.b [A7]+
0B58 beq +0x16 /* 00000B6E */
0B5A move.l -[A7], [A5 - 0x432]
0B5E move.l -[A7], [A5 - 0x42E]
0B62 move.l D0, 0x80006
0B68 syscall QDExtensions
0B6A bra +0x30A /* 00000E74 */
label00000B6E:
0B6E clr.w [A6 - 0x16]
0B72 subq.w A7, 2
0B74 move.w -[A7], 0x4
0B78 jsr [PC - 0x7F6 /* 00000384 */]
0B7C move.w D0, [A7]+
0B7E subq.w D0, 1
0B80 muls.w D0, 0x2710
0B84 moveq.l D1, 0xFFFFFFFF
0B86 sub.w D1, D0
0B88 move.w [A6 - 0x12], D1
0B8C subq.w A7, 2
0B8E move.w -[A7], 0x4
0B92 jsr [PC - 0x810 /* 00000384 */]
0B96 move.w D0, [A7]+
0B98 subq.w D0, 1
0B9A muls.w D0, 0x2710
0B9E moveq.l D1, 0xFFFFFFFF
0BA0 sub.w D1, D0
0BA2 move.w [A6 - 0x14], D1
0BA6 move.l -[A7], [A5 - 0x456]
0BAA clr.l -[A7]
0BAC move.l D0, 0x80006
0BB2 syscall QDExtensions
0BB4 move.w -[A7], [A5 - 0x2A0]
0BB8 move.w -[A7], [A5 - 0x2A2]
0BBC pea.l [A6 - 0x16]
0BC0 syscall SetCPixel
0BC2 move.l -[A7], [A5 - 0x432]
0BC6 move.l -[A7], [A5 - 0x42E]
0BCA move.l D0, 0x80006
0BD0 syscall QDExtensions
0BD2 move.w -[A7], [A5 - 0x2A0]
0BD6 move.w -[A7], [A5 - 0x2A2]
0BDA pea.l [A6 - 0x16]
0BDE syscall SetCPixel
0BE0 bra +0x294 /* 00000E74 */
label00000BE4:
0BE4 move.w D0, [A5 - 0x230]
0BE8 addq.w D0, 1
0BEA move.w [A5 - 0x230], D0
0BEE cmpi.w [A5 - 0x230], 0xBB8
0BF4 ble +0x8 /* 00000BFC */
0BF6 move.w [A5 - 0x230], 0x7D0
label00000BFC:
0BFC moveq.l D7, 0x01
label00000BFE:
0BFE move.w D0, D7
0C00 asl D0.w, 4
0C02 addi.w D0, 0xFD5E
0C06 pea.l [A5 + D0.w]
0C0A move.w D0, D7
0C0C asl D0.w, 4
0C0E addi.w D0, 0xFD62
0C12 pea.l [A5 + D0.w]
0C16 move.l -[A7], A6
0C18 jsr [PC - 0x18A /* 00000A90 */]
0C1C addq.w D7, 1
0C1E cmpi.w D7, 0x5
0C22 ble -0x24 /* 00000BFE */
0C24 cmpi.w [A5 - 0x230], 0x5
0C2A ble +0x2A /* 00000C54 */
0C2C moveq.l D7, 0x01
label00000C2E:
0C2E move.w D0, D7
0C30 asl D0.w, 4
0C32 addi.w D0, 0xFD66
0C36 pea.l [A5 + D0.w]
0C3A move.w D0, D7
0C3C asl D0.w, 4
0C3E addi.w D0, 0xFD6A
0C42 pea.l [A5 + D0.w]
0C46 move.l -[A7], A6
0C48 jsr [PC - 0x1BA /* 00000A90 */]
0C4C addq.w D7, 1
0C4E cmpi.w D7, 0x5
0C52 ble -0x24 /* 00000C2E */
label00000C54:
0C54 clr.w [A6 - 0x16]
0C58 subq.w A7, 2
0C5A move.w -[A7], 0x4
0C5E jsr [PC - 0x8DC /* 00000384 */]
0C62 move.w D0, [A7]+
0C64 subq.w D0, 1
0C66 muls.w D0, 0x2710
0C6A moveq.l D1, 0xFFFFFFFF
0C6C sub.w D1, D0
0C6E move.w [A6 - 0x12], D1
0C72 subq.w A7, 2
0C74 move.w -[A7], 0x4
0C78 jsr [PC - 0x8F6 /* 00000384 */]
0C7C move.w D0, [A7]+
0C7E subq.w D0, 1
0C80 muls.w D0, 0x2710
0C84 moveq.l D1, 0xFFFFFFFF
0C86 sub.w D1, D0
0C88 move.w [A6 - 0x14], D1
0C8C pea.l [A6 - 0x16]
0C90 syscall RGBForeColor
0C92 move.l -[A7], [A5 - 0x456]
0C96 clr.l -[A7]
0C98 move.l D0, 0x80006
0C9E syscall QDExtensions
0CA0 move.l -[A7], [A5 - 0x2B0]
0CA4 syscall SetClip
0CA6 move.w -[A7], [A5 - 0x250]
0CAA move.w -[A7], [A5 - 0x252]
0CAE syscall MoveTo
0CB0 moveq.l D7, 0x01
label00000CB2:
0CB2 move.w D0, D7
0CB4 asl D0.w, 4
0CB6 addi.w D0, 0xFD60
0CBA move.w -[A7], [A5 + D0.w]
0CBE move.w D0, D7
0CC0 asl D0.w, 4
0CC2 addi.w D0, 0xFD5E
0CC6 move.w -[A7], [A5 + D0.w]
0CCA syscall LineTo
0CCC addq.w D7, 1
0CCE cmpi.w D7, 0x5
0CD2 ble -0x20 /* 00000CB2 */
0CD4 move.w -[A7], [A5 - 0x248]
0CD8 move.w -[A7], [A5 - 0x24A]
0CDC syscall MoveTo
0CDE moveq.l D7, 0x01
label00000CE0:
0CE0 move.w D0, D7
0CE2 asl D0.w, 4
0CE4 addi.w D0, 0xFD68
0CE8 move.w -[A7], [A5 + D0.w]
0CEC move.w D0, D7
0CEE asl D0.w, 4
0CF0 addi.w D0, 0xFD66
0CF4 move.w -[A7], [A5 + D0.w]
0CF8 syscall LineTo
0CFA addq.w D7, 1
0CFC cmpi.w D7, 0x5
0D00 ble -0x20 /* 00000CE0 */
0D02 move.l -[A7], [A5 - 0x2A8]
0D06 syscall SetClip
0D08 move.l -[A7], [A5 - 0x432]
0D0C move.l -[A7], [A5 - 0x42E]
0D10 move.l D0, 0x80006
0D16 syscall QDExtensions
0D18 move.l -[A7], [A5 - 0x2B0]
0D1C syscall SetClip
0D1E move.w -[A7], [A5 - 0x250]
0D22 move.w -[A7], [A5 - 0x252]
0D26 syscall MoveTo
0D28 moveq.l D7, 0x01
label00000D2A:
0D2A move.w D0, D7
0D2C asl D0.w, 4
0D2E addi.w D0, 0xFD60
0D32 move.w -[A7], [A5 + D0.w]
0D36 move.w D0, D7
0D38 asl D0.w, 4
0D3A addi.w D0, 0xFD5E
0D3E move.w -[A7], [A5 + D0.w]
0D42 syscall LineTo
0D44 addq.w D7, 1
0D46 cmpi.w D7, 0x5
0D4A ble -0x20 /* 00000D2A */
0D4C moveq.l D0, 0x21
0D4E move.l -[A7], D0
0D50 syscall ForeColor
0D52 move.w -[A7], [A5 - 0x248]
0D56 move.w -[A7], [A5 - 0x24A]
0D5A syscall MoveTo
0D5C moveq.l D7, 0x01
label00000D5E:
0D5E move.w D0, D7
0D60 asl D0.w, 4
0D62 addi.w D0, 0xFD68
0D66 move.w -[A7], [A5 + D0.w]
0D6A move.w D0, D7
0D6C asl D0.w, 4
0D6E addi.w D0, 0xFD66
0D72 move.w -[A7], [A5 + D0.w]
0D76 syscall LineTo
0D78 addq.w D7, 1
0D7A cmpi.w D7, 0x5
0D7E ble -0x20 /* 00000D5E */
0D80 move.l -[A7], [A5 - 0x2A8]
0D84 syscall SetClip
0D86 bra +0xEE /* 00000E74 */
label00000D8A:
0D8A pea.l [A5 - 0x242]
0D8E pea.l [A5 - 0x23A]
0D92 move.l -[A7], A6
0D94 jsr [PC - 0x306 /* 00000A90 */]
0D98 pea.l [A5 - 0x23E]
0D9C pea.l [A5 - 0x236]
0DA0 move.l -[A7], A6
0DA2 jsr [PC - 0x314 /* 00000A90 */]
0DA6 subq.w A7, 4
0DA8 move.l -[A7], [A5 - 0x242]
0DAC move.l -[A7], [A5 - 0x23E]
0DB0 move.l -[A7], A6
0DB2 jsr [PC - 0x356 /* 00000A5E */]
0DB6 move.l [A5 - 0x2A2], [A7]+
0DBA move.l -[A7], [A5 - 0x432]
0DBE move.l -[A7], [A5 - 0x42E]
0DC2 move.l D0, 0x80006
0DC8 syscall QDExtensions
0DCA move.l -[A7], [A5 - 0x456]
0DCE clr.l -[A7]
0DD0 move.l D0, 0x80006
0DD6 syscall QDExtensions
0DD8 clr.w [A6 - 0x14]
0DDC subq.w A7, 2
0DDE move.w -[A7], 0x4
0DE2 jsr [PC - 0xA60 /* 00000384 */]
0DE6 move.w D0, [A7]+
0DE8 subq.w D0, 1
0DEA muls.w D0, 0x2710
0DEE moveq.l D1, 0x01
0DF0 sub.w D1, D0
0DF2 move.w [A6 - 0x12], D1
0DF6 subq.w A7, 2
0DF8 move.w -[A7], 0x4
0DFC jsr [PC - 0xA7A /* 00000384 */]
0E00 move.w D0, [A7]+
0E02 subq.w D0, 1
0E04 muls.w D0, 0x2710
0E08 moveq.l D1, 0x01
0E0A sub.w D1, D0
0E0C move.w [A6 - 0x16], D1
0E10 subq.w A7, 2
0E12 move.l -[A7], [A5 - 0x2A2]
0E16 move.l -[A7], [A5 - 0x2B4]
0E1A syscall PtInRgn
0E1C move.b D0, [A7]+
0E1E subq.b D0, 1
0E20 beq +0x10 /* 00000E30 */
0E22 move.w -[A7], [A5 - 0x2A0]
0E26 move.w -[A7], [A5 - 0x2A2]
0E2A pea.l [A6 - 0x16]
0E2E syscall SetCPixel
label00000E30:
0E30 move.l -[A7], [A5 - 0x432]
0E34 move.l -[A7], [A5 - 0x42E]
0E38 move.l D0, 0x80006
0E3E syscall QDExtensions
0E40 subq.w A7, 2
0E42 move.l -[A7], [A5 - 0x2A2]
0E46 move.l -[A7], [A5 - 0x2B4]
0E4A syscall PtInRgn
0E4C move.b D0, [A7]+
0E4E subq.b D0, 1
0E50 beq +0x24 /* 00000E74 */
0E52 move.w -[A7], [A5 - 0x2A0]
0E56 move.w -[A7], [A5 - 0x2A2]
0E5A pea.l [A6 - 0x16]
0E5E syscall SetCPixel
0E60 bra +0x14 /* 00000E74 */
label00000E62:
0E62 subq.w D0, 1
0E64 beq -0x340 /* 00000B24 */
0E68 subq.w D0, 1
0E6A beq -0x286 /* 00000BE4 */
0E6E subq.w D0, 1
0E70 beq -0xE6 /* 00000D8A */
label00000E74:
0E74 subq.w A7, 4
0E76 syscall TickCount
0E78 move.l D0, [A7]+
0E7A cmp.l D0, [A5 - 0x22E]
0E7E ble +0x8E /* 00000F0C */
0E82 subq.w A7, 4
0E84 syscall TickCount
0E86 moveq.l D0, 0x14
0E88 add.l D0, [A7]+
0E8A move.l [A5 - 0x22E], D0
0E8E move.w D0, [A5 - 0x232]
0E92 addq.w D0, 1
0E94 move.w [A5 - 0x232], D0
0E98 cmpi.w [A5 - 0x232], 0x4
0E9E ble +0x8 /* 00000EA6 */
0EA0 move.w [A5 - 0x232], 0x1
label00000EA6:
0EA6 cmpi.w [A5 - 0x232], 0x4
0EAC bge +0x2E /* 00000EDA */
0EAE movea.l A0, [A5 - 0x452]
0EB2 pea.l [A0 + 0x2]
0EB6 movea.l A0, [A5 - 0x432]
0EBA pea.l [A0 + 0x2]
0EBE move.w D0, [A5 - 0x232]
0EC2 asl D0.w, 3
0EC4 addi.w D0, 0xFDCE
0EC8 pea.l [A5 + D0.w]
0ECC pea.l [A5 - 0x212]
0ED0 clr.w -[A7]
0ED2 move.l -[A7], [A5 - 0x2B4]
0ED6 syscall CopyBits
0ED8 bra +0x22 /* 00000EFA */
label00000EDA:
0EDA movea.l A0, [A5 - 0x452]
0EDE pea.l [A0 + 0x2]
0EE2 movea.l A0, [A5 - 0x432]
0EE6 pea.l [A0 + 0x2]
0EEA pea.l [A5 - 0x222]
0EEE pea.l [A5 - 0x212]
0EF2 clr.w -[A7]
0EF4 move.l -[A7], [A5 - 0x2B4]
0EF8 syscall CopyBits
label00000EFA:
0EFA tst.b [A5 - 0x2BE]
0EFE beq +0xE /* 00000F0C */
0F00 clr.b [A5 - 0x2BE]
0F04 move.w -[A7], 0x65 /* 'e' */
0F08 jsr [PC - 0xB38 /* 000003D2 */]
label00000F0C:
0F0C move.l D7, [A7]+
0F0E unlink A6
0F10 rts
export_6:
0F12 link A6, -0x0060
0F16 move.l -[A7], D7
0F18 move.l -[A7], [A6 + 0xA]
0F1C move.w -[A7], 0x1
0F20 pea.l [A6 - 0x12]
0F24 pea.l [A6 - 0x1E]
0F28 pea.l [A6 - 0x1A]
0F2C syscall GetDialogItem/GetDItem
0F2E pea.l [A6 - 0x4A]
0F32 syscall GetPort
0F34 movea.l A0, [A6 - 0x1E]
0F38 movea.l A0, [A0]
0F3A move.l -[A7], [A0 + 0x4]
0F3E syscall SetPort
0F40 pea.l [A6 - 0x30]
0F44 syscall GetPenState
0F46 syscall PenNormal
0F48 pea.l [A6 - 0x1A]
0F4C move.w -[A7], 0xFFFC
0F50 move.w -[A7], 0xFFFC
0F54 syscall InsetRect
0F56 pea.l [A6 - 0x1A]
0F5A move.w -[A7], 0x10
0F5E move.w -[A7], 0x10
0F62 syscall FrameRoundRect
0F64 move.w D7, [A6 - 0x16]
0F68 sub.w D7, [A6 - 0x1A]
0F6C ext.l D7
0F6E divs.w D7, 0x2
0F72 addq.w D7, 2
0F74 pea.l [A5 - 0x46]
0F78 syscall PenPat
0F7A move.w -[A7], 0x3
0F7E move.w -[A7], 0x3
0F82 syscall PenSize
0F84 pea.l [A6 - 0x1A]
0F88 move.w -[A7], D7
0F8A move.w -[A7], D7
0F8C syscall FrameRoundRect
0F8E pea.l [A6 - 0x30]
0F92 syscall SetPenState
0F94 move.l -[A7], [A6 - 0x4A]
0F98 syscall SetPort
0F9A move.l D7, [A7]+
0F9C unlink A6
0F9E movea.l A0, [A7]+
0FA0 addq.w A7, 6
0FA2 jmp [A0]
fn00000FA4:
0FA4 link A6, -0x0238
0FA8 movem.l -[A7], D6,D7,A4
0FAC jsr [PC - 0xBF6 /* 000003B8 */]
0FB0 subq.w A7, 4
0FB2 move.w -[A7], 0x82
0FB6 clr.l -[A7]
0FB8 moveq.l D0, 0xFFFFFFFF
0FBA move.l -[A7], D0
0FBC syscall GetNewDialog
0FBE movea.l A4, [A7]+
0FC0 move.l -[A7], A4
0FC2 move.w -[A7], 0x6
0FC6 pea.l [A6 - 0x16]
0FCA pea.l [A6 - 0x1A]
0FCE pea.l [A6 - 0x22]
0FD2 syscall GetDialogItem/GetDItem
0FD4 move.l -[A7], A4
0FD6 move.w -[A7], 0x6
0FDA move.w -[A7], [A6 - 0x16]
0FDE pea.l [A5 + 0x52 /* export_6, CODE:1 @ 00000F12 */]
0FE2 pea.l [A6 - 0x22]
0FE6 syscall SetDialogItem/SetDItem
0FE8 clr.w [A6 - 0x24]
0FEC bra +0xA /* 00000FF6 */
label00000FEE:
0FEE clr.l -[A7]
0FF0 pea.l [A6 - 0x24]
0FF4 syscall ModalDialog
label00000FF6:
0FF6 cmpi.w [A6 - 0x24], 0x2
0FFC sne D0
0FFE cmpi.w [A6 - 0x24], 0x1
1004 sne D1
1006 and.b D0, D1
1008 bne -0x1A /* 00000FEE */
100A cmpi.w [A6 - 0x24], 0x2
1010 bne +0xE /* 0000101E */
1012 clr.w [A6 + 0x8]
1016 move.l -[A7], A4
1018 syscall DisposeDialog
101A bra +0x100 /* 0000111A */
label0000101E:
101E move.l -[A7], A4
1020 move.w -[A7], 0x3
1024 pea.l [A6 - 0x16]
1028 pea.l [A6 - 0x1A]
102C pea.l [A6 - 0x22]
1030 syscall GetDialogItem/GetDItem
1032 move.l -[A7], [A6 - 0x1A]
1036 pea.l [A6 - 0x124]
103A syscall GetDialogItemText/GetIText
103C pea.l [A6 - 0x238]
1040 pea.l [A6 - 0x124]
1044 jsr [PC + 0xDC /* 00001122 */]
1048 addq.w A7, 4
104A move.w -[A7], 0xFF
104E pea.l [A6 - 0x238]
1052 pea.l [A6 - 0x124]
1056 jsr [PC - 0xE32 /* 00000226 */]
105A tst.b [A6 - 0x124]
105E bne +0xE /* 0000106C */
1060 clr.w [A6 + 0x8]
1064 move.l -[A7], A4
1066 syscall DisposeDialog
1068 bra +0xB2 /* 0000111A */
label0000106C:
106C move.l -[A7], A4
106E syscall DisposeDialog
1070 clr.w D6
1072 moveq.l D7, 0x01
label00001074:
1074 movea.l A0, [A5 - 0x2B8]
1078 move.w D0, D7
107A asl D0.w, 8
107C pea.l [A6 - 0x124]
1080 addi.w D0, 0xFF00
1084 pea.l [A0 + D0.w]
1088 jsr [PC - 0xF26 /* 00000164 */]
108C bne +0x4 /* 00001090 */
108E move.w D6, D7
label00001090:
1090 addq.w D7, 1
1092 cmpi.w D7, 0x32 /* '2' */
1096 ble -0x22 /* 00001074 */
1098 tst.w D6
109A bne +0x7C /* 00001116 */
109E subq.w A7, 4
10A0 move.w -[A7], 0x83
10A4 clr.l -[A7]
10A6 moveq.l D0, 0xFFFFFFFF
10A8 move.l -[A7], D0
10AA syscall GetNewDialog
10AC movea.l A4, [A7]+
10AE move.l -[A7], A4
10B0 syscall DrawDialog
10B2 move.w -[A7], 0x69 /* 'i' */
10B6 jsr [PC - 0xCE6 /* 000003D2 */]
10BA pea.l [A6 - 0x138]
10BE syscall GetKeys
10C0 bra +0x12 /* 000010D2 */
label000010C2:
10C2 pea.l [A6 - 0x138]
10C6 syscall GetKeys
10C8 move.w -[A7], 0xFFFF
10CC clr.w -[A7]
10CE move.l D0, [A7]+
10D0 syscall FlushEvents
label000010D2:
10D2 subq.w A7, 2
10D4 syscall Button
10D6 move.b D0, [A7]+
10D8 subq.b D0, 1
10DA moveq.l D1, 0x31
10DC move.w D2, D1
10DE lsr D2.w, 3
10E0 addi.w D2, 0xFEC8
10E4 btst [A6 + D2.w], D1
10E8 seq D1
10EA and.b D0, D1
10EC moveq.l D1, 0x0C
10EE move.w D2, D1
10F0 lsr D2.w, 3
10F2 addi.w D2, 0xFEC8
10F6 btst [A6 + D2.w], D1
10FA seq D1
10FC and.b D0, D1
10FE moveq.l D1, 0x24
1100 move.w D2, D1
1102 lsr D2.w, 3
1104 addi.w D2, 0xFEC8
1108 btst [A6 + D2.w], D1
110C seq D1
110E and.b D0, D1
1110 bne -0x4E /* 000010C2 */
1112 move.l -[A7], A4
1114 syscall DisposeDialog
label00001116:
1116 move.w [A6 + 0x8], D6
label0000111A:
111A movem.l D6,D7,A4, [A7]+
111E unlink A6
1120 rts
fn00001122:
1122 link A6, -0x0114
1126 move.l -[A7], D7
1128 movea.l A0, [A6 + 0x8]
112C lea.l A1, [A6 - 0x110]
1130 moveq.l D0, 0x3F
label00001132:
1132 move.l [A1]+, [A0]+
1134 dbf D0, -0x6 /* 00001132 */
1138 moveq.l D0, 0x00
113A move.b D0, [A6 - 0x110]
113E move.w [A6 - 0x114], D0
1142 moveq.l D7, 0x01
1144 bra +0x1E /* 00001162 */
label00001146:
1146 moveq.l D0, 0x00
1148 lea.l A0, [A6 - 0x110]
114C move.b D0, [A0 + D7.w]
1150 move.w D1, 0x9B
1154 sub.w D1, D0
1156 lea.l A0, [A6 - 0x110]
115A move.b [A0 + D7.w], D1
115E addq.w D7, 1
1160 bvs +0x8 /* 00001168 */
label00001162:
1162 cmp.w D7, [A6 - 0x114]
1166 ble -0x20 /* 00001146 */
label00001168:
1168 movea.l A0, [A6 + 0xC]
116C move.w -[A7], 0xFF
1170 pea.l [A6 - 0x110]
1174 move.l -[A7], A0
1176 jsr [PC - 0xF52 /* 00000226 */]
117A move.l D7, [A7]+
117C unlink A6
117E move.l [A7], [A7]+
1180 rts
fn00001182:
1182 link A6, -0x0024
1186 move.l -[A7], A4
1188 jsr [PC - 0xDD2 /* 000003B8 */]
118C subq.w A7, 4
118E move.w -[A7], 0x81
1192 clr.l -[A7]
1194 moveq.l D0, 0xFFFFFFFF
1196 move.l -[A7], D0
1198 syscall GetNewDialog
119A movea.l A4, [A7]+
119C move.l -[A7], A4
119E move.w -[A7], 0x5
11A2 pea.l [A6 - 0x16]
11A6 pea.l [A6 - 0x1A]
11AA pea.l [A6 - 0x22]
11AE syscall GetDialogItem/GetDItem
11B0 move.l -[A7], A4
11B2 move.w -[A7], 0x5
11B6 move.w -[A7], [A6 - 0x16]
11BA pea.l [A5 + 0x52 /* export_6, CODE:1 @ 00000F12 */]
11BE pea.l [A6 - 0x22]
11C2 syscall SetDialogItem/SetDItem
11C4 clr.w [A6 - 0x24]
11C8 bra +0xA /* 000011D2 */
label000011CA:
11CA clr.l -[A7]
11CC pea.l [A6 - 0x24]
11D0 syscall ModalDialog
label000011D2:
11D2 cmpi.w [A6 - 0x24], 0x2
11D8 sne D0
11DA cmpi.w [A6 - 0x24], 0x1
11E0 sne D1
11E2 and.b D0, D1
11E4 bne -0x1A /* 000011CA */
11E6 move.l -[A7], A4
11E8 syscall DisposeDialog
11EA cmpi.w [A6 - 0x24], 0x1
11F0 seq D0
11F2 neg.b D0
11F4 move.b [A6 + 0x8], D0
11F8 movea.l A4, [A7]+
11FA unlink A6
11FC rts
fn000011FE:
11FE pea.l [A5 - 0x2BC]
1202 move.l -[A7], 0x3200 /* '2\0' */
1208 jsr [PC - 0x10CE /* 0000013C */]
120C movea.l A0, [A5 - 0x2BC]
1210 move.l [A0], 0x34F6E65
1216 movea.l A0, [A5 - 0x2BC]
121A move.l [A0 + 0x100], 0x354776F
1222 movea.l A0, [A5 - 0x2BC]
1226 lea.l A1, [PC + 0x9EC /* 00001C14, value 0x5546872, pstring "Three" */]
122A lea.l A0, [A0 + 0x200]
122E move.l [A0]+, [A1]+
1230 move.l [A0]+, [A1]+
1232 movea.l A0, [A5 - 0x2BC]
1236 lea.l A1, [PC + 0x9D6 /* 00001C0E, value 0x4466F75, pstring "Four" */]
123A lea.l A0, [A0 + 0x300]
123E move.l [A0]+, [A1]+
1240 move.l [A0]+, [A1]+
1242 movea.l A0, [A5 - 0x2BC]
1246 lea.l A1, [PC + 0x9C0 /* 00001C08, value 0x4466976, pstring "Five" */]
124A lea.l A0, [A0 + 0x400]
124E move.l [A0]+, [A1]+
1250 move.l [A0]+, [A1]+
1252 movea.l A0, [A5 - 0x2BC]
1256 move.l [A0 + 0x500], 0x3536978
125E movea.l A0, [A5 - 0x2BC]
1262 lea.l A1, [PC + 0x99E /* 00001C02, value 0x5536576, pstring "Seven" */]
1266 lea.l A0, [A0 + 0x600]
126A move.l [A0]+, [A1]+
126C move.l [A0]+, [A1]+
126E movea.l A0, [A5 - 0x2BC]
1272 lea.l A1, [PC + 0x988 /* 00001BFC, value 0x5456967, pstring "Eight" */]
1276 lea.l A0, [A0 + 0x700]
127A move.l [A0]+, [A1]+
127C move.l [A0]+, [A1]+
127E movea.l A0, [A5 - 0x2BC]
1282 lea.l A1, [PC + 0x972 /* 00001BF6, value 0x44E696E, pstring "Nine" */]
1286 lea.l A0, [A0 + 0x800]
128A move.l [A0]+, [A1]+
128C move.l [A0]+, [A1]+
128E movea.l A0, [A5 - 0x2BC]
1292 move.l [A0 + 0x900], 0x354656E
129A movea.l A0, [A5 - 0x2BC]
129E lea.l A1, [PC + 0x94E /* 00001BEE, value 0x6456C65, pstring "Eleven" */]
12A2 lea.l A0, [A0 + 0xA00]
12A6 move.l [A0]+, [A1]+
12A8 move.l [A0]+, [A1]+
12AA movea.l A0, [A5 - 0x2BC]
12AE lea.l A1, [PC + 0x936 /* 00001BE6, value 0x6547765, pstring "Twelve" */]
12B2 lea.l A0, [A0 + 0xB00]
12B6 move.l [A0]+, [A1]+
12B8 move.l [A0]+, [A1]+
12BA movea.l A0, [A5 - 0x2BC]
12BE lea.l A1, [PC + 0x91C /* 00001BDC, value 0x8546869, pstring "Thirteen" */]
12C2 lea.l A0, [A0 + 0xC00]
12C6 move.l [A0]+, [A1]+
12C8 move.l [A0]+, [A1]+
12CA move.l [A0]+, [A1]+
12CC movea.l A0, [A5 - 0x2BC]
12D0 lea.l A1, [PC + 0x900 /* 00001BD2, value 0x8466F75, pstring "Fourteen" */]
12D4 lea.l A0, [A0 + 0xD00]
12D8 move.l [A0]+, [A1]+
12DA move.l [A0]+, [A1]+
12DC move.l [A0]+, [A1]+
12DE movea.l A0, [A5 - 0x2BC]
12E2 lea.l A1, [PC + 0x8E6 /* 00001BCA, value 0x7466966, pstring "Fifteen" */]
12E6 lea.l A0, [A0 + 0xE00]
12EA move.l [A0]+, [A1]+
12EC move.l [A0]+, [A1]+
12EE movea.l A0, [A5 - 0x2BC]
12F2 lea.l A1, [PC + 0x8CE /* 00001BC2, value 0x7536978, pstring "Sixteen" */]
12F6 lea.l A0, [A0 + 0xF00]
12FA move.l [A0]+, [A1]+
12FC move.l [A0]+, [A1]+
12FE movea.l A0, [A5 - 0x2BC]
1302 lea.l A1, [PC + 0x8B4 /* 00001BB8, value 0x9536576 '\tSev', pstring "Seventeen" */]
1306 lea.l A0, [A0 + 0x1000]
130A move.l [A0]+, [A1]+
130C move.l [A0]+, [A1]+
130E move.l [A0]+, [A1]+
1310 movea.l A0, [A5 - 0x2BC]
1314 lea.l A1, [PC + 0x898 /* 00001BAE, value 0x8456967, pstring "Eighteen" */]
1318 lea.l A0, [A0 + 0x1100]
131C move.l [A0]+, [A1]+
131E move.l [A0]+, [A1]+
1320 move.l [A0]+, [A1]+
1322 movea.l A0, [A5 - 0x2BC]
1326 lea.l A1, [PC + 0x87C /* 00001BA4, value 0x84E696E, pstring "Nineteen" */]
132A lea.l A0, [A0 + 0x1200]
132E move.l [A0]+, [A1]+
1330 move.l [A0]+, [A1]+
1332 move.l [A0]+, [A1]+
1334 movea.l A0, [A5 - 0x2BC]
1338 lea.l A1, [PC + 0x862 /* 00001B9C, value 0x6547765, pstring "Twenty" */]
133C lea.l A0, [A0 + 0x1300]
1340 move.l [A0]+, [A1]+
1342 move.l [A0]+, [A1]+
1344 movea.l A0, [A5 - 0x2BC]
1348 lea.l A1, [PC + 0x846 /* 00001B90, value 0xA547765 '\nTwe', pstring "Twenty-One" */]
134C lea.l A0, [A0 + 0x1400]
1350 move.l [A0]+, [A1]+
1352 move.l [A0]+, [A1]+
1354 move.l [A0]+, [A1]+
1356 movea.l A0, [A5 - 0x2BC]
135A lea.l A1, [PC + 0x828 /* 00001B84, value 0xA547765 '\nTwe', pstring "Twenty-Two" */]
135E lea.l A0, [A0 + 0x1500]
1362 move.l [A0]+, [A1]+
1364 move.l [A0]+, [A1]+
1366 move.l [A0]+, [A1]+
1368 movea.l A0, [A5 - 0x2BC]
136C lea.l A1, [PC + 0x808 /* 00001B76, value 0xC547765, pstring "Twenty-Three" */]
1370 lea.l A0, [A0 + 0x1600]
1374 move.l [A0]+, [A1]+
1376 move.l [A0]+, [A1]+
1378 move.l [A0]+, [A1]+
137A move.l [A0]+, [A1]+
137C movea.l A0, [A5 - 0x2BC]
1380 lea.l A1, [PC + 0x7E8 /* 00001B6A, value 0xB547765, pstring "Twenty-Four" */]
1384 lea.l A0, [A0 + 0x1700]
1388 move.l [A0]+, [A1]+
138A move.l [A0]+, [A1]+
138C move.l [A0]+, [A1]+
138E movea.l A0, [A5 - 0x2BC]
1392 lea.l A1, [PC + 0x7CA /* 00001B5E, value 0xB547765, pstring "Twenty-Five" */]
1396 lea.l A0, [A0 + 0x1800]
139A move.l [A0]+, [A1]+
139C move.l [A0]+, [A1]+
139E move.l [A0]+, [A1]+
13A0 movea.l A0, [A5 - 0x2BC]
13A4 lea.l A1, [PC + 0x7AC /* 00001B52, value 0xA547765 '\nTwe', pstring "Twenty-Six" */]
13A8 lea.l A0, [A0 + 0x1900]
13AC move.l [A0]+, [A1]+
13AE move.l [A0]+, [A1]+
13B0 move.l [A0]+, [A1]+
13B2 movea.l A0, [A5 - 0x2BC]
13B6 lea.l A1, [PC + 0x78C /* 00001B44, value 0xC547765, pstring "Twenty-Seven" */]
13BA lea.l A0, [A0 + 0x1A00]
13BE move.l [A0]+, [A1]+
13C0 move.l [A0]+, [A1]+
13C2 move.l [A0]+, [A1]+
13C4 move.l [A0]+, [A1]+
13C6 movea.l A0, [A5 - 0x2BC]
13CA lea.l A1, [PC + 0x76A /* 00001B36, value 0xC547765, pstring "Twenty-Eight" */]
13CE lea.l A0, [A0 + 0x1B00]
13D2 move.l [A0]+, [A1]+
13D4 move.l [A0]+, [A1]+
13D6 move.l [A0]+, [A1]+
13D8 move.l [A0]+, [A1]+
13DA movea.l A0, [A5 - 0x2BC]
13DE lea.l A1, [PC + 0x74A /* 00001B2A, value 0xB547765, pstring "Twenty-Nine" */]
13E2 lea.l A0, [A0 + 0x1C00]
13E6 move.l [A0]+, [A1]+
13E8 move.l [A0]+, [A1]+
13EA move.l [A0]+, [A1]+
13EC movea.l A0, [A5 - 0x2BC]
13F0 lea.l A1, [PC + 0x730 /* 00001B22, value 0x6546869, pstring "Thirty" */]
13F4 lea.l A0, [A0 + 0x1D00]
13F8 move.l [A0]+, [A1]+
13FA move.l [A0]+, [A1]+
13FC movea.l A0, [A5 - 0x2BC]
1400 lea.l A1, [PC + 0x714 /* 00001B16, value 0xA546869 '\nThi', pstring "Thirty-One" */]
1404 lea.l A0, [A0 + 0x1E00]
1408 move.l [A0]+, [A1]+
140A move.l [A0]+, [A1]+
140C move.l [A0]+, [A1]+
140E movea.l A0, [A5 - 0x2BC]
1412 lea.l A1, [PC + 0x6F6 /* 00001B0A, value 0xA546869 '\nThi', pstring "Thirty-Two" */]
1416 lea.l A0, [A0 + 0x1F00]
141A move.l [A0]+, [A1]+
141C move.l [A0]+, [A1]+
141E move.l [A0]+, [A1]+
1420 movea.l A0, [A5 - 0x2BC]
1424 lea.l A1, [PC + 0x6D6 /* 00001AFC, value 0xC546869, pstring "Thirty-Three" */]
1428 lea.l A0, [A0 + 0x2000]
142C move.l [A0]+, [A1]+
142E move.l [A0]+, [A1]+
1430 move.l [A0]+, [A1]+
1432 move.l [A0]+, [A1]+
1434 movea.l A0, [A5 - 0x2BC]
1438 lea.l A1, [PC + 0x6B6 /* 00001AF0, value 0xB546869, pstring "Thirty-Four" */]
143C lea.l A0, [A0 + 0x2100]
1440 move.l [A0]+, [A1]+
1442 move.l [A0]+, [A1]+
1444 move.l [A0]+, [A1]+
1446 movea.l A0, [A5 - 0x2BC]
144A lea.l A1, [PC + 0x698 /* 00001AE4, value 0xB546869, pstring "Thirty-Five" */]
144E lea.l A0, [A0 + 0x2200]
1452 move.l [A0]+, [A1]+
1454 move.l [A0]+, [A1]+
1456 move.l [A0]+, [A1]+
1458 movea.l A0, [A5 - 0x2BC]
145C lea.l A1, [PC + 0x67A /* 00001AD8, value 0xA546869 '\nThi', pstring "Thirty-Six" */]
1460 lea.l A0, [A0 + 0x2300]
1464 move.l [A0]+, [A1]+
1466 move.l [A0]+, [A1]+
1468 move.l [A0]+, [A1]+
146A movea.l A0, [A5 - 0x2BC]
146E lea.l A1, [PC + 0x65A /* 00001ACA, value 0xC546869, pstring "Thirty-Seven" */]
1472 lea.l A0, [A0 + 0x2400]
1476 move.l [A0]+, [A1]+
1478 move.l [A0]+, [A1]+
147A move.l [A0]+, [A1]+
147C move.l [A0]+, [A1]+
147E movea.l A0, [A5 - 0x2BC]
1482 lea.l A1, [PC + 0x638 /* 00001ABC, value 0xC546869, pstring "Thirty-Eight" */]
1486 lea.l A0, [A0 + 0x2500]
148A move.l [A0]+, [A1]+
148C move.l [A0]+, [A1]+
148E move.l [A0]+, [A1]+
1490 move.l [A0]+, [A1]+
1492 movea.l A0, [A5 - 0x2BC]
1496 lea.l A1, [PC + 0x618 /* 00001AB0, value 0xB546869, pstring "Thirty-Nine" */]
149A lea.l A0, [A0 + 0x2600]
149E move.l [A0]+, [A1]+
14A0 move.l [A0]+, [A1]+
14A2 move.l [A0]+, [A1]+
14A4 movea.l A0, [A5 - 0x2BC]
14A8 lea.l A1, [PC + 0x600 /* 00001AAA, value 0x5466F72, pstring "Forty" */]
14AC lea.l A0, [A0 + 0x2700]
14B0 move.l [A0]+, [A1]+
14B2 move.l [A0]+, [A1]+
14B4 movea.l A0, [A5 - 0x2BC]
14B8 lea.l A1, [PC + 0x5E6 /* 00001AA0, value 0x9466F72 '\tFor', pstring "Forty-One" */]
14BC lea.l A0, [A0 + 0x2800]
14C0 move.l [A0]+, [A1]+
14C2 move.l [A0]+, [A1]+
14C4 move.l [A0]+, [A1]+
14C6 movea.l A0, [A5 - 0x2BC]
14CA lea.l A1, [PC + 0x5CA /* 00001A96, value 0x9466F72 '\tFor', pstring "Forty-Two" */]
14CE lea.l A0, [A0 + 0x2900]
14D2 move.l [A0]+, [A1]+
14D4 move.l [A0]+, [A1]+
14D6 move.l [A0]+, [A1]+
14D8 movea.l A0, [A5 - 0x2BC]
14DC lea.l A1, [PC + 0x5AC /* 00001A8A, value 0xB466F72, pstring "Forty-Three" */]
14E0 lea.l A0, [A0 + 0x2A00]
14E4 move.l [A0]+, [A1]+
14E6 move.l [A0]+, [A1]+
14E8 move.l [A0]+, [A1]+
14EA movea.l A0, [A5 - 0x2BC]
14EE lea.l A1, [PC + 0x58E /* 00001A7E, value 0xA466F72 '\nFor', pstring "Forty-Four" */]
14F2 lea.l A0, [A0 + 0x2B00]
14F6 move.l [A0]+, [A1]+
14F8 move.l [A0]+, [A1]+
14FA move.l [A0]+, [A1]+
14FC movea.l A0, [A5 - 0x2BC]
1500 lea.l A1, [PC + 0x570 /* 00001A72, value 0xA466F72 '\nFor', pstring "Forty-Five" */]
1504 lea.l A0, [A0 + 0x2C00]
1508 move.l [A0]+, [A1]+
150A move.l [A0]+, [A1]+
150C move.l [A0]+, [A1]+
150E movea.l A0, [A5 - 0x2BC]
1512 lea.l A1, [PC + 0x554 /* 00001A68, value 0x9466F72 '\tFor', pstring "Forty-Six" */]
1516 lea.l A0, [A0 + 0x2D00]
151A move.l [A0]+, [A1]+
151C move.l [A0]+, [A1]+
151E move.l [A0]+, [A1]+
1520 movea.l A0, [A5 - 0x2BC]
1524 lea.l A1, [PC + 0x536 /* 00001A5C, value 0xB466F72, pstring "Forty-Seven" */]
1528 lea.l A0, [A0 + 0x2E00]
152C move.l [A0]+, [A1]+
152E move.l [A0]+, [A1]+
1530 move.l [A0]+, [A1]+
1532 movea.l A0, [A5 - 0x2BC]
1536 lea.l A1, [PC + 0x518 /* 00001A50, value 0xB466F72, pstring "Forty-Eight" */]
153A lea.l A0, [A0 + 0x2F00]
153E move.l [A0]+, [A1]+
1540 move.l [A0]+, [A1]+
1542 move.l [A0]+, [A1]+
1544 movea.l A0, [A5 - 0x2BC]
1548 lea.l A1, [PC + 0x4FA /* 00001A44, value 0xA466F72 '\nFor', pstring "Forty-Nine" */]
154C lea.l A0, [A0 + 0x3000]
1550 move.l [A0]+, [A1]+
1552 move.l [A0]+, [A1]+
1554 move.l [A0]+, [A1]+
1556 movea.l A0, [A5 - 0x2BC]
155A lea.l A1, [PC + 0x4E2 /* 00001A3E, value 0x5466966, pstring "Fifty" */]
155E lea.l A0, [A0 + 0x3100]
1562 move.l [A0]+, [A1]+
1564 move.l [A0]+, [A1]+
1566 pea.l [A5 - 0x2B8]
156A move.l -[A7], 0x3200 /* '2\0' */
1570 jsr [PC - 0x1436 /* 0000013C */]
1574 movea.l A0, [A5 - 0x2B8]
1578 lea.l A1, [PC + 0x4BE /* 00001A38, value 0x556534F, pstring "VSOMV" */]
157C move.l [A0]+, [A1]+
157E move.l [A0]+, [A1]+
1580 movea.l A0, [A5 - 0x2B8]
1584 lea.l A1, [PC + 0x4A8 /* 00001A2E, value 0x958564D '\tXVM', pstring "XVMVMXRLM" */]
1588 lea.l A0, [A0 + 0x100]
158C move.l [A0]+, [A1]+
158E move.l [A0]+, [A1]+
1590 move.l [A0]+, [A1]+
1592 movea.l A0, [A5 - 0x2B8]
1596 lea.l A1, [PC + 0x490 /* 00001A28, value 0x5565846, pstring "VXFRG" */]
159A lea.l A0, [A0 + 0x200]
159E move.l [A0]+, [A1]+
15A0 move.l [A0]+, [A1]+
15A2 movea.l A0, [A5 - 0x2B8]
15A6 lea.l A1, [PC + 0x47A /* 00001A22, value 0x5484C59, pstring "HLYVX" */]
15AA lea.l A0, [A0 + 0x300]
15AE move.l [A0]+, [A1]+
15B0 move.l [A0]+, [A1]+
15B2 movea.l A0, [A5 - 0x2B8]
15B6 lea.l A1, [PC + 0x462 /* 00001A1A, value 0x647524D, pstring "GRMGVP" */]
15BA lea.l A0, [A0 + 0x400]
15BE move.l [A0]+, [A1]+
15C0 move.l [A0]+, [A1]+
15C2 movea.l A0, [A5 - 0x2B8]
15C6 lea.l A1, [PC + 0x448 /* 00001A10, value 0x8474C4E, pstring "GLNRIZFM" */]
15CA lea.l A0, [A0 + 0x500]
15CE move.l [A0]+, [A1]+
15D0 move.l [A0]+, [A1]+
15D2 move.l [A0]+, [A1]+
15D4 movea.l A0, [A5 - 0x2B8]
15D8 lea.l A1, [PC + 0x42C /* 00001A06, value 0x95A5647 '\tZVG', pstring "ZVGFURYFO" */]
15DC lea.l A0, [A0 + 0x600]
15E0 move.l [A0]+, [A1]+
15E2 move.l [A0]+, [A1]+
15E4 move.l [A0]+, [A1]+
15E6 movea.l A0, [A5 - 0x2B8]
15EA lea.l A1, [PC + 0x412 /* 000019FE, value 0x74B5A4F, pstring "KZOUBGI" */]
15EE lea.l A0, [A0 + 0x700]
15F2 move.l [A0]+, [A1]+
15F4 move.l [A0]+, [A1]+
15F6 movea.l A0, [A5 - 0x2B8]
15FA lea.l A1, [PC + 0x3F6 /* 000019F2, value 0xA455649 '\nEVI', pstring "EVIMVHOVXH" */]
15FE lea.l A0, [A0 + 0x800]
1602 move.l [A0]+, [A1]+
1604 move.l [A0]+, [A1]+
1606 move.l [A0]+, [A1]+
1608 movea.l A0, [A5 - 0x2B8]
160C lea.l A1, [PC + 0x3DE /* 000019EC, value 0x5585649, pstring "XVIRX" */]
1610 lea.l A0, [A0 + 0x900]
1614 move.l [A0]+, [A1]+
1616 move.l [A0]+, [A1]+
1618 movea.l A0, [A5 - 0x2B8]
161C lea.l A1, [PC + 0x3C8 /* 000019E6, value 0x454494C, pstring "TILR" */]
1620 lea.l A0, [A0 + 0xA00]
1624 move.l [A0]+, [A1]+
1626 move.l [A0]+, [A1]+
1628 movea.l A0, [A5 - 0x2B8]
162C lea.l A1, [PC + 0x3B2 /* 000019E0, value 0x5494C4D, pstring "ILMLR" */]
1630 lea.l A0, [A0 + 0xB00]
1634 move.l [A0]+, [A1]+
1636 move.l [A0]+, [A1]+
1638 movea.l A0, [A5 - 0x2B8]
163C lea.l A1, [PC + 0x39C /* 000019DA, value 0x5464F52, pstring "FORNR" */]
1640 lea.l A0, [A0 + 0xC00]
1644 move.l [A0]+, [A1]+
1646 move.l [A0]+, [A1]+
1648 movea.l A0, [A5 - 0x2B8]
164C lea.l A1, [PC + 0x384 /* 000019D2, value 0x7495647, pstring "IVGZRNZ" */]
1650 lea.l A0, [A0 + 0xD00]
1654 move.l [A0]+, [A1]+
1656 move.l [A0]+, [A1]+
1658 movea.l A0, [A5 - 0x2B8]
165C lea.l A1, [PC + 0x36E /* 000019CC, value 0x4425247, pstring "BRGS" */]
1660 lea.l A0, [A0 + 0xE00]
1664 move.l [A0]+, [A1]+
1666 move.l [A0]+, [A1]+
1668 movea.l A0, [A5 - 0x2B8]
166C lea.l A1, [PC + 0x358 /* 000019C6, value 0x4485252, pstring "HRRH" */]
1670 lea.l A0, [A0 + 0xF00]
1674 move.l [A0]+, [A1]+
1676 move.l [A0]+, [A1]+
1678 movea.l A0, [A5 - 0x2B8]
167C lea.l A1, [PC + 0x342 /* 000019C0, value 0x45A5254, pstring "ZRTZ" */]
1680 lea.l A0, [A0 + 0x1000]
1684 move.l [A0]+, [A1]+
1686 move.l [A0]+, [A1]+
1688 movea.l A0, [A5 - 0x2B8]
168C lea.l A1, [PC + 0x32C /* 000019BA, value 0x559564F, pstring "YVOZY" */]
1690 lea.l A0, [A0 + 0x1100]
1694 move.l [A0]+, [A1]+
1696 move.l [A0]+, [A1]+
1698 movea.l A0, [A5 - 0x2B8]
169C lea.l A1, [PC + 0x314 /* 000019B2, value 0x658564F, pstring "XVOWIZ" */]
16A0 lea.l A0, [A0 + 0x1200]
16A4 move.l [A0]+, [A1]+
16A6 move.l [A0]+, [A1]+
16A8 movea.l A0, [A5 - 0x2B8]
16AC lea.l A1, [PC + 0x2FC /* 000019AA, value 0x6455A4D, pstring "EZMFOX" */]
16B0 lea.l A0, [A0 + 0x1300]
16B4 move.l [A0]+, [A1]+
16B6 move.l [A0]+, [A1]+
16B8 movea.l A0, [A5 - 0x2B8]
16BC lea.l A1, [PC + 0x2E6 /* 000019A4, value 0x5485249, pstring "HRIVZ" */]
16C0 lea.l A0, [A0 + 0x1400]
16C4 move.l [A0]+, [A1]+
16C6 move.l [A0]+, [A1]+
16C8 movea.l A0, [A5 - 0x2B8]
16CC lea.l A1, [PC + 0x2CC /* 0000199A, value 0x84F464D, pstring "OFMGZGZH" */]
16D0 lea.l A0, [A0 + 0x1500]
16D4 move.l [A0]+, [A1]+
16D6 move.l [A0]+, [A1]+
16D8 move.l [A0]+, [A1]+
16DA movea.l A0, [A5 - 0x2B8]
16DE lea.l A1, [PC + 0x2B0 /* 00001990, value 0x84E564D, pstring "NVMWZTVB" */]
16E2 lea.l A0, [A0 + 0x1600]
16E6 move.l [A0]+, [A1]+
16E8 move.l [A0]+, [A1]+
16EA move.l [A0]+, [A1]+
16EC movea.l A0, [A5 - 0x2B8]
16F0 lea.l A1, [PC + 0x296 /* 00001988, value 0x7555649, pstring "UVIFORX" */]
16F4 lea.l A0, [A0 + 0x1700]
16F8 move.l [A0]+, [A1]+
16FA move.l [A0]+, [A1]+
16FC movea.l A0, [A5 - 0x2B8]
1700 lea.l A1, [PC + 0x27E /* 00001980, value 0x7495A46, pstring "IZFMGVX" */]
1704 lea.l A0, [A0 + 0x1800]
1708 move.l [A0]+, [A1]+
170A move.l [A0]+, [A1]+
170C movea.l A0, [A5 - 0x2B8]
1710 lea.l A1, [PC + 0x266 /* 00001978, value 0x74D5A49, pstring "MZIZVOV" */]
1714 lea.l A0, [A0 + 0x1900]
1718 move.l [A0]+, [A1]+
171A move.l [A0]+, [A1]+
171C movea.l A0, [A5 - 0x2B8]
1720 lea.l A1, [PC + 0x24E /* 00001970, value 0x6494648, pstring "IFHGFM" */]
1724 lea.l A0, [A0 + 0x1A00]
1728 move.l [A0]+, [A1]+
172A move.l [A0]+, [A1]+
172C movea.l A0, [A5 - 0x2B8]
1730 lea.l A1, [PC + 0x234 /* 00001966, value 0x8584C4E, pstring "XLNZOWVH" */]
1734 lea.l A0, [A0 + 0x1B00]
1738 move.l [A0]+, [A1]+
173A move.l [A0]+, [A1]+
173C move.l [A0]+, [A1]+
173E movea.l A0, [A5 - 0x2B8]
1742 lea.l A1, [PC + 0x218 /* 0000195C, value 0x8485A56, pstring "HZVWZOFW" */]
1746 lea.l A0, [A0 + 0x1C00]
174A move.l [A0]+, [A1]+
174C move.l [A0]+, [A1]+
174E move.l [A0]+, [A1]+
1750 movea.l A0, [A5 - 0x2B8]
1754 lea.l A1, [PC + 0x200 /* 00001956, value 0x4574C57, pstring "WLWR" */]
1758 lea.l A0, [A0 + 0x1D00]
175C move.l [A0]+, [A1]+
175E move.l [A0]+, [A1]+
1760 movea.l A0, [A5 - 0x2B8]
1764 lea.l A1, [PC + 0x1E8 /* 0000194E, value 0x650524D, pstring "PRMWFV" */]
1768 lea.l A0, [A0 + 0x1E00]
176C move.l [A0]+, [A1]+
176E move.l [A0]+, [A1]+
1770 movea.l A0, [A5 - 0x2B8]
1774 lea.l A1, [PC + 0x1D0 /* 00001946, value 0x7595A53, pstring "YZSNYFZ" */]
1778 lea.l A0, [A0 + 0x1F00]
177C move.l [A0]+, [A1]+
177E move.l [A0]+, [A1]+
1780 movea.l A0, [A5 - 0x2B8]
1784 lea.l A1, [PC + 0x1B6 /* 0000193C, value 0x84D4C49, pstring "MLISWBGV" */]
1788 lea.l A0, [A0 + 0x2000]
178C move.l [A0]+, [A1]+
178E move.l [A0]+, [A1]+
1790 move.l [A0]+, [A1]+
1792 movea.l A0, [A5 - 0x2B8]
1796 lea.l A1, [PC + 0x19A /* 00001932, value 0x9505A4F '\tPZO', pstring "PZOZERNZM" */]
179A lea.l A0, [A0 + 0x2100]
179E move.l [A0]+, [A1]+
17A0 move.l [A0]+, [A1]+
17A2 move.l [A0]+, [A1]+
17A4 movea.l A0, [A5 - 0x2B8]
17A8 lea.l A1, [PC + 0x180 /* 0000192A, value 0x6495A46, pstring "IZFWZH" */]
17AC lea.l A0, [A0 + 0x2200]
17B0 move.l [A0]+, [A1]+
17B2 move.l [A0]+, [A1]+
17B4 movea.l A0, [A5 - 0x2B8]
17B8 lea.l A1, [PC + 0x166 /* 00001920, value 0x9575A56 '\tWZV', pstring "WZVNLMWIZ" */]
17BC lea.l A0, [A0 + 0x2300]
17C0 move.l [A0]+, [A1]+
17C2 move.l [A0]+, [A1]+
17C4 move.l [A0]+, [A1]+
17C6 movea.l A0, [A5 - 0x2B8]
17CA lea.l A1, [PC + 0x14C /* 00001918, value 0x74E524D, pstring "NRMROVU" */]
17CE lea.l A0, [A0 + 0x2400]
17D2 move.l [A0]+, [A1]+
17D4 move.l [A0]+, [A1]+
17D6 movea.l A0, [A5 - 0x2B8]
17DA lea.l A1, [PC + 0x130 /* 0000190C, value 0xA595A4F '\nYZO', pstring "YZOAVYFIVY" */]
17DE lea.l A0, [A0 + 0x2500]
17E2 move.l [A0]+, [A1]+
17E4 move.l [A0]+, [A1]+
17E6 move.l [A0]+, [A1]+
17E8 movea.l A0, [A5 - 0x2B8]
17EC lea.l A1, [PC + 0x112 /* 00001900, value 0xA4E5A4F '\nNZO', pstring "NZORTLKZMB" */]
17F0 lea.l A0, [A0 + 0x2600]
17F4 move.l [A0]+, [A1]+
17F6 move.l [A0]+, [A1]+
17F8 move.l [A0]+, [A1]+
17FA movea.l A0, [A5 - 0x2B8]
17FE lea.l A1, [PC + 0xFA /* 000018FA, value 0x5575656, pstring "WVVNZ" */]
1802 lea.l A0, [A0 + 0x2700]
1806 move.l [A0]+, [A1]+
1808 move.l [A0]+, [A1]+
180A movea.l A0, [A5 - 0x2B8]
180E lea.l A1, [PC + 0xE0 /* 000018F0, value 0x94F5245 '\tORE', pstring "OREVIRTFH" */]
1812 lea.l A0, [A0 + 0x2800]
1816 move.l [A0]+, [A1]+
1818 move.l [A0]+, [A1]+
181A move.l [A0]+, [A1]+
181C movea.l A0, [A5 - 0x2B8]
1820 lea.l A1, [PC + 0xC6 /* 000018E8, value 0x6484C49, pstring "HLIRHR" */]
1824 lea.l A0, [A0 + 0x2900]
1828 move.l [A0]+, [A1]+
182A move.l [A0]+, [A1]+
182C movea.l A0, [A5 - 0x2B8]
1830 lea.l A1, [PC + 0xAE /* 000018E0, value 0x745524F, pstring "EROZMRZ" */]
1834 lea.l A0, [A0 + 0x2A00]
1838 move.l [A0]+, [A1]+
183A move.l [A0]+, [A1]+
183C movea.l A0, [A5 - 0x2B8]
1840 lea.l A1, [PC + 0x96 /* 000018D8, value 0x6524948, pstring "RIHFWR" */]
1844 lea.l A0, [A0 + 0x2B00]
1848 move.l [A0]+, [A1]+
184A move.l [A0]+, [A1]+
184C movea.l A0, [A5 - 0x2B8]
1850 lea.l A1, [PC + 0x7E /* 000018D0, value 0x7575A52, pstring "WZROVSO" */]
1854 lea.l A0, [A0 + 0x2C00]
1858 move.l [A0]+, [A1]+
185A move.l [A0]+, [A1]+
185C movea.l A0, [A5 - 0x2B8]
1860 lea.l A1, [PC + 0x66 /* 000018C8, value 0x6475253, pstring "GRSORO" */]
1864 lea.l A0, [A0 + 0x2D00]
1868 move.l [A0]+, [A1]+
186A move.l [A0]+, [A1]+
186C movea.l A0, [A5 - 0x2B8]
1870 lea.l A1, [PC + 0x50 /* 000018C2, value 0x548464E, pstring "HFNVI" */]
1874 lea.l A0, [A0 + 0x2E00]
1878 move.l [A0]+, [A1]+
187A move.l [A0]+, [A1]+
187C movea.l A0, [A5 - 0x2B8]
1880 lea.l A1, [PC + 0x38 /* 000018BA, value 0x74E464F, pstring "NFOFILH" */]
1884 lea.l A0, [A0 + 0x2F00]
1888 move.l [A0]+, [A1]+
188A move.l [A0]+, [A1]+
188C movea.l A0, [A5 - 0x2B8]
1890 lea.l A1, [PC + 0x1E /* 000018B0, value 0x9594952 '\tYIR', pstring "YIRMGLQFN" */]
1894 lea.l A0, [A0 + 0x3000]
1898 move.l [A0]+, [A1]+
189A move.l [A0]+, [A1]+
189C move.l [A0]+, [A1]+
189E movea.l A0, [A5 - 0x2B8]
18A2 clr.b [A0 + 0x3100]
18A6 subq.w A7, 4
18A8 syscall NewRgn
18AA move.l [A5 - 0x2AC], [A7]+
18AE rts
18B0 bchg [A1]+, D4
18B2 chk.w D4, [A2]
18B4 chk.w D6, D7
18B6 divul.l D6:D4, [A1]
18BA bchg A6, D3
18BC not.w A7
18BE not.w A1
18C0 divul.l D0:D0, A0
18C4 not.w A6
18C6 addq.w A1, 3
18C8 addi.w D7, 0x5253 /* 'RS' */
18CC chk.w D7, [A2]
18CE .invalid 7, A0 // invalid opcode 4 with b == 4
18D0 bchg [A7], D3
18D2 addq.w [A2], 5
18D4 chk.w D7, [A6]
18D6 subq.w A7, 1
18D8 addi.w [A2], 0x4948 /* 'IH' */
18DC not.w [A7]
18DE addq.b A0, 1
18E0 bchg D5, D3
18E2 addq.w A7, 1
18E4 addq.w A5, 5
18E6 addq.w [A2]+, 1
18E8 addi.w A0, 0x4C49 /* 'LI' */
18EC addq.w A0, 1
18EE addq.b A0, 1
18F0 bchg A7, D4
18F2 addq.w D5, 1
18F4 addq.w A1, 3
18F6 addq.w [A4], 1
18F8 not.w A0
18FA bchg [A7], D2
18FC addq.w [A6], 3
18FE unlink A2
1900 xori.w A6, 0x5A4F /* 'ZO' */
1904 addq.w [A4], 1
1906 divs.l D5:D5, A3
190A clr.b A0
190C xori.w [A1]+, 0x5A4F /* 'ZO' */
1910 chk.w D0, [A6]
1912 subq.w D6, 4
1914 chk.w D4, [A6]
1916 subq.b A0, 4
1918 bchg A6, D3
191A addq.w A5, 1
191C addq.w A7, 1
191E addq.w [A5], 3
1920 bchg [A7], D4
1922 addq.w [A6], 5
1924 trap 12
1926 chk.w D6, [A7]
1928 chk.w D4, [A2]+
192A addi.w A1, 0x5A46 /* 'ZF' */
192E subq.w [A2]+, 3
1930 nbcd.b A0
1932 bchg [A0], D4
1934 addq.w A7, 5
1936 addq.w D5, 5
1938 addq.w A6, 1
193A addq.w A5, 5
193C bchg.b A5, 0x49 /* 'I' */
1940 subq.w [A7], 1
1942 clr.w D7
1944 addq.b A0, 3
1946 bchg [A1]+, D3
1948 addq.w [A3], 5
194A unlink A1
194C not.w [A2]+
194E addi.w [A0], 0x524D /* 'RM' */
1952 subq.w D6, 3
1954 addq.b A0, 3
1956 subi.w [A7], 0x4C57 /* 'LW' */
195A addq.b A0, 1
195C bchg.b A0, 0x56 /* 'V' */
1960 subq.w [A2]+, 3
1962 chk.w D7, D6
1964 subq.b A0, 3
1966 bchg.b [A0]+, 0x4E /* 'N' */
196A addq.w A7, 5
196C subq.w [A6], 3
196E nbcd.b A0
1970 addi.w A1, 0x4648 /* 'FH' */
1974 chk.w D3, D6
1976 .invalid 6, A0 // invalid opcode 4 with b == 4
1978 bchg A5, D3
197A addq.w A1, 5
197C addq.w [A6], 5
197E chk.w D7, [A6]
1980 bchg A1, D3
1982 addq.w D6, 5
1984 chk.w D6, D7
1986 addq.w [A0]+, 3
1988 bchg [A5], D3
198A addq.w A1, 3
198C not.w A7
198E addq.w [A0]+, 1
1990 bchg.b A6, 0x4D /* 'M' */
1994 subq.w [A2]+, 3
1996 addq.w [A6], 2
1998 clr.b A0
199A bchg.b A7, 0x4D /* 'M' */
199E chk.w D3, [A2]+
19A0 chk.w D3, [A2]+
19A2 nbcd.b A0
19A4 bchg A0, D2
19A6 addq.w A1, 1
19A8 addq.w [A2]+, 3
19AA addi.w D5, 0x5A4D /* 'ZM' */
19AE not.w A7
19B0 addq.b A0, 4
19B2 addi.w [A0]+, 0x564F /* 'VO' */
19B6 subq.w A1, 3
19B8 addq.b A0, 5
19BA bchg [A1]+, D2
19BC addq.w A7, 3
19BE addq.w [A1]+, 5
19C0 subi.w [A2]+, 0x5254 /* 'RT' */
19C4 addq.b A0, 5
19C6 subi.w A0, 0x5252 /* 'RR' */
19CA nbcd.b A0
19CC subi.w D2, 0x5247 /* 'RG' */
19D0 subq.b A0, 1
19D2 bchg A1, D3
19D4 addq.w D7, 3
19D6 addq.w [A2], 5
19D8 unlink A2
19DA bchg D6, D2
19DC chk.w D7, [A2]
19DE link A2, 0x0549
19E2 divsl.l D2:D4, A5
19E6 subi.w [A4], 0x494C /* 'IL' */
19EA addq.b A0, 1
19EC bchg [A0]+, D2
19EE addq.w A1, 3
19F0 addq.w [A0]+, 1
19F2 xori.w D5, 0x5649 /* 'VI' */
19F6 chk.w D6, [A6]
19F8 pea.l A7
19FA addq.w [A0]+, 3
19FC nbcd.b A0
19FE bchg A3, D3
1A00 addq.w A7, 5
1A02 subq.w D2, 2
1A04 chk.w D3, A1
1A06 bchg [A2]+, D4
1A08 addq.w D7, 3
1A0A not.w [A5]
1A0C addq.w [A1]+, 1
1A0E not.w A7
1A10 bchg.b D7, 0x4E /* 'N' */
1A14 addq.w A1, 1
1A16 addq.w D6, 5
1A18 .invalid 6, A0 // invalid opcode 4 with b == 4
1A1A addi.w D7, 0x524D /* 'RM' */
1A1E chk.w D3, [A6]
1A20 addq.b A0, 8
1A22 bchg A0, D2
1A24 divul.l D0:D5, [A1]+
1A28 bchg [A6], D2
1A2A addq.w D6, 4
1A2C addq.w D7, 1
1A2E bchg [A0]+, D4
1A30 addq.w A5, 3
1A32 addq.w A5, 3
1A34 addq.w [A2], 4
1A36 divul.l D6:D0, A5
1A3A subq.w A7, 1
1A3C chk.w D6, [A6]
1A3E bchg D6, D2
1A40 bvs +0x68 /* 00001AA8 */
1A42 moveq.l D2, 0x79
1A44 xori.w D6, 0x6F72 /* 'or' */
1A48 moveq.l D2, 0x79
1A4A move.l [A6 + 0x696E], A6
1A4E bcs +0xA /* 00001A58 */
1A50 bchg D6, D5
1A52 ble +0x74 /* 00001AC6 */
1A54 moveq.l D2, 0x79
1A56 move.l [A6 + 0x6967], D5
// begin alternate branch 00001A58-00001A5A
label00001A58:
1A58 bvs +0x69 /* 00001AC1 */
// end alternate branch 00001A58-00001A5A
label00001A58: // (misaligned)
1A5A bvc +0x76 /* 00001AD0 */
1A5C bchg D6, D5
1A5E ble +0x74 /* 00001AD2 */
1A60 moveq.l D2, 0x79
1A62 move.l [A6 + 0x6576], [A3]
1A66 bcs +0x70 /* 00001AD6 */
1A68 bchg D6, D4
1A6A ble +0x74 /* 00001ADE */
1A6C moveq.l D2, 0x79
1A6E move.l [A6 + 0x6978], [A3]
1A72 xori.w D6, 0x6F72 /* 'or' */
1A76 moveq.l D2, 0x79
1A78 move.l [A6 + 0x6976], D6
1A7C bcs +0xA /* 00001A86 */
1A7E xori.w D6, 0x6F72 /* 'or' */
1A82 moveq.l D2, 0x79
1A84 move.l [A6 + 0x6F75], D6
// begin alternate branch 00001A86-00001A88
label00001A86:
1A86 ble +0x77 /* 00001AFD */
// end alternate branch 00001A86-00001A88
label00001A86: // (misaligned)
1A88 moveq.l D1, 0x08
1A8A bchg D6, D5
1A8C ble +0x74 /* 00001B00 */
1A8E moveq.l D2, 0x79
1A90 move.l [A6 + 0x6872], [A4]
1A94 bcs +0x67 /* 00001AFB */
1A96 bchg D6, D4
1A98 ble +0x74 /* 00001B0C */
1A9A moveq.l D2, 0x79
1A9C move.l [A6 + 0x776F], [A4]
1AA0 bchg D6, D4
1AA2 ble +0x74 /* 00001B16 */
1AA4 moveq.l D2, 0x79
1AA6 move.l [A6 + 0x6E65], A7
// begin alternate branch 00001AA8-00001AAA
label00001AA8:
1AA8 bgt +0x67 /* 00001B0F */
// end alternate branch 00001AA8-00001AAA
label00001AA8: // (misaligned)
1AAA bchg D6, D2
1AAC ble +0x74 /* 00001B20 */
1AAE moveq.l D2, 0x79
1AB0 bchg [A4], D5
1AB2 bvc +0x6B /* 00001B1D */
1AB4 moveq.l D1, 0x74
1AB6 moveq.l D4, 0x2D
1AB8 move A1, USP
1ABA bgt +0x67 /* 00001B21 */
1ABC cmpi.w [A4], 0x6869 /* 'hi' */
1AC0 moveq.l D1, 0x74
1AC2 moveq.l D4, 0x2D
1AC4 chk.w D2, [A1 + 0x6768]
// begin alternate branch 00001AC6-00001AC8
label00001AC6:
1AC6 beq +0x6A /* 00001B30 */
// end alternate branch 00001AC6-00001AC8
label00001AC6: // (misaligned)
1AC8 moveq.l D2, 0x08
1ACA cmpi.w [A4], 0x6869 /* 'hi' */
1ACE moveq.l D1, 0x74
label00001AD0:
1AD0 moveq.l D4, 0x2D
label00001AD2:
1AD2 subq.w -[A5], 1
1AD4 moveq.l D3, 0x65
label00001AD6:
1AD6 bgt +0xA /* 00001AE0 */
1AD8 xori.w [A4], 0x6869 /* 'hi' */
1ADC moveq.l D1, 0x74
label00001ADE:
1ADE moveq.l D4, 0x2D
label00001AE0:
1AE0 subq.w [A1 + 0x7808], 1
1AE4 bchg [A4], D5
1AE6 bvc +0x6B /* 00001B51 */
1AE8 moveq.l D1, 0x74
1AEA moveq.l D4, 0x2D
1AEC not.w [A1 + 0x7665]
1AF0 bchg [A4], D5
1AF2 bvc +0x6B /* 00001B5D */
1AF4 moveq.l D1, 0x74
1AF6 moveq.l D4, 0x2D
1AF8 not.w [A7 + 0x7572]
1AFC cmpi.w [A4], 0x6869 /* 'hi' */
label00001B00:
1B00 moveq.l D1, 0x74
1B02 moveq.l D4, 0x2D
1B04 addq.w [A0 + 0x7265], 2
1B08 bcs +0xA /* 00001B12 */
1B0A xori.w [A4], 0x6869 /* 'hi' */
// begin alternate branch 00001B0C-00001B0E
label00001B0C:
1B0C bvc +0x6B /* 00001B77 */
// end alternate branch 00001B0C-00001B0E
label00001B0C: // (misaligned)
1B0E moveq.l D1, 0x74
1B10 moveq.l D4, 0x2D
label00001B12:
1B12 addq.w [A7 + <<invalid base displacement size>> + D6 * 8], 2
label00001B16:
1B16 xori.w [A4], 0x6869 /* 'hi' */
1B1A moveq.l D1, 0x74
1B1C moveq.l D4, 0x2D
1B1E chk.w D7, [A6 + 0x6508]
// begin alternate branch 00001B20-00001B22
label00001B20:
1B20 bcs +0xA /* 00001B2A */
// end alternate branch 00001B20-00001B22
label00001B20: // (misaligned)
1B22 addi.w [A4], 0x6869 /* 'hi' */
1B26 moveq.l D1, 0x74
1B28 moveq.l D4, 0x08
label00001B2A:
1B2A bchg [A4], D5
1B2C moveq.l D3, 0x65
1B2E bgt +0x76 /* 00001BA4 */
label00001B30:
1B30 moveq.l D4, 0x2D
1B32 move A1, USP
1B34 bgt +0x67 /* 00001B9B */
1B36 cmpi.w [A4], 0x7765 /* 'we' */
1B3A bgt +0x76 /* 00001BB0 */
1B3C moveq.l D4, 0x2D
1B3E chk.w D2, [A1 + 0x6768]
1B42 moveq.l D2, 0x08
1B44 cmpi.w [A4], 0x7765 /* 'we' */
1B48 bgt +0x76 /* 00001BBE */
1B4A moveq.l D4, 0x2D
1B4C subq.w -[A5], 1
1B4E moveq.l D3, 0x65
1B50 bgt +0xA /* 00001B5A */
1B52 xori.w [A4], 0x7765 /* 'we' */
1B56 bgt +0x76 /* 00001BCC */
1B58 moveq.l D4, 0x2D
label00001B5A:
1B5A subq.w [A1 + 0x7808], 1
1B5E bchg [A4], D5
1B60 moveq.l D3, 0x65
1B62 bgt +0x76 /* 00001BD8 */
1B64 moveq.l D4, 0x2D
1B66 not.w [A1 + 0x7665]
1B6A bchg [A4], D5
1B6C moveq.l D3, 0x65
1B6E bgt +0x76 /* 00001BE4 */
1B70 moveq.l D4, 0x2D
1B72 not.w [A7 + 0x7572]
1B76 cmpi.w [A4], 0x7765 /* 'we' */
1B7A bgt +0x76 /* 00001BF0 */
1B7C moveq.l D4, 0x2D
1B7E addq.w [A0 + 0x7265], 2
1B82 bcs +0xA /* 00001B8C */
1B84 xori.w [A4], 0x7765 /* 'we' */
1B88 bgt +0x76 /* 00001BFE */
1B8A moveq.l D4, 0x2D
label00001B8C:
1B8C addq.w [A7 + <<invalid base displacement size>> + D6 * 8], 2
1B90 xori.w [A4], 0x7765 /* 'we' */
1B94 bgt +0x76 /* 00001C0A */
1B96 moveq.l D4, 0x2D
1B98 chk.w D7, [A6 + 0x6508]
1B9C addi.w [A4], 0x7765 /* 'we' */
1BA0 bgt +0x76 /* 00001C16 */
1BA2 moveq.l D4, 0x08
label00001BA4:
1BA4 bchg.b A6, 0x6E /* 'n' */
1BA8 bcs +0x76 /* 00001C1E */
1BAA bcs +0x67 /* 00001C11 */
1BAC bgt +0xA /* 00001BB6 */
1BAE bchg.b D5, 0x67 /* 'g' */
// begin alternate branch 00001BB0-00001BB2
label00001BB0:
1BB0 bvs +0x69 /* 00001C19 */
// end alternate branch 00001BB0-00001BB2
label00001BB0: // (misaligned)
1BB2 bvc +0x76 /* 00001C28 */
1BB4 bcs +0x67 /* 00001C1B */
label00001BB6:
1BB6 bgt +0xA /* 00001BC0 */
1BB8 bchg [A3], D4
1BBA bcs +0x78 /* 00001C32 */
1BBC bcs +0x70 /* 00001C2C */
label00001BBE:
1BBE moveq.l D2, 0x65
label00001BC0:
1BC0 bcs +0x70 /* 00001C30 */
1BC2 bchg [A3], D3
1BC4 bvs +0x7A /* 00001C3E */
1BC6 moveq.l D2, 0x65
1BC8 bcs +0x70 /* 00001C38 */
1BCA bchg D6, D3
label00001BCC:
1BCC bvs +0x68 /* 00001C34 */
1BCE moveq.l D2, 0x65
1BD0 bcs +0x70 /* 00001C40 */
1BD2 bchg.b D6, 0x75 /* 'u' */
1BD6 moveq.l D1, 0x74
label00001BD8:
1BD8 bcs +0x67 /* 00001C3F */
1BDA bgt +0xA /* 00001BE4 */
1BDC bchg.b [A4], 0x69 /* 'i' */
1BE0 moveq.l D1, 0x74
1BE2 bcs +0x67 /* 00001C49 */
label00001BE4:
1BE4 bgt +0xA /* 00001BEE */
1BE6 addi.w [A4], 0x7765 /* 'we' */
1BEA bge +0x78 /* 00001C62 */
1BEC bcs +0xA /* 00001BF6 */
label00001BEE:
1BEE addi.w D5, 0x6C65 /* 'le' */
// begin alternate branch 00001BF0-00001BF2
label00001BF0:
1BF0 bge +0x67 /* 00001C57 */
// end alternate branch 00001BF0-00001BF2
label00001BF0: // (misaligned)
1BF2 moveq.l D3, 0x65
1BF4 bgt +0xA /* 00001BFE */
label00001BF6:
1BF6 subi.w A6, 0x696E /* 'in' */
1BFA bcs +0xA /* 00001C04 */
1BFC bchg D5, D2
label00001BFE:
1BFE bvs +0x69 /* 00001C67 */
1C00 bvc +0x76 /* 00001C76 */
1C02 bchg [A3], D2
label00001C04:
1C04 bcs +0x78 /* 00001C7C */
1C06 bcs +0x70 /* 00001C76 */
1C08 subi.w D6, 0x6976 /* 'iv' */
// begin alternate branch 00001C0A-00001C0C
label00001C0A:
1C0A bvs +0x78 /* 00001C82 */
// end alternate branch 00001C0A-00001C0C
label00001C0A: // (misaligned)
1C0C bcs +0xA /* 00001C16 */
1C0E subi.w D6, 0x6F75 /* 'ou' */
1C12 moveq.l D1, 0x08
1C14 bchg [A4], D2
label00001C16:
1C16 bvc +0x74 /* 00001C8A */
1C18 bcs +0x67 /* 00001C7F */
fn00001C1A:
1C1A link A6, -0x0230
label00001C1E:
1C1E move.l -[A7], D7
1C20 pea.l [A6 - 0x230]
1C24 pea.l [PC + 0x264 /* 00001E8A, value 0x64C6576, pstring "Level " */]
label00001C28:
1C28 movea.l A0, [A5 - 0x2BC]
label00001C2C:
1C2C move.w D0, [A6 + 0xA]
label00001C30:
1C30 asl D0.w, 8
label00001C32:
1C32 addi.w D0, 0xFF00
// begin alternate branch 00001C34-00001C36
label00001C34:
1C34 .extension 0xF00 <<F/4-5/7>> // unimplemented
// end alternate branch 00001C34-00001C36
label00001C34: // (misaligned)
1C36 pea.l [A0 + D0.w]
// begin alternate branch 00001C38-00001C40
label00001C38:
1C38 ori.b D0, 0x7A /* 'z' */
1C3C andi.w A4, 0x3F3C /* '?<' */
// end alternate branch 00001C38-00001C40
label00001C38: // (misaligned)
1C3A pea.l [PC + 0x24C /* 00001E88, value 0x13A064C */]
label00001C3E:
1C3E move.w -[A7], 0x3
// begin alternate branch 00001C40-00001C46
label00001C40:
1C40 ori.b D3, 0xBA
1C44 rol D4, D1
// end alternate branch 00001C40-00001C46
label00001C40: // (misaligned)
1C42 jsr [PC - 0x1C44 /* 00000000 */]
1C46 addq.w A7, 4
1C48 move.w -[A7], 0xFF
1C4C pea.l [A6 - 0x230]
1C50 pea.l [A6 - 0x110]
1C54 jsr [PC - 0x1A30 /* 00000226 */]
1C58 move.l -[A7], [A5 - 0x432]
1C5C move.l -[A7], [A5 - 0x42E]
1C60 move.l D0, 0x80006
// begin alternate branch 00001C62-00001C66
label00001C62:
1C62 ori.b A0, 0x6
// end alternate branch 00001C62-00001C66
label00001C62: // (misaligned)
1C66 syscall QDExtensions
1C68 clr.w [A6 - 0x126]
1C6C clr.w [A6 - 0x122]
1C70 move.w [A6 - 0x124], 0x4E20 /* 'N ' */
label00001C76:
1C76 pea.l [A6 - 0x126]
1C7A syscall RGBForeColor
label00001C7C:
1C7C moveq.l D0, 0x21
1C7E move.l -[A7], D0
1C80 syscall BackColor
label00001C82:
1C82 pea.l [A5 - 0x42A]
1C86 syscall EraseRect
1C88 move.w -[A7], 0x1
// begin alternate branch 00001C8A-00001C8E
label00001C8A:
1C8A ori.b D1, 0x87
// end alternate branch 00001C8A-00001C8E
label00001C8A: // (misaligned)
1C8C syscall TextFont
1C8E clr.b [A6 - 0x132]
1C92 moveq.l D0, 0x00
1C94 move.b D0, [A6 - 0x132]
1C98 move.w -[A7], D0
1C9A syscall TextFace
1C9C move.w -[A7], 0x1
1CA0 syscall TextMode
1CA2 move.w -[A7], 0x40 /* '@' */
1CA6 syscall TextSize
1CA8 clr.l -[A7]
1CAA syscall SpaceExtra
1CAC subq.w A7, 2
1CAE pea.l [A6 - 0x110]
1CB2 syscall StringWidth
1CB4 move.w D0, [A7]+
1CB6 ext.l D0
1CB8 divs.w D0, 0x2
1CBC move.w D1, 0x140
1CC0 sub.w D1, D0
1CC2 addq.w D1, 2
1CC4 move.w -[A7], D1
1CC6 move.w -[A7], 0x7A /* 'z' */
1CCA syscall MoveTo
1CCC pea.l [A6 - 0x110]
1CD0 syscall DrawString
1CD2 clr.w [A6 - 0x122]
1CD6 move.w [A6 - 0x124], 0xFFFF
1CDC pea.l [A6 - 0x126]
1CE0 syscall RGBForeColor
1CE2 subq.w A7, 2
1CE4 pea.l [A6 - 0x110]
1CE8 syscall StringWidth
1CEA move.w D0, [A7]+
1CEC ext.l D0
1CEE divs.w D0, 0x2
1CF2 move.w D1, 0x140
1CF6 sub.w D1, D0
1CF8 move.w -[A7], D1
1CFA move.w -[A7], 0x78 /* 'x' */
1CFE syscall MoveTo
1D00 pea.l [A6 - 0x110]
1D04 syscall DrawString
1D06 pea.l [A6 - 0x230]
1D0A movea.l A0, [A5 - 0x2B8]
1D0E move.w D0, [A6 + 0xA]
1D12 asl D0.w, 8
1D14 addi.w D0, 0xFF00
1D18 pea.l [A0 + D0.w]
1D1C jsr [PC - 0xBFC /* 00001122 */]
1D20 addq.w A7, 4
1D22 move.w -[A7], 0xFF
1D26 pea.l [A6 - 0x230]
1D2A pea.l [A6 - 0x110]
1D2E jsr [PC - 0x1B0A /* 00000226 */]
1D32 move.w -[A7], 0x50 /* 'P' */
1D36 syscall TextSize
1D38 moveq.l D7, 0x50
1D3A bra +0x8 /* 00001D42 */
label00001D3C:
1D3C subq.w D7, 1
1D3E move.w -[A7], D7
1D40 syscall TextSize
label00001D42:
1D42 subq.w A7, 2
1D44 pea.l [A6 - 0x110]
1D48 syscall StringWidth
1D4A cmpi.w [A7]+, 0x280
1D4E bgt -0x12 /* 00001D3C */
1D50 clr.w [A6 - 0x124]
1D54 move.w [A6 - 0x122], 0xFFFF
1D5A move.w [A6 - 0x126], 0xFFFF
1D60 pea.l [A6 - 0x126]
1D64 syscall RGBForeColor
1D66 subq.w A7, 2
1D68 pea.l [A6 - 0x110]
1D6C syscall StringWidth
1D6E move.w D0, [A7]+
1D70 ext.l D0
1D72 divs.w D0, 0x2
1D76 move.w D1, 0x140
1D7A sub.w D1, D0
1D7C move.w -[A7], D1
1D7E move.w -[A7], 0x10E
1D82 syscall MoveTo
1D84 pea.l [A6 - 0x110]
1D88 syscall DrawString
1D8A clr.w [A6 - 0x124]
1D8E clr.w [A6 - 0x122]
1D92 move.w [A6 - 0x126], 0xD8F0
1D98 pea.l [A6 - 0x126]
1D9C syscall RGBForeColor
1D9E lea.l A0, [PC + 0xC0 /* 00001E60, value 0x27636C69 '\'cli', pstring "click mouse or hit spacebar to continue" */]
1DA2 lea.l A1, [A6 - 0x110]
1DA6 moveq.l D0, 0x09
label00001DA8:
1DA8 move.l [A1]+, [A0]+
1DAA dbf D0, -0x6 /* 00001DA8 */
1DAE move.w -[A7], 0x9 /* '\t' */
1DB2 syscall TextSize
1DB4 subq.w A7, 2
1DB6 pea.l [A6 - 0x110]
1DBA syscall StringWidth
1DBC move.w D0, [A7]+
1DBE ext.l D0
1DC0 divs.w D0, 0x2
1DC4 move.w D1, 0x140
1DC8 sub.w D1, D0
1DCA move.w -[A7], D1
1DCC move.w -[A7], 0x1DE
1DD0 syscall MoveTo
1DD2 pea.l [A6 - 0x110]
1DD6 syscall DrawString
1DD8 tst.b [A6 + 0x8]
1DDC beq +0xC /* 00001DE8 */
1DDE move.w -[A7], 0x6C /* 'l' */
1DE2 jsr [PC - 0x1A12 /* 000003D2 */]
1DE6 bra +0xA /* 00001DF0 */
label00001DE8:
1DE8 move.w -[A7], 0x6F /* 'o' */
1DEC jsr [PC - 0x1A1C /* 000003D2 */]
label00001DF0:
1DF0 pea.l [A6 - 0x120]
1DF4 syscall GetKeys
1DF6 bra +0x12 /* 00001E08 */
label00001DF8:
1DF8 pea.l [A6 - 0x120]
1DFC syscall GetKeys
1DFE move.w -[A7], 0xFFFF
1E02 clr.w -[A7]
1E04 move.l D0, [A7]+
1E06 syscall FlushEvents
label00001E08:
1E08 subq.w A7, 2
1E0A syscall Button
1E0C move.b D0, [A7]+
1E0E subq.b D0, 1
1E10 moveq.l D1, 0x31
1E12 move.w D2, D1
1E14 lsr D2.w, 3
1E16 addi.w D2, 0xFEE0
1E1A btst [A6 + D2.w], D1
1E1E seq D1
1E20 and.b D0, D1
1E22 moveq.l D1, 0x0C
1E24 move.w D2, D1
1E26 lsr D2.w, 3
1E28 addi.w D2, 0xFEE0
1E2C btst [A6 + D2.w], D1
1E30 seq D1
1E32 and.b D0, D1
1E34 moveq.l D1, 0x24
1E36 move.w D2, D1
1E38 lsr D2.w, 3
1E3A addi.w D2, 0xFEE0
1E3E btst [A6 + D2.w], D1
1E42 seq D1
1E44 and.b D0, D1
1E46 bne -0x4E /* 00001DF8 */
1E48 moveq.l D0, 0x21
1E4A move.l -[A7], D0
1E4C syscall ForeColor
1E4E moveq.l D0, 0x1E
1E50 move.l -[A7], D0
1E52 syscall BackColor
1E54 clr.b [A5 - 0x437]
1E58 move.l D7, [A7]+
1E5A unlink A6
1E5C move.l [A7], [A7]+
1E5E rts
1E60 move.l [A3 + 0x6C69], -[A3]
1E64 bls +0x6D /* 00001ED1 */
1E66 movea.l A0, [A5 + 0x6F75]
1E6A moveq.l D1, 0x65
1E6C movea.l A0, [A7 + 0x7220]
1E70 bvc +0x6B /* 00001EDB */
1E72 moveq.l D2, 0x20
1E74 moveq.l D1, 0x70
1E76 bsr +0x65 /* 00001EDB */
1E78 bcs +0x64 /* 00001EDC */
1E7A bsr +0x74 /* 00001EEE */
1E7C movea.l A0, [A4 + 0x636F + D6 * 8]
1E82 bgt +0x76 /* 00001EF8 */
1E84 bvs +0x70 /* 00001EF4 */
1E86 moveq.l D2, 0x65
1E88 btst [PC + 0x64C /* 000024D6, value 0x3F '?' */], D0
1E8C bcs +0x78 /* 00001F04 */
1E8E bcs +0x6E /* 00001EFC */
1E90 move.l D0, [A2]
fn00001E92:
1E92 link A6, -0x002E
1E96 movem.l -[A7], D6,D7
1E9A move.l -[A7], [A5 - 0x432]
1E9E move.l -[A7], [A5 - 0x42E]
1EA2 move.l D0, 0x80006
1EA8 syscall QDExtensions
1EAA clr.l D6
1EAC moveq.l D0, 0x21
1EAE move.l -[A7], D0
1EB0 syscall ForeColor
1EB2 moveq.l D0, 0x1E
1EB4 move.l -[A7], D0
1EB6 syscall BackColor
1EB8 pea.l [A6 - 0x1E]
1EBC move.w D0, [A5 - 0x3C6]
1EC0 muls.w D0, 0x28 /* '(' */
1EC4 addi.w D0, 0xFFD8
1EC8 move.w -[A7], D0
1ECA move.w D0, [A5 - 0x3C4]
1ECE muls.w D0, 0x28 /* '(' */
1ED2 addi.w D0, 0xFFD8
1ED6 move.w -[A7], D0
1ED8 move.w D0, [A5 - 0x3C6]
label00001EDC:
1EDC muls.w D0, 0x28 /* '(' */
1EE0 move.w -[A7], D0
1EE2 move.w D0, [A5 - 0x3C4]
1EE6 muls.w D0, 0x28 /* '(' */
1EEA move.w -[A7], D0
1EEC syscall SetRect
fn00001EEE:
1EEE moveq.l D7, 0x01
1EF0 bra +0xC /* 00001EFC */
label00001EF2:
1EF2 move.w -[A7], 0xFFFF
// begin alternate branch 00001EF4-00001EF6
label00001EF4:
1EF4 .invalid <<F/7/7>>
// end alternate branch 00001EF4-00001EF6
label00001EF4: // (misaligned)
1EF6 clr.w -[A7]
label00001EF8:
1EF8 move.l D0, [A7]+
1EFA syscall FlushEvents
label00001EFC:
1EFC subq.w A7, 4
1EFE syscall TickCount
1F00 cmp.l D6, [A7]+
1F02 bgt -0x10 /* 00001EF2 */
label00001F04:
1F04 subq.w A7, 4
1F06 syscall TickCount
1F08 move.l D6, [A7]+
1F0A addq.l D6, 1
1F0C move.w D0, [A5 - 0x42A]
1F10 sub.w D0, [A6 - 0x1E]
1F14 muls.w D0, D7
1F16 ext.l D0
1F18 divs.w D0, 0x32 /* '2' */
1F1C add.w D0, [A6 - 0x1E]
1F20 move.w [A6 - 0x26], D0
1F24 move.w D0, [A5 - 0x426]
1F28 sub.w D0, [A6 - 0x1A]
1F2C muls.w D0, D7
1F2E ext.l D0
1F30 divs.w D0, 0x32 /* '2' */
1F34 add.w D0, [A6 - 0x1A]
1F38 move.w [A6 - 0x22], D0
1F3C move.w D0, [A5 - 0x428]
1F40 sub.w D0, [A6 - 0x1C]
1F44 muls.w D0, D7
1F46 ext.l D0
1F48 divs.w D0, 0x32 /* '2' */
1F4C add.w D0, [A6 - 0x1C]
1F50 move.w [A6 - 0x24], D0
1F54 move.w D0, [A5 - 0x424]
1F58 sub.w D0, [A6 - 0x18]
1F5C muls.w D0, D7
1F5E ext.l D0
1F60 divs.w D0, 0x32 /* '2' */
1F64 add.w D0, [A6 - 0x18]
1F68 move.w [A6 - 0x20], D0
1F6C pea.l [A6 - 0x26]
1F70 syscall PaintRect
1F72 addq.w D7, 1
1F74 cmpi.w D7, 0x64 /* 'd' */
1F78 ble -0x7C /* 00001EFC */
1F7A movem.l D6,D7, [A7]+
1F7E unlink A6
1F80 rts
fn00001F82:
1F82 link A6, -0x003A
1F86 move.l -[A7], D7
1F88 move.l -[A7], [A5 - 0x432]
1F8C move.l -[A7], [A5 - 0x42E]
1F90 move.l D0, 0x80006
1F96 syscall QDExtensions
1F98 move.l -[A7], [A5 - 0x2A8]
1F9C syscall GetClip
1F9E move.l -[A7], [A5 - 0x2AC]
1FA2 move.w D0, [A5 - 0x3C6]
1FA6 muls.w D0, 0x28 /* '(' */
1FAA addi.w D0, 0xFFB0
1FAE move.w -[A7], D0
1FB0 move.w D0, [A5 - 0x3C4]
1FB4 muls.w D0, 0x28 /* '(' */
1FB8 addi.w D0, 0xFFD8
1FBC move.w -[A7], D0
1FBE move.w D0, [A5 - 0x3C6]
1FC2 muls.w D0, 0x28 /* '(' */
1FC6 move.w -[A7], D0
1FC8 move.w D0, [A5 - 0x3C4]
1FCC muls.w D0, 0x28 /* '(' */
1FD0 move.w -[A7], D0
1FD2 syscall SetRecRgn
1FD4 move.l -[A7], [A5 - 0x2A8]
1FD8 move.l -[A7], [A5 - 0x2AC]
1FDC move.l -[A7], [A5 - 0x2AC]
1FE0 syscall DiffRgn
1FE2 move.l -[A7], [A5 - 0x2AC]
1FE6 syscall SetClip
1FE8 clr.l [A6 - 0x16]
1FEC move.w D0, [A5 - 0x3C6]
1FF0 muls.w D0, 0x28 /* '(' */
1FF4 addq.w D0, 7
1FF6 addi.w D0, 0xFFD8
1FFA move.w [A6 - 0x18], D0
1FFE move.w D0, [A5 - 0x3C4]
2002 muls.w D0, 0x28 /* '(' */
2006 addi.w D0, 0x14
200A addi.w D0, 0xFFD8
200E move.w [A6 - 0x1A], D0
2012 moveq.l D7, 0x01
label00002014:
2014 move.w D0, [A5 - 0x42A]
2018 sub.w D0, [A6 - 0x1A]
201C muls.w D0, D7
201E ext.l D0
2020 divs.w D0, 0x24 /* '$' */
2024 add.w D0, [A6 - 0x1A]
2028 move.w [A6 - 0x22], D0
202C move.w D0, [A5 - 0x426]
2030 sub.w D0, [A6 - 0x1A]
2034 muls.w D0, D7
2036 ext.l D0
2038 divs.w D0, 0x24 /* '$' */
203C add.w D0, [A6 - 0x1A]
2040 move.w [A6 - 0x1E], D0
2044 move.w D0, [A5 - 0x428]
2048 sub.w D0, [A6 - 0x18]
204C muls.w D0, D7
204E ext.l D0
2050 divs.w D0, 0x24 /* '$' */
2054 add.w D0, [A6 - 0x18]
2058 move.w [A6 - 0x20], D0
205C move.w D0, [A5 - 0x424]
2060 sub.w D0, [A6 - 0x18]
2064 muls.w D0, D7
2066 ext.l D0
2068 divs.w D0, 0x24 /* '$' */
206C add.w D0, [A6 - 0x18]
2070 move.w [A6 - 0x1C], D0
2074 pea.l [A6 - 0x22]
2078 syscall InvertRect
207A pea.l [A6 - 0x22]
207E syscall InvertOval
2080 addq.w D7, 1
2082 cmpi.w D7, 0x36 /* '6' */
2086 ble -0x72 /* 00002014 */
2088 moveq.l D7, 0x01
label0000208A:
208A move.w D0, [A5 - 0x42A]
208E sub.w D0, [A6 - 0x1A]
2092 muls.w D0, D7
2094 ext.l D0
2096 divs.w D0, 0x32 /* '2' */
209A add.w D0, [A6 - 0x1A]
209E move.w [A6 - 0x22], D0
20A2 move.w D0, [A5 - 0x426]
20A6 sub.w D0, [A6 - 0x1A]
20AA muls.w D0, D7
20AC ext.l D0
20AE divs.w D0, 0x32 /* '2' */
20B2 add.w D0, [A6 - 0x1A]
20B6 move.w [A6 - 0x1E], D0
20BA move.w D0, [A5 - 0x428]
20BE sub.w D0, [A6 - 0x18]
20C2 muls.w D0, D7
20C4 ext.l D0
20C6 divs.w D0, 0x32 /* '2' */
20CA add.w D0, [A6 - 0x18]
20CE move.w [A6 - 0x20], D0
20D2 move.w D0, [A5 - 0x424]
20D6 sub.w D0, [A6 - 0x18]
20DA muls.w D0, D7
20DC ext.l D0
20DE divs.w D0, 0x32 /* '2' */
20E2 add.w D0, [A6 - 0x18]
20E6 move.w [A6 - 0x1C], D0
20EA pea.l [A6 - 0x22]
20EE syscall PaintRect
20F0 addq.w D7, 1
20F2 cmpi.w D7, 0x32 /* '2' */
20F6 ble -0x6C /* 0000208A */
20F8 move.l -[A7], [A5 - 0x2A8]
20FC syscall SetClip
20FE move.l D7, [A7]+
2100 unlink A6
2102 rts
fn00002104:
2104 link A6, -0x0028
2108 movem.l -[A7], D7,A4
210C subq.w A7, 4
210E syscall TickCount
2110 move.l D7, [A7]+
2112 bra +0xC /* 0000211E */
label00002114:
2114 move.w -[A7], 0xFFFF
2118 clr.w -[A7]
211A move.l D0, [A7]+
211C syscall FlushEvents
label0000211E:
211E subq.w A7, 4
2120 syscall TickCount
2122 cmp.l D7, [A7]+
2124 bgt -0x10 /* 00002114 */
2126 subq.w A7, 4
2128 move.w -[A7], 0x131
212C syscall GetPicture
212E movea.l A4, [A7]+
2130 move.l -[A7], [A5 - 0x432]
2134 move.l -[A7], [A5 - 0x42E]
2138 move.l D0, 0x80006
213E syscall QDExtensions
2140 move.l -[A7], A4
2142 pea.l [A5 - 0x42A]
2146 syscall DrawPicture
2148 move.l -[A7], A4
214A syscall ReleaseResource
214C move.w -[A7], 0x6D /* 'm' */
2150 jsr [PC - 0x1D80 /* 000003D2 */]
2154 pea.l [A6 - 0x28]
2158 syscall GetKeys
215A bra +0x12 /* 0000216C */
label0000215C:
215C pea.l [A6 - 0x28]
2160 syscall GetKeys
2162 move.w -[A7], 0xFFFF
2166 clr.w -[A7]
2168 move.l D0, [A7]+
216A syscall FlushEvents
label0000216C:
216C subq.w A7, 2
216E syscall Button
2170 move.b D0, [A7]+
2172 subq.b D0, 1
2174 moveq.l D1, 0x31
2176 move.w D2, D1
2178 lsr D2.w, 3
217A btst [A6 + D2.w - 0x28], D1
217E seq D1
2180 and.b D0, D1
2182 moveq.l D1, 0x0C
2184 move.w D2, D1
2186 lsr D2.w, 3
2188 btst [A6 + D2.w - 0x28], D1
218C seq D1
218E and.b D0, D1
2190 moveq.l D1, 0x24
2192 move.w D2, D1
2194 lsr D2.w, 3
2196 btst [A6 + D2.w - 0x28], D1
219A seq D1
219C and.b D0, D1
219E bne -0x42 /* 0000215C */
21A0 move.w -[A7], 0xCE
21A4 jsr [PC - 0x1DD4 /* 000003D2 */]
21A8 movem.l D7,A4, [A7]+
21AC unlink A6
21AE rts
fn000021B0:
21B0 link A6, -0x0018
21B4 movea.l A0, [A6 + 0xC]
21B8 lea.l A1, [A6 - 0x18]
21BC move.l [A1]+, [A0]+
21BE move.l [A1]+, [A0]+
21C0 move.l -[A7], [A5 - 0x432]
21C4 move.l -[A7], [A5 - 0x42E]
21C8 move.l D0, 0x80006
21CE syscall QDExtensions
21D0 movea.l A0, [A5 - 0x456]
21D4 pea.l [A0 + 0x2]
21D8 movea.l A0, [A5 - 0x432]
21DC pea.l [A0 + 0x2]
21E0 pea.l [A6 - 0x18]
21E4 pea.l [A6 - 0x18]
21E8 clr.w -[A7]
21EA clr.l -[A7]
21EC syscall CopyBits
21EE unlink A6
21F0 movea.l A0, [A7]+
21F2 addq.w A7, 8
21F4 jmp [A0]
fn000021F6:
21F6 link A6, -0x0022
21FA move.l -[A7], A4
21FC movea.l A0, [A6 + 0x8]
2200 movea.l A4, A0
2202 move.w D0, [A4 + 0x2]
2206 muls.w D0, 0xE
220A move.w D1, [A4 + 0x4]
220E add.w D0, D1
2210 addi.w D0, 0xFC44
2214 move.b D0, [A5 + D0.w]
2218 bra +0xA4 /* 000022BC */
label0000221C:
221C pea.l [A6 - 0x22]
2220 move.w -[A7], [A4 + 0x2]
2224 move.w -[A7], [A4 + 0x4]
2228 clr.w -[A7]
222A jsr [PC + 0x18B2 /* 00003ADE */]
222E move.w D0, [A4 + 0x6]
2232 addq.w D0, 1
2234 move.w [A4 + 0x6], D0
2238 cmpi.w [A4 + 0x6], 0x8
223E bge +0x8 /* 00002246 */
2240 move.w [A4 + 0x6], 0x8
label00002246:
2246 cmpi.w [A4 + 0x6], 0xA /* '\n' */
224C ble +0x32 /* 0000227E */
224E move.w D0, [A4 + 0x2]
2252 muls.w D0, 0xE
2256 move.w D1, [A4 + 0x4]
225A add.w D0, D1
225C addi.w D0, 0xFC44
2260 clr.b [A5 + D0.w]
2264 move.w -[A7], [A4 + 0x2]
2268 move.w -[A7], [A4 + 0x4]
226C jsr [PC + 0x16E0 /* 0000394E */]
2270 pea.l [A6 - 0x22]
2274 move.l -[A7], A6
2276 jsr [PC - 0xC8 /* 000021B0 */]
227A clr.b [A4]
227C bra +0x48 /* 000022C4 */
label0000227E:
227E pea.l [A6 - 0x1A]
2282 move.w -[A7], 0x5
2286 move.w -[A7], [A4 + 0x6]
228A clr.w -[A7]
228C jsr [PC + 0x1850 /* 00003ADE */]
2290 pea.l [A6 - 0x1A]
2294 pea.l [A6 - 0x22]
2298 jsr [PC + 0x1A44 /* 00003CDE */]
229C pea.l [A6 - 0x22]
22A0 move.l -[A7], A6
22A2 jsr [PC - 0xF4 /* 000021B0 */]
22A6 move.b [A4], 0x1
22AA subq.w A7, 4
22AC syscall TickCount
22AE move.w D0, [A5 - 0x10A]
22B2 ext.l D0
22B4 add.l D0, [A7]+
22B6 move.l [A4 + 0x8], D0
22BA bra +0xA /* 000022C4 */
label000022BC:
22BC addi.b D0, 0xF6
22C0 beq -0xA4 /* 0000221C */
label000022C4:
22C4 movea.l A4, [A7]+
22C6 unlink A6
22C8 move.l [A7], [A7]+
22CA rts
fn000022CC:
22CC link A6, -0x0048
22D0 movem.l -[A7], D5,D6,D7
22D4 move.b D0, [A6 + 0x8]
22D8 bra +0x162E /* 00003906 */
22DC pea.l [A6 - 0x18]
22E0 move.w -[A7], 0x1
22E4 move.w -[A7], 0x1
22E8 jsr [PC + 0x193A /* 00003C24 */]
22EC pea.l [A6 - 0x20]
22F0 move.w -[A7], [A5 - 0x3C6]
22F4 move.w -[A7], [A5 - 0x3C4]
22F8 clr.w -[A7]
22FA jsr [PC + 0x17E2 /* 00003ADE */]
22FE move.w -[A7], [A5 - 0x3C6]
2302 move.w -[A7], [A5 - 0x3C4]
2306 jsr [PC + 0x1646 /* 0000394E */]
230A pea.l [A6 - 0x18]
230E pea.l [A6 - 0x20]
2312 jsr [PC + 0x16A2 /* 000039B6 */]
2316 pea.l [A6 - 0x20]
231A move.w -[A7], [A5 - 0x114]
231E jsr [PC + 0x170E /* 00003A2E */]
2322 clr.b [A5 - 0x3C2]
2326 bra +0x1614 /* 0000393A */
232A clr.b [A5 - 0x3C0]
232E tst.b [A5 - 0x3C1]
2332 beq +0x134 /* 00002466 */
2336 move.w D0, [A5 - 0x3C6]
233A addq.w D0, 1
233C muls.w D0, 0xE
2340 move.w D1, [A5 - 0x3C4]
2344 add.w D0, D1
2346 moveq.l D1, 0x00
2348 addi.w D0, 0xFC44
234C move.b D1, [A5 + D0.w]
2350 move.w -[A7], D1
2352 pea.l [PC + 0x15F8 /* 0000394C, value 0xF2194E56 */]
2356 pea.l [A6 - 0x48]
235A move.w -[A7], 0x2
235E jsr [PC - 0x21C6 /* 0000019A */]
2362 pea.l [A6 - 0x48]
2366 jsr [PC - 0x2182 /* 000001E6 */]
236A beq +0x6E /* 000023D8 */
236C pea.l [A6 - 0x20]
2370 move.w -[A7], [A5 - 0x3C6]
2374 move.w -[A7], [A5 - 0x3C4]
2378 clr.w -[A7]
237A jsr [PC + 0x17CC /* 00003B48 */]
237E moveq.l D7, 0x01
label00002380:
2380 pea.l [A6 - 0x18]
2384 move.w -[A7], 0x1
2388 move.w -[A7], D7
238A jsr [PC + 0x18D6 /* 00003C62 */]
238E move.w -[A7], [A5 - 0x3C6]
2392 move.w -[A7], [A5 - 0x3C4]
2396 jsr [PC + 0x15B6 /* 0000394E */]
239A move.w D0, [A5 - 0x3C6]
239E addq.w D0, 1
23A0 move.w -[A7], D0
23A2 move.w -[A7], [A5 - 0x3C4]
23A6 jsr [PC + 0x15A6 /* 0000394E */]
23AA pea.l [A6 - 0x18]
23AE pea.l [A6 - 0x20]
23B2 jsr [PC + 0x1602 /* 000039B6 */]
23B6 pea.l [A6 - 0x20]
23BA move.w -[A7], [A5 - 0x112]
23BE jsr [PC + 0x166E /* 00003A2E */]
23C2 addq.w D7, 1
23C4 cmpi.w D7, 0x9 /* '\t' */
23C8 ble -0x48 /* 00002380 */
23CA move.w D0, [A5 - 0x3C6]
23CE addq.w D0, 1
23D0 move.w [A5 - 0x3C6], D0
23D4 bra +0x1C2 /* 00002596 */
label000023D8:
23D8 pea.l [A6 - 0x20]
23DC move.w -[A7], [A5 - 0x3C6]
23E0 move.w -[A7], [A5 - 0x3C4]
23E4 clr.w -[A7]
23E6 jsr [PC + 0x16F6 /* 00003ADE */]
23EA moveq.l D7, 0x01
label000023EC:
23EC pea.l [A6 - 0x18]
23F0 move.w -[A7], 0x1
23F4 move.w -[A7], D7
23F6 jsr [PC + 0x182C /* 00003C24 */]
23FA move.w -[A7], [A5 - 0x3C6]
23FE move.w -[A7], [A5 - 0x3C4]
2402 jsr [PC + 0x154A /* 0000394E */]
2406 pea.l [A6 - 0x18]
240A pea.l [A6 - 0x20]
240E jsr [PC + 0x15A6 /* 000039B6 */]
2412 pea.l [A6 - 0x20]
2416 move.w -[A7], [A5 - 0x112]
241A jsr [PC + 0x1612 /* 00003A2E */]
241E addq.w D7, 1
2420 cmpi.w D7, 0x2
2424 ble -0x38 /* 000023EC */
2426 moveq.l D7, 0x02
label00002428:
2428 pea.l [A6 - 0x18]
242C move.w -[A7], 0x1
2430 move.w -[A7], D7
2432 jsr [PC + 0x17F0 /* 00003C24 */]
2436 move.w -[A7], [A5 - 0x3C6]
243A move.w -[A7], [A5 - 0x3C4]
243E jsr [PC + 0x150E /* 0000394E */]
2442 pea.l [A6 - 0x18]
2446 pea.l [A6 - 0x20]
244A jsr [PC + 0x156A /* 000039B6 */]
244E pea.l [A6 - 0x20]
2452 move.w -[A7], [A5 - 0x112]
2456 jsr [PC + 0x15D6 /* 00003A2E */]
245A subq.w D7, 1
245C cmpi.w D7, 0x1
2460 bge -0x38 /* 00002428 */
2462 bra +0x134 /* 00002596 */
label00002466:
2466 move.w D0, [A5 - 0x3C6]
246A subq.w D0, 1
246C muls.w D0, 0xE
2470 move.w D1, [A5 - 0x3C4]
2474 add.w D0, D1
2476 moveq.l D1, 0x00
2478 addi.w D0, 0xFC44
247C move.b D1, [A5 + D0.w]
2480 move.w -[A7], D1
2482 pea.l [PC + 0x14C6 /* 0000394A, value 0xEA19F219 */]
2486 pea.l [A6 - 0x48]
248A move.w -[A7], 0x2
248E jsr [PC - 0x22F6 /* 0000019A */]
2492 pea.l [A6 - 0x48]
2496 jsr [PC - 0x22B2 /* 000001E6 */]
249A beq +0x72 /* 0000250C */
249C pea.l [A6 - 0x20]
24A0 move.w D0, [A5 - 0x3C6]
24A4 subq.w D0, 1
24A6 move.w -[A7], D0
24A8 move.w -[A7], [A5 - 0x3C4]
24AC clr.w -[A7]
24AE jsr [PC + 0x1698 /* 00003B48 */]
24B2 moveq.l D7, 0x01
label000024B4:
24B4 pea.l [A6 - 0x18]
24B8 move.w -[A7], 0x1
24BC move.w -[A7], D7
24BE jsr [PC + 0x17A2 /* 00003C62 */]
24C2 move.w -[A7], [A5 - 0x3C6]
24C6 move.w -[A7], [A5 - 0x3C4]
24CA jsr [PC + 0x1482 /* 0000394E */]
24CE move.w D0, [A5 - 0x3C6]
24D2 subq.w D0, 1
24D4 move.w -[A7], D0
24D6 move.w -[A7], [A5 - 0x3C4]
24DA jsr [PC + 0x1472 /* 0000394E */]
24DE pea.l [A6 - 0x18]
24E2 pea.l [A6 - 0x20]
24E6 jsr [PC + 0x14CE /* 000039B6 */]
24EA pea.l [A6 - 0x20]
24EE move.w -[A7], [A5 - 0x112]
24F2 jsr [PC + 0x153A /* 00003A2E */]
24F6 addq.w D7, 1
24F8 cmpi.w D7, 0x9 /* '\t' */
24FC ble -0x48 /* 000024B4 */
24FE move.w D0, [A5 - 0x3C6]
2502 subq.w D0, 1
2504 move.w [A5 - 0x3C6], D0
2508 bra +0x8E /* 00002596 */
label0000250C:
250C pea.l [A6 - 0x20]
2510 move.w -[A7], [A5 - 0x3C6]
2514 move.w -[A7], [A5 - 0x3C4]
2518 clr.w -[A7]
251A jsr [PC + 0x15C2 /* 00003ADE */]
251E moveq.l D7, 0x01
label00002520:
2520 pea.l [A6 - 0x18]
2524 move.w -[A7], 0x1
2528 move.w -[A7], D7
252A jsr [PC + 0x16F8 /* 00003C24 */]
252E move.w -[A7], [A5 - 0x3C6]
2532 move.w -[A7], [A5 - 0x3C4]
2536 jsr [PC + 0x1416 /* 0000394E */]
253A pea.l [A6 - 0x18]
253E pea.l [A6 - 0x20]
2542 jsr [PC + 0x1472 /* 000039B6 */]
2546 pea.l [A6 - 0x20]
254A move.w -[A7], [A5 - 0x112]
254E jsr [PC + 0x14DE /* 00003A2E */]
2552 addq.w D7, 1
2554 cmpi.w D7, 0x2
2558 ble -0x38 /* 00002520 */
255A moveq.l D7, 0x02
label0000255C:
255C pea.l [A6 - 0x18]
2560 move.w -[A7], 0x1
2564 move.w -[A7], D7
2566 jsr [PC + 0x16BC /* 00003C24 */]
256A move.w -[A7], [A5 - 0x3C6]
256E move.w -[A7], [A5 - 0x3C4]
2572 jsr [PC + 0x13DA /* 0000394E */]
2576 pea.l [A6 - 0x18]
257A pea.l [A6 - 0x20]
257E jsr [PC + 0x1436 /* 000039B6 */]
2582 pea.l [A6 - 0x20]
2586 move.w -[A7], [A5 - 0x112]
258A jsr [PC + 0x14A2 /* 00003A2E */]
258E subq.w D7, 1
2590 cmpi.w D7, 0x1
2594 bge -0x38 /* 0000255C */
label00002596:
2596 clr.b [A5 - 0x3C2]
259A bra +0x13A0 /* 0000393A */
259E pea.l [A6 - 0x18]
25A2 move.w -[A7], 0x5
25A6 move.w -[A7], 0x8
25AA jsr [PC + 0x1678 /* 00003C24 */]
25AE pea.l [A6 - 0x20]
25B2 move.w -[A7], [A5 - 0x3C6]
25B6 move.w -[A7], [A5 - 0x3C4]
25BA clr.w -[A7]
25BC jsr [PC + 0x1520 /* 00003ADE */]
25C0 move.w -[A7], [A5 - 0x3C6]
25C4 move.w -[A7], [A5 - 0x3C4]
25C8 jsr [PC + 0x1384 /* 0000394E */]
25CC pea.l [A6 - 0x18]
25D0 pea.l [A6 - 0x20]
25D4 jsr [PC + 0x13E0 /* 000039B6 */]
25D8 pea.l [A6 - 0x20]
25DC move.w -[A7], [A5 - 0x114]
25E0 jsr [PC + 0x144C /* 00003A2E */]
25E4 move.b [A5 - 0x3C2], 0x2
25EA bra +0x1350 /* 0000393A */
25EE pea.l [A6 - 0x20]
25F2 move.w -[A7], [A5 - 0x3C6]
25F6 move.w -[A7], [A5 - 0x3C4]
25FA clr.w -[A7]
25FC jsr [PC + 0x14E0 /* 00003ADE */]
2600 moveq.l D7, 0x07
label00002602:
2602 pea.l [A6 - 0x18]
2606 move.w -[A7], 0x3
260A move.w -[A7], D7
260C jsr [PC + 0x1616 /* 00003C24 */]
2610 move.w -[A7], [A5 - 0x3C6]
2614 move.w -[A7], [A5 - 0x3C4]
2618 jsr [PC + 0x1334 /* 0000394E */]
261C pea.l [A6 - 0x18]
2620 pea.l [A6 - 0x20]
2624 jsr [PC + 0x1390 /* 000039B6 */]
2628 pea.l [A6 - 0x20]
262C move.w -[A7], [A5 - 0x114]
2630 jsr [PC + 0x13FC /* 00003A2E */]
2634 addq.w D7, 1
2636 cmpi.w D7, 0x8
263A ble -0x38 /* 00002602 */
263C move.b [A5 - 0x3C2], 0x3
2642 bra +0x12F8 /* 0000393A */
2646 pea.l [A6 - 0x18]
264A move.w -[A7], 0x3
264E move.w -[A7], 0x8
2652 jsr [PC + 0x15D0 /* 00003C24 */]
2656 pea.l [A6 - 0x20]
265A move.w -[A7], [A5 - 0x3C6]
265E move.w -[A7], [A5 - 0x3C4]
2662 clr.w -[A7]
2664 jsr [PC + 0x1478 /* 00003ADE */]
2668 move.w -[A7], [A5 - 0x3C6]
266C move.w -[A7], [A5 - 0x3C4]
2670 jsr [PC + 0x12DC /* 0000394E */]
2674 pea.l [A6 - 0x18]
2678 pea.l [A6 - 0x20]
267C jsr [PC + 0x1338 /* 000039B6 */]
2680 pea.l [A6 - 0x20]
2684 move.w -[A7], [A5 - 0x114]
2688 jsr [PC + 0x13A4 /* 00003A2E */]
268C move.b [A5 - 0x3C2], 0x3
2692 bra +0x12A8 /* 0000393A */
2696 pea.l [A6 - 0x20]
269A move.w -[A7], [A5 - 0x3C6]
269E move.w -[A7], [A5 - 0x3C4]
26A2 clr.w -[A7]
26A4 jsr [PC + 0x1438 /* 00003ADE */]
26A8 moveq.l D7, 0x08
label000026AA:
26AA pea.l [A6 - 0x18]
26AE move.w -[A7], 0x3
26B2 move.w -[A7], D7
26B4 jsr [PC + 0x156E /* 00003C24 */]
26B8 move.w -[A7], [A5 - 0x3C6]
26BC move.w -[A7], [A5 - 0x3C4]
26C0 jsr [PC + 0x128C /* 0000394E */]
26C4 pea.l [A6 - 0x18]
26C8 pea.l [A6 - 0x20]
26CC jsr [PC + 0x12E8 /* 000039B6 */]
26D0 pea.l [A6 - 0x20]
26D4 move.w -[A7], [A5 - 0x114]
26D8 jsr [PC + 0x1354 /* 00003A2E */]
26DC subq.w D7, 1
26DE cmpi.w D7, 0x7
26E2 bge -0x38 /* 000026AA */
26E4 clr.b [A5 - 0x3C2]
26E8 bra +0x1252 /* 0000393A */
26EC move.b [A5 - 0x3C2], 0x4
26F2 clr.b [A5 - 0x3C0]
26F6 pea.l [A6 - 0x20]
26FA move.w -[A7], [A5 - 0x3C6]
26FE move.w -[A7], [A5 - 0x3C4]
2702 clr.w -[A7]
2704 jsr [PC + 0x14B0 /* 00003BB6 */]
2708 moveq.l D7, 0x01
label0000270A:
270A pea.l [A6 - 0x18]
270E move.w -[A7], 0x4
2712 move.w D0, D7
2714 add.w D0, D0
2716 subq.w D0, 1
2718 move.w -[A7], D0
271A jsr [PC + 0x1584 /* 00003CA0 */]
271E move.w -[A7], [A5 - 0x3C6]
2722 move.w -[A7], [A5 - 0x3C4]
2726 jsr [PC + 0x1226 /* 0000394E */]
272A move.w -[A7], [A5 - 0x3C6]
272E move.w D0, [A5 - 0x3C4]
2732 addq.w D0, 1
2734 move.w -[A7], D0
2736 jsr [PC + 0x1216 /* 0000394E */]
273A pea.l [A6 - 0x18]
273E pea.l [A6 - 0x20]
2742 jsr [PC + 0x1272 /* 000039B6 */]
2746 pea.l [A6 - 0x20]
274A move.w -[A7], [A5 - 0x110]
274E jsr [PC + 0x12DE /* 00003A2E */]
2752 addq.w D7, 1
2754 cmpi.w D7, 0x4
2758 ble -0x4E /* 0000270A */
275A move.w D0, [A5 - 0x3C4]
275E addq.w D0, 1
2760 move.w [A5 - 0x3C4], D0
2764 cmpi.w [A5 - 0x3C4], 0xC
276A ble +0x11D0 /* 0000393A */
276E move.b [A5 - 0x3C2], 0x5
2774 move.w -[A7], 0x6E /* 'n' */
2778 jsr [PC - 0x23A8 /* 000003D2 */]
277C bra +0x11BE /* 0000393A */
2780 move.w D0, [A5 - 0x3C6]
2784 muls.w D0, 0xE
2788 move.w D1, [A5 - 0x3C4]
278C subq.w D1, 1
278E add.w D0, D1
2790 moveq.l D1, 0x00
2792 addi.w D0, 0xFC44
2796 move.b D1, [A5 + D0.w]
279A move.w -[A7], D1
279C pea.l [PC + 0x11AA /* 00003948, value 0xE201EA19 */]
27A0 pea.l [A6 - 0x48]
27A4 move.w -[A7], 0x2
27A8 jsr [PC - 0x2610 /* 0000019A */]
27AC pea.l [A6 - 0x48]
27B0 jsr [PC - 0x25CC /* 000001E6 */]
27B4 beq +0xEC /* 000028A0 */
27B8 clr.b [A5 - 0x3C0]
27BC pea.l [A6 - 0x20]
27C0 move.w -[A7], [A5 - 0x3C6]
27C4 move.w D0, [A5 - 0x3C4]
27C8 subq.w D0, 1
27CA move.w -[A7], D0
27CC clr.w -[A7]
27CE jsr [PC + 0x13E6 /* 00003BB6 */]
27D2 moveq.l D7, 0x03
label000027D4:
27D4 pea.l [A6 - 0x18]
27D8 move.w -[A7], 0x4
27DC move.w D0, D7
27DE add.w D0, D0
27E0 subq.w D0, 1
27E2 move.w -[A7], D0
27E4 jsr [PC + 0x14BA /* 00003CA0 */]
27E8 move.w -[A7], [A5 - 0x3C6]
27EC move.w D0, [A5 - 0x3C4]
27F0 subq.w D0, 1
27F2 move.w -[A7], D0
27F4 jsr [PC + 0x1158 /* 0000394E */]
27F8 move.w -[A7], [A5 - 0x3C6]
27FC move.w -[A7], [A5 - 0x3C4]
2800 jsr [PC + 0x114C /* 0000394E */]
2804 pea.l [A6 - 0x18]
2808 pea.l [A6 - 0x20]
280C jsr [PC + 0x11A8 /* 000039B6 */]
2810 pea.l [A6 - 0x20]
2814 move.w -[A7], [A5 - 0x114]
2818 jsr [PC + 0x1214 /* 00003A2E */]
281C subq.w D7, 1
281E cmpi.w D7, 0x1
2822 bge -0x4E /* 000027D4 */
2824 move.w D0, [A5 - 0x3C4]
2828 subq.w D0, 1
282A move.w [A5 - 0x3C4], D0
282E pea.l [A6 - 0x18]
2832 move.w -[A7], 0x4
2836 move.w -[A7], 0x8
283A jsr [PC + 0x13E8 /* 00003C24 */]
283E move.w -[A7], [A5 - 0x3C6]
2842 move.w -[A7], [A5 - 0x3C4]
2846 jsr [PC + 0x1106 /* 0000394E */]
284A move.w -[A7], [A5 - 0x3C6]
284E move.w D0, [A5 - 0x3C4]
2852 addq.w D0, 1
2854 move.w -[A7], D0
2856 jsr [PC + 0x10F6 /* 0000394E */]
285A pea.l [A6 - 0x20]
285E move.w -[A7], [A5 - 0x3C6]
2862 move.w -[A7], [A5 - 0x3C4]
2866 clr.w -[A7]
2868 jsr [PC + 0x1274 /* 00003ADE */]
286C pea.l [A6 - 0x18]
2870 pea.l [A6 - 0x20]
2874 jsr [PC + 0x1140 /* 000039B6 */]
2878 pea.l [A6 - 0x20]
287C move.w -[A7], [A5 - 0x3C6]
2880 move.w -[A7], [A5 - 0x3C4]
2884 clr.w -[A7]
2886 jsr [PC + 0x132E /* 00003BB6 */]
288A pea.l [A6 - 0x20]
288E move.w -[A7], [A5 - 0x110]
2892 jsr [PC + 0x119A /* 00003A2E */]
2896 move.b [A5 - 0x3C2], 0x4
289C bra +0x109E /* 0000393A */
label000028A0:
28A0 pea.l [A6 - 0x20]
28A4 move.w -[A7], [A5 - 0x3C6]
28A8 move.w -[A7], [A5 - 0x3C4]
28AC clr.w -[A7]
28AE jsr [PC + 0x122E /* 00003ADE */]
28B2 move.w -[A7], 0xCA
28B6 jsr [PC - 0x24E6 /* 000003D2 */]
28BA moveq.l D7, 0x04
label000028BC:
28BC pea.l [A6 - 0x18]
28C0 move.w -[A7], 0x6
28C4 move.w -[A7], D7
28C6 clr.w -[A7]
28C8 jsr [PC + 0x1214 /* 00003ADE */]
28CC pea.l [A6 - 0x18]
28D0 pea.l [A6 - 0x20]
28D4 jsr [PC + 0x1408 /* 00003CDE */]
28D8 pea.l [A6 - 0x18]
28DC move.w -[A7], 0x4
28E0 move.w -[A7], 0x8
28E4 jsr [PC + 0x133E /* 00003C24 */]
28E8 pea.l [A6 - 0x18]
28EC pea.l [A6 - 0x20]
28F0 jsr [PC + 0x10C4 /* 000039B6 */]
28F4 pea.l [A6 - 0x20]
28F8 move.w D0, [A5 - 0x114]
28FC add.w D0, D0
28FE move.w -[A7], D0
2900 jsr [PC + 0x112C /* 00003A2E */]
2904 addq.w D7, 1
2906 cmpi.w D7, 0x6
290A ble -0x4E /* 000028BC */
290C move.w D0, [A5 - 0x3C6]
2910 muls.w D0, 0xE
2914 move.w D1, [A5 - 0x3C4]
2918 add.w D0, D1
291A addi.w D0, 0xFC44
291E clr.b [A5 + D0.w]
2922 move.w -[A7], [A5 - 0x3C6]
2926 move.w -[A7], [A5 - 0x3C4]
292A jsr [PC + 0x1022 /* 0000394E */]
292E pea.l [A6 - 0x18]
2932 pea.l [A6 - 0x20]
2936 jsr [PC + 0x107E /* 000039B6 */]
293A pea.l [A6 - 0x20]
293E move.w D0, [A5 - 0x114]
2942 add.w D0, D0
2944 move.w -[A7], D0
2946 jsr [PC + 0x10E6 /* 00003A2E */]
294A move.b [A5 - 0x3C2], 0x4
2950 bra +0xFEA /* 0000393A */
2954 pea.l [A6 - 0x20]
2958 move.w -[A7], [A5 - 0x3C6]
295C move.w -[A7], [A5 - 0x3C4]
2960 clr.w -[A7]
2962 jsr [PC + 0x117A /* 00003ADE */]
2966 moveq.l D7, 0x01
label00002968:
2968 pea.l [A6 - 0x18]
296C move.w -[A7], 0x3
2970 move.w -[A7], D7
2972 jsr [PC + 0x12B0 /* 00003C24 */]
2976 move.w -[A7], [A5 - 0x3C6]
297A move.w -[A7], [A5 - 0x3C4]
297E jsr [PC + 0xFCE /* 0000394E */]
2982 pea.l [A6 - 0x18]
2986 pea.l [A6 - 0x20]
298A jsr [PC + 0x102A /* 000039B6 */]
298E pea.l [A6 - 0x20]
2992 move.w -[A7], [A5 - 0x114]
2996 jsr [PC + 0x1096 /* 00003A2E */]
299A addq.w D7, 1
299C cmpi.w D7, 0x6
29A0 ble -0x38 /* 00002968 */
29A2 tst.b [A5 - 0x3C1]
29A6 beq +0xA /* 000029B0 */
29A8 move.w D6, [A5 - 0x3C6]
29AC addq.w D6, 1
29AE bra +0x8 /* 000029B6 */
label000029B0:
29B0 move.w D6, [A5 - 0x3C6]
29B4 subq.w D6, 1
label000029B6:
29B6 move.w D0, D6
29B8 muls.w D0, 0xE
29BC move.w D1, [A5 - 0x3C4]
29C0 add.w D0, D1
29C2 addi.w D0, 0xFC44
29C6 move.b D0, [A5 + D0.w]
29CA bra +0x3BA /* 00002D84 */
label000029CE:
29CE move.w -[A7], 0xCB
29D2 jsr [PC - 0x2602 /* 000003D2 */]
29D6 pea.l [A6 - 0x20]
29DA move.w -[A7], D6
29DC move.w -[A7], [A5 - 0x3C4]
29E0 clr.w -[A7]
29E2 jsr [PC + 0x10FA /* 00003ADE */]
29E6 move.w D0, D6
29E8 muls.w D0, 0xE
29EC move.w D1, [A5 - 0x3C4]
29F0 add.w D0, D1
29F2 addi.w D0, 0xFC44
29F6 cmpi.b [A5 + D0.w], 0x7
29FC bne +0x2C /* 00002A28 */
29FE pea.l [A6 - 0x18]
2A02 move.w -[A7], 0x5
2A06 move.w -[A7], 0xB
2A0A clr.w -[A7]
2A0C jsr [PC + 0x10D0 /* 00003ADE */]
2A10 pea.l [A6 - 0x18]
2A14 pea.l [A6 - 0x20]
2A18 jsr [PC + 0x12C4 /* 00003CDE */]
2A1C pea.l [A6 - 0x20]
2A20 move.w -[A7], [A5 - 0x114]
2A24 jsr [PC + 0x1008 /* 00003A2E */]
label00002A28:
2A28 move.w D0, D6
2A2A muls.w D0, 0xE
2A2E move.w D1, [A5 - 0x3C4]
2A32 add.w D0, D1
2A34 addi.w D0, 0xFC44
2A38 clr.b [A5 + D0.w]
2A3C move.w -[A7], D6
2A3E move.w -[A7], [A5 - 0x3C4]
2A42 jsr [PC + 0xF0A /* 0000394E */]
2A46 pea.l [A6 - 0x20]
2A4A clr.w -[A7]
2A4C jsr [PC + 0xFE0 /* 00003A2E */]
2A50 bra +0x358 /* 00002DA8 */
label00002A54:
2A54 pea.l [A6 - 0x20]
2A58 move.w -[A7], D6
2A5A move.w -[A7], [A5 - 0x3C4]
2A5E clr.w -[A7]
2A60 jsr [PC + 0x107C /* 00003ADE */]
2A64 move.w -[A7], 0xD3
2A68 jsr [PC - 0x2698 /* 000003D2 */]
2A6C moveq.l D7, 0x04
label00002A6E:
2A6E pea.l [A6 - 0x18]
2A72 move.w -[A7], 0x4
2A76 move.w -[A7], D7
2A78 clr.w -[A7]
2A7A jsr [PC + 0x1062 /* 00003ADE */]
2A7E pea.l [A6 - 0x18]
2A82 pea.l [A6 - 0x20]
2A86 jsr [PC + 0x1256 /* 00003CDE */]
2A8A pea.l [A6 - 0x20]
2A8E move.w -[A7], [A5 - 0x114]
2A92 jsr [PC + 0xF9A /* 00003A2E */]
2A96 addq.w D7, 1
2A98 cmpi.w D7, 0x9 /* '\t' */
2A9C ble -0x2E /* 00002A6E */
2A9E move.w D0, D6
2AA0 muls.w D0, 0xE
2AA4 move.w D1, [A5 - 0x3C4]
2AA8 add.w D0, D1
2AAA addi.w D0, 0xFC44
2AAE clr.b [A5 + D0.w]
2AB2 move.w -[A7], D6
2AB4 move.w -[A7], [A5 - 0x3C4]
2AB8 jsr [PC + 0xE94 /* 0000394E */]
2ABC pea.l [A6 - 0x20]
2AC0 clr.w -[A7]
2AC2 jsr [PC + 0xF6A /* 00003A2E */]
2AC6 bra +0x2E2 /* 00002DA8 */
label00002ACA:
2ACA pea.l [A6 - 0x20]
2ACE move.w -[A7], D6
2AD0 move.w -[A7], [A5 - 0x3C4]
2AD4 clr.w -[A7]
2AD6 jsr [PC + 0x1006 /* 00003ADE */]
2ADA tst.b [A5 - 0x3C1]
2ADE beq +0x92 /* 00002B70 */
2AE2 pea.l [A6 - 0x18]
2AE6 move.w -[A7], 0x2
2AEA move.w -[A7], 0xB
2AEE clr.w -[A7]
2AF0 jsr [PC + 0xFEC /* 00003ADE */]
2AF4 move.w [A6 - 0x1A], [A6 - 0x1E]
2AFA move.w [A6 - 0x16], [A6 - 0x12]
2B00 move.w -[A7], 0xCF
2B04 jsr [PC - 0x2734 /* 000003D2 */]
2B08 moveq.l D7, 0x01
label00002B0A:
2B0A move.w D0, [A6 - 0x16]
2B0E subq.w D0, 5
2B10 move.w [A6 - 0x16], D0
2B14 move.w D0, [A6 - 0x1A]
2B18 addq.w D0, 5
2B1A move.w [A6 - 0x1A], D0
2B1E pea.l [A6 - 0x18]
2B22 pea.l [A6 - 0x20]
2B26 jsr [PC + 0x11B6 /* 00003CDE */]
2B2A pea.l [A6 - 0x20]
2B2E move.w -[A7], [A5 - 0x10E]
2B32 jsr [PC + 0xEFA /* 00003A2E */]
2B36 addq.w D7, 1
2B38 cmpi.w D7, 0x8
2B3C ble -0x32 /* 00002B0A */
2B3E moveq.l D7, 0x01
label00002B40:
2B40 pea.l [A6 - 0x18]
2B44 move.w -[A7], 0xFFFB
2B48 clr.w -[A7]
2B4A syscall OffsetRect
2B4C pea.l [A6 - 0x18]
2B50 pea.l [A6 - 0x20]
2B54 jsr [PC + 0x1188 /* 00003CDE */]
2B58 pea.l [A6 - 0x20]
2B5C move.w -[A7], [A5 - 0x10E]
2B60 jsr [PC + 0xECC /* 00003A2E */]
2B64 addq.w D7, 1
2B66 cmpi.w D7, 0x8
2B6A ble -0x2A /* 00002B40 */
2B6C bra +0x8E /* 00002BFA */
label00002B70:
2B70 pea.l [A6 - 0x18]
2B74 move.w -[A7], 0x2
2B78 move.w -[A7], 0x1
2B7C clr.w -[A7]
2B7E jsr [PC + 0xF5E /* 00003ADE */]
2B82 move.w [A6 - 0x1E], [A6 - 0x1A]
2B88 move.w [A6 - 0x12], [A6 - 0x16]
2B8E move.w -[A7], 0xCF
2B92 jsr [PC - 0x27C2 /* 000003D2 */]
2B96 moveq.l D7, 0x01
label00002B98:
2B98 move.w D0, [A6 - 0x12]
2B9C addq.w D0, 5
2B9E move.w [A6 - 0x12], D0
2BA2 move.w D0, [A6 - 0x1E]
2BA6 subq.w D0, 5
2BA8 move.w [A6 - 0x1E], D0
2BAC pea.l [A6 - 0x18]
2BB0 pea.l [A6 - 0x20]
2BB4 jsr [PC + 0x1128 /* 00003CDE */]
2BB8 pea.l [A6 - 0x20]
2BBC move.w -[A7], [A5 - 0x10E]
2BC0 jsr [PC + 0xE6C /* 00003A2E */]
2BC4 addq.w D7, 1
2BC6 cmpi.w D7, 0x8
2BCA ble -0x32 /* 00002B98 */
2BCC moveq.l D7, 0x01
label00002BCE:
2BCE pea.l [A6 - 0x18]
2BD2 move.w -[A7], 0x5
2BD6 clr.w -[A7]
2BD8 syscall OffsetRect
2BDA pea.l [A6 - 0x18]
2BDE pea.l [A6 - 0x20]
2BE2 jsr [PC + 0x10FA /* 00003CDE */]
2BE6 pea.l [A6 - 0x20]
2BEA move.w -[A7], [A5 - 0x10E]
2BEE jsr [PC + 0xE3E /* 00003A2E */]
2BF2 addq.w D7, 1
2BF4 cmpi.w D7, 0x8
2BF8 ble -0x2A /* 00002BCE */
label00002BFA:
2BFA move.w D0, D6
2BFC muls.w D0, 0xE
2C00 move.w D1, [A5 - 0x3C4]
2C04 add.w D0, D1
2C06 addi.w D0, 0xFC44
2C0A move.b [A5 + D0.w], 0x5
2C10 move.w D0, D6
2C12 muls.w D0, 0xE
2C16 move.w D1, [A5 - 0x3C4]
2C1A addq.w D1, 1
2C1C add.w D0, D1
2C1E addi.w D0, 0xFC44
2C22 cmpi.b [A5 + D0.w], 0x8
2C28 bne +0x180 /* 00002DA8 */
2C2C pea.l [A6 - 0x20]
2C30 move.w -[A7], D6
2C32 move.w -[A7], [A5 - 0x3C4]
2C36 clr.w -[A7]
2C38 jsr [PC + 0xEA4 /* 00003ADE */]
2C3C moveq.l D7, 0x07
label00002C3E:
2C3E pea.l [A6 - 0x18]
2C42 move.w -[A7], 0x3
2C46 move.w -[A7], D7
2C48 clr.w -[A7]
2C4A jsr [PC + 0xE92 /* 00003ADE */]
2C4E pea.l [A6 - 0x18]
2C52 pea.l [A6 - 0x20]
2C56 jsr [PC + 0x1086 /* 00003CDE */]
2C5A pea.l [A6 - 0x20]
2C5E move.w -[A7], [A5 - 0x114]
2C62 jsr [PC + 0xDCA /* 00003A2E */]
2C66 addq.w D7, 1
2C68 cmpi.w D7, 0xA /* '\n' */
2C6C ble -0x2E /* 00002C3E */
2C6E move.w D0, D6
2C70 muls.w D0, 0xE
2C74 move.w D1, [A5 - 0x3C4]
2C78 add.w D0, D1
2C7A addi.w D0, 0xFC44
2C7E clr.b [A5 + D0.w]
2C82 move.w -[A7], D6
2C84 move.w -[A7], [A5 - 0x3C4]
2C88 jsr [PC + 0xCC4 /* 0000394E */]
2C8C pea.l [A6 - 0x20]
2C90 clr.w -[A7]
2C92 jsr [PC + 0xD9A /* 00003A2E */]
2C96 bra +0x112 /* 00002DA8 */
label00002C9A:
2C9A pea.l [A6 - 0x20]
2C9E move.w -[A7], D6
2CA0 move.w -[A7], [A5 - 0x3C4]
2CA4 clr.w -[A7]
2CA6 jsr [PC + 0xE36 /* 00003ADE */]
2CAA move.w -[A7], 0xD6
2CAE jsr [PC - 0x28DE /* 000003D2 */]
2CB2 moveq.l D7, 0x02
label00002CB4:
2CB4 pea.l [A6 - 0x18]
2CB8 move.w -[A7], 0x3
2CBC move.w -[A7], D7
2CBE clr.w -[A7]
2CC0 jsr [PC + 0xE1C /* 00003ADE */]
2CC4 pea.l [A6 - 0x18]
2CC8 pea.l [A6 - 0x20]
2CCC jsr [PC + 0x1010 /* 00003CDE */]
2CD0 pea.l [A6 - 0x20]
2CD4 move.w -[A7], [A5 - 0x114]
2CD8 jsr [PC + 0xD54 /* 00003A2E */]
2CDC addq.w D7, 1
2CDE cmpi.w D7, 0x6
2CE2 ble -0x2E /* 00002CB4 */
2CE4 move.w D0, D6
2CE6 muls.w D0, 0xE
2CEA move.w D1, [A5 - 0x3C4]
2CEE add.w D0, D1
2CF0 addi.w D0, 0xFC44
2CF4 clr.b [A5 + D0.w]
2CF8 move.w -[A7], D6
2CFA move.w -[A7], [A5 - 0x3C4]
2CFE jsr [PC + 0xC4E /* 0000394E */]
2D02 pea.l [A6 - 0x20]
2D06 clr.w -[A7]
2D08 jsr [PC + 0xD24 /* 00003A2E */]
2D0C bra +0x9C /* 00002DA8 */
label00002D10:
2D10 pea.l [A6 - 0x20]
2D14 move.w -[A7], D6
2D16 move.w -[A7], [A5 - 0x3C4]
2D1A clr.w -[A7]
2D1C jsr [PC + 0xDC0 /* 00003ADE */]
2D20 move.w -[A7], 0xD6
2D24 jsr [PC - 0x2954 /* 000003D2 */]
2D28 moveq.l D7, 0x07
label00002D2A:
2D2A pea.l [A6 - 0x18]
2D2E move.w -[A7], 0x3
2D32 move.w -[A7], D7
2D34 clr.w -[A7]
2D36 jsr [PC + 0xDA6 /* 00003ADE */]
2D3A pea.l [A6 - 0x18]
2D3E pea.l [A6 - 0x20]
2D42 jsr [PC + 0xF9A /* 00003CDE */]
2D46 pea.l [A6 - 0x20]
2D4A move.w -[A7], [A5 - 0x114]
2D4E jsr [PC + 0xCDE /* 00003A2E */]
2D52 addq.w D7, 1
2D54 cmpi.w D7, 0xA /* '\n' */
2D58 ble -0x2E /* 00002D2A */
2D5A move.w D0, D6
2D5C muls.w D0, 0xE
2D60 move.w D1, [A5 - 0x3C4]
2D64 add.w D0, D1
2D66 addi.w D0, 0xFC44
2D6A clr.b [A5 + D0.w]
2D6E move.w -[A7], D6
2D70 move.w -[A7], [A5 - 0x3C4]
2D74 jsr [PC + 0xBD8 /* 0000394E */]
2D78 pea.l [A6 - 0x20]
2D7C clr.w -[A7]
2D7E jsr [PC + 0xCAE /* 00003A2E */]
2D82 bra +0x26 /* 00002DA8 */
label00002D84:
2D84 beq -0x2BA /* 00002ACA */
2D88 subq.b D0, 1
2D8A beq -0xF0 /* 00002C9A */
2D8E subq.b D0, 4
2D90 beq -0x80 /* 00002D10 */
2D94 subq.b D0, 1
2D96 beq -0x342 /* 00002A54 */
2D9A subq.b D0, 1
2D9C beq -0x3CE /* 000029CE */
2DA0 move.w -[A7], 0xD0
2DA4 jsr [PC - 0x29D4 /* 000003D2 */]
label00002DA8:
2DA8 pea.l [A6 - 0x20]
2DAC move.w -[A7], [A5 - 0x3C6]
2DB0 move.w -[A7], [A5 - 0x3C4]
2DB4 clr.w -[A7]
2DB6 jsr [PC + 0xD26 /* 00003ADE */]
2DBA moveq.l D7, 0x06
label00002DBC:
2DBC pea.l [A6 - 0x18]
2DC0 move.w -[A7], 0x3
2DC4 move.w -[A7], D7
2DC6 jsr [PC + 0xE5C /* 00003C24 */]
2DCA move.w -[A7], [A5 - 0x3C6]
2DCE move.w -[A7], [A5 - 0x3C4]
2DD2 jsr [PC + 0xB7A /* 0000394E */]
2DD6 pea.l [A6 - 0x18]
2DDA pea.l [A6 - 0x20]
2DDE jsr [PC + 0xBD6 /* 000039B6 */]
2DE2 pea.l [A6 - 0x20]
2DE6 move.w -[A7], [A5 - 0x114]
2DEA jsr [PC + 0xC42 /* 00003A2E */]
2DEE subq.w D7, 1
2DF0 cmpi.w D7, 0x1
2DF4 bge -0x38 /* 00002DBC */
2DF6 clr.b [A5 - 0x3C2]
2DFA bra +0xB40 /* 0000393A */
2DFE move.w D0, [A5 - 0x3C6]
2E02 muls.w D0, 0xE
2E06 move.w D1, [A5 - 0x3C4]
2E0A addq.w D1, 1
2E0C add.w D0, D1
2E0E addi.w D0, 0xFC44
2E12 cmpi.b [A5 + D0.w], 0x6
2E18 bne +0xD0 /* 00002EE8 */
2E1C pea.l [A6 - 0x20]
2E20 move.w -[A7], [A5 - 0x3C6]
2E24 move.w -[A7], [A5 - 0x3C4]
2E28 clr.w -[A7]
2E2A jsr [PC + 0xCB2 /* 00003ADE */]
2E2E pea.l [A6 - 0x18]
2E32 move.w -[A7], 0x3
2E36 move.w -[A7], 0x9 /* '\t' */
2E3A jsr [PC + 0xDE8 /* 00003C24 */]
2E3E move.w -[A7], 0xD3
2E42 jsr [PC - 0x2A72 /* 000003D2 */]
2E46 move.w -[A7], [A5 - 0x3C6]
2E4A move.w -[A7], [A5 - 0x3C4]
2E4E jsr [PC + 0xAFE /* 0000394E */]
2E52 pea.l [A6 - 0x18]
2E56 pea.l [A6 - 0x20]
2E5A jsr [PC + 0xB5A /* 000039B6 */]
2E5E pea.l [A6 - 0x20]
2E62 move.w -[A7], [A5 - 0x114]
2E66 jsr [PC + 0xBC6 /* 00003A2E */]
2E6A pea.l [A6 - 0x20]
2E6E move.w -[A7], [A5 - 0x3C6]
2E72 move.w D0, [A5 - 0x3C4]
2E76 addq.w D0, 1
2E78 move.w -[A7], D0
2E7A clr.w -[A7]
2E7C jsr [PC + 0xC60 /* 00003ADE */]
2E80 moveq.l D7, 0x04
label00002E82:
2E82 pea.l [A6 - 0x18]
2E86 move.w -[A7], 0x4
2E8A move.w -[A7], D7
2E8C clr.w -[A7]
2E8E jsr [PC + 0xC4E /* 00003ADE */]
2E92 pea.l [A6 - 0x18]
2E96 pea.l [A6 - 0x20]
2E9A jsr [PC + 0xE42 /* 00003CDE */]
2E9E pea.l [A6 - 0x20]
2EA2 move.w -[A7], [A5 - 0x114]
2EA6 jsr [PC + 0xB86 /* 00003A2E */]
2EAA addq.w D7, 1
2EAC cmpi.w D7, 0x9 /* '\t' */
2EB0 ble -0x2E /* 00002E82 */
2EB2 move.w D0, [A5 - 0x3C6]
2EB6 muls.w D0, 0xE
2EBA move.w D1, [A5 - 0x3C4]
2EBE addq.w D1, 1
2EC0 add.w D0, D1
2EC2 addi.w D0, 0xFC44
2EC6 clr.b [A5 + D0.w]
2ECA move.w -[A7], [A5 - 0x3C6]
2ECE move.w D0, [A5 - 0x3C4]
2ED2 addq.w D0, 1
2ED4 move.w -[A7], D0
2ED6 jsr [PC + 0xA76 /* 0000394E */]
2EDA pea.l [A6 - 0x20]
2EDE clr.w -[A7]
2EE0 jsr [PC + 0xB4C /* 00003A2E */]
2EE4 bra +0xA56 /* 0000393A */
label00002EE8:
2EE8 pea.l [A6 - 0x20]
2EEC move.w -[A7], [A5 - 0x3C6]
2EF0 move.w -[A7], [A5 - 0x3C4]
2EF4 clr.w -[A7]
2EF6 jsr [PC + 0xBE6 /* 00003ADE */]
2EFA moveq.l D7, 0x01
label00002EFC:
2EFC pea.l [A6 - 0x18]
2F00 move.w -[A7], 0x5
2F04 move.w -[A7], D7
2F06 jsr [PC + 0xD1C /* 00003C24 */]
2F0A move.w -[A7], [A5 - 0x3C6]
2F0E move.w -[A7], [A5 - 0x3C4]
2F12 jsr [PC + 0xA3A /* 0000394E */]
2F16 pea.l [A6 - 0x18]
2F1A pea.l [A6 - 0x20]
2F1E jsr [PC + 0xA96 /* 000039B6 */]
2F22 pea.l [A6 - 0x20]
2F26 move.w -[A7], [A5 - 0x114]
2F2A jsr [PC + 0xB02 /* 00003A2E */]
2F2E addq.w D7, 1
2F30 cmpi.w D7, 0x4
2F34 ble -0x38 /* 00002EFC */
2F36 tst.b [A5 - 0x3C1]
2F3A beq +0xA /* 00002F44 */
2F3C move.w D6, [A5 - 0x3C6]
2F40 addq.w D6, 1
2F42 bra +0x8 /* 00002F4A */
label00002F44:
2F44 move.w D6, [A5 - 0x3C6]
2F48 subq.w D6, 1
label00002F4A:
2F4A move.w D0, D6
2F4C muls.w D0, 0xE
2F50 move.w D1, [A5 - 0x3C4]
2F54 addq.w D1, 1
2F56 add.w D0, D1
2F58 addi.w D0, 0xFC44
2F5C move.b D0, [A5 + D0.w]
2F60 bra +0x370 /* 000032D0 */
label00002F64:
2F64 pea.l [A6 - 0x20]
2F68 move.w -[A7], D6
2F6A move.w D0, [A5 - 0x3C4]
2F6E addq.w D0, 1
2F70 move.w -[A7], D0
2F72 clr.w -[A7]
2F74 jsr [PC + 0xB68 /* 00003ADE */]
2F78 tst.b [A5 - 0x3C1]
2F7C beq +0x92 /* 0000300E */
2F80 pea.l [A6 - 0x18]
2F84 move.w -[A7], 0x2
2F88 move.w -[A7], 0xB
2F8C clr.w -[A7]
2F8E jsr [PC + 0xB4E /* 00003ADE */]
2F92 move.w [A6 - 0x1A], [A6 - 0x1E]
2F98 move.w [A6 - 0x16], [A6 - 0x12]
2F9E move.w -[A7], 0xCF
2FA2 jsr [PC - 0x2BD2 /* 000003D2 */]
2FA6 moveq.l D7, 0x01
label00002FA8:
2FA8 move.w D0, [A6 - 0x16]
2FAC subq.w D0, 5
2FAE move.w [A6 - 0x16], D0
2FB2 move.w D0, [A6 - 0x1A]
2FB6 addq.w D0, 5
2FB8 move.w [A6 - 0x1A], D0
2FBC pea.l [A6 - 0x18]
2FC0 pea.l [A6 - 0x20]
2FC4 jsr [PC + 0xD18 /* 00003CDE */]
2FC8 pea.l [A6 - 0x20]
2FCC move.w -[A7], [A5 - 0x10E]
2FD0 jsr [PC + 0xA5C /* 00003A2E */]
2FD4 addq.w D7, 1
2FD6 cmpi.w D7, 0x8
2FDA ble -0x32 /* 00002FA8 */
2FDC moveq.l D7, 0x01
label00002FDE:
2FDE pea.l [A6 - 0x18]
2FE2 move.w -[A7], 0xFFFB
2FE6 clr.w -[A7]
2FE8 syscall OffsetRect
2FEA pea.l [A6 - 0x18]
2FEE pea.l [A6 - 0x20]
2FF2 jsr [PC + 0xCEA /* 00003CDE */]
2FF6 pea.l [A6 - 0x20]
2FFA move.w -[A7], [A5 - 0x10E]
2FFE jsr [PC + 0xA2E /* 00003A2E */]
3002 addq.w D7, 1
3004 cmpi.w D7, 0x8
3008 ble -0x2A /* 00002FDE */
300A bra +0x8E /* 00003098 */
label0000300E:
300E pea.l [A6 - 0x18]
3012 move.w -[A7], 0x2
3016 move.w -[A7], 0x1
301A clr.w -[A7]
301C jsr [PC + 0xAC0 /* 00003ADE */]
3020 move.w [A6 - 0x1E], [A6 - 0x1A]
3026 move.w [A6 - 0x12], [A6 - 0x16]
302C move.w -[A7], 0xCF
3030 jsr [PC - 0x2C60 /* 000003D2 */]
3034 moveq.l D7, 0x01
label00003036:
3036 move.w D0, [A6 - 0x12]
303A addq.w D0, 5
303C move.w [A6 - 0x12], D0
3040 move.w D0, [A6 - 0x1E]
3044 subq.w D0, 5
3046 move.w [A6 - 0x1E], D0
304A pea.l [A6 - 0x18]
304E pea.l [A6 - 0x20]
3052 jsr [PC + 0xC8A /* 00003CDE */]
3056 pea.l [A6 - 0x20]
305A move.w -[A7], [A5 - 0x10E]
305E jsr [PC + 0x9CE /* 00003A2E */]
3062 addq.w D7, 1
3064 cmpi.w D7, 0x8
3068 ble -0x32 /* 00003036 */
306A moveq.l D7, 0x01
label0000306C:
306C pea.l [A6 - 0x18]
3070 move.w -[A7], 0x5
3074 clr.w -[A7]
3076 syscall OffsetRect
3078 pea.l [A6 - 0x18]
307C pea.l [A6 - 0x20]
3080 jsr [PC + 0xC5C /* 00003CDE */]
3084 pea.l [A6 - 0x20]
3088 move.w -[A7], [A5 - 0x10E]
308C jsr [PC + 0x9A0 /* 00003A2E */]
3090 addq.w D7, 1
3092 cmpi.w D7, 0x8
3096 ble -0x2A /* 0000306C */
label00003098:
3098 move.w D0, D6
309A muls.w D0, 0xE
309E move.w D1, [A5 - 0x3C4]
30A2 addq.w D1, 1
30A4 add.w D0, D1
30A6 addi.w D0, 0xFC44
30AA move.b [A5 + D0.w], 0x5
30B0 move.w D0, [A5 - 0x3C4]
30B4 addq.w D0, 2
30B6 cmpi.w D0, 0xD /* '\r' */
30BA bge +0x234 /* 000032EE */
30BE move.w D0, D6
30C0 muls.w D0, 0xE
30C4 move.w D1, [A5 - 0x3C4]
30C8 addq.w D1, 2
30CA add.w D0, D1
30CC addi.w D0, 0xFC44
30D0 cmpi.b [A5 + D0.w], 0x8
30D6 bne +0x218 /* 000032EE */
30DA pea.l [A6 - 0x20]
30DE move.w -[A7], D6
30E0 move.w D0, [A5 - 0x3C4]
30E4 addq.w D0, 1
30E6 move.w -[A7], D0
30E8 clr.w -[A7]
30EA jsr [PC + 0x9F2 /* 00003ADE */]
30EE moveq.l D7, 0x07
label000030F0:
30F0 pea.l [A6 - 0x18]
30F4 move.w -[A7], 0x3
30F8 move.w -[A7], D7
30FA clr.w -[A7]
30FC jsr [PC + 0x9E0 /* 00003ADE */]
3100 pea.l [A6 - 0x18]
3104 pea.l [A6 - 0x20]
3108 jsr [PC + 0xBD4 /* 00003CDE */]
310C pea.l [A6 - 0x20]
3110 move.w -[A7], [A5 - 0x114]
3114 jsr [PC + 0x918 /* 00003A2E */]
3118 addq.w D7, 1
311A cmpi.w D7, 0xA /* '\n' */
311E ble -0x2E /* 000030F0 */
3120 move.w D0, D6
3122 muls.w D0, 0xE
3126 move.w D1, [A5 - 0x3C4]
312A addq.w D1, 1
312C add.w D0, D1
312E addi.w D0, 0xFC44
3132 clr.b [A5 + D0.w]
3136 move.w -[A7], D6
3138 move.w D0, [A5 - 0x3C4]
313C addq.w D0, 1
313E move.w -[A7], D0
3140 jsr [PC + 0x80C /* 0000394E */]
3144 pea.l [A6 - 0x20]
3148 clr.w -[A7]
314A jsr [PC + 0x8E2 /* 00003A2E */]
314E bra +0x1A0 /* 000032EE */
label00003152:
3152 pea.l [A6 - 0x20]
3156 move.w -[A7], D6
3158 move.w D0, [A5 - 0x3C4]
315C addq.w D0, 1
315E move.w -[A7], D0
3160 clr.w -[A7]
3162 jsr [PC + 0x97A /* 00003ADE */]
3166 move.w -[A7], 0xD3
316A jsr [PC - 0x2D9A /* 000003D2 */]
316E moveq.l D7, 0x04
label00003170:
3170 pea.l [A6 - 0x18]
3174 move.w -[A7], 0x4
3178 move.w -[A7], D7
317A clr.w -[A7]
317C jsr [PC + 0x960 /* 00003ADE */]
3180 pea.l [A6 - 0x18]
3184 pea.l [A6 - 0x20]
3188 jsr [PC + 0xB54 /* 00003CDE */]
318C pea.l [A6 - 0x20]
3190 move.w -[A7], [A5 - 0x114]
3194 jsr [PC + 0x898 /* 00003A2E */]
3198 addq.w D7, 1
319A cmpi.w D7, 0x9 /* '\t' */
319E ble -0x2E /* 00003170 */
31A0 move.w D0, D6
31A2 muls.w D0, 0xE
31A6 move.w D1, [A5 - 0x3C4]
31AA addq.w D1, 1
31AC add.w D0, D1
31AE addi.w D0, 0xFC44
31B2 clr.b [A5 + D0.w]
31B6 move.w -[A7], D6
31B8 move.w D0, [A5 - 0x3C4]
31BC addq.w D0, 1
31BE move.w -[A7], D0
31C0 jsr [PC + 0x78C /* 0000394E */]
31C4 pea.l [A6 - 0x20]
31C8 clr.w -[A7]
31CA jsr [PC + 0x862 /* 00003A2E */]
31CE bra +0x120 /* 000032EE */
label000031D2:
31D2 pea.l [A6 - 0x20]
31D6 move.w -[A7], D6
31D8 move.w D0, [A5 - 0x3C4]
31DC addq.w D0, 1
31DE move.w -[A7], D0
31E0 clr.w -[A7]
31E2 jsr [PC + 0x8FA /* 00003ADE */]
31E6 move.w -[A7], 0xD6
31EA jsr [PC - 0x2E1A /* 000003D2 */]
31EE moveq.l D7, 0x02
label000031F0:
31F0 pea.l [A6 - 0x18]
31F4 move.w -[A7], 0x3
31F8 move.w -[A7], D7
31FA clr.w -[A7]
31FC jsr [PC + 0x8E0 /* 00003ADE */]
3200 pea.l [A6 - 0x18]
3204 pea.l [A6 - 0x20]
3208 jsr [PC + 0xAD4 /* 00003CDE */]
320C pea.l [A6 - 0x20]
3210 move.w -[A7], [A5 - 0x114]
3214 jsr [PC + 0x818 /* 00003A2E */]
3218 addq.w D7, 1
321A cmpi.w D7, 0x6
321E ble -0x2E /* 000031F0 */
3220 move.w D0, D6
3222 muls.w D0, 0xE
3226 move.w D1, [A5 - 0x3C4]
322A addq.w D1, 1
322C add.w D0, D1
322E addi.w D0, 0xFC44
3232 clr.b [A5 + D0.w]
3236 move.w -[A7], D6
3238 move.w D0, [A5 - 0x3C4]
323C addq.w D0, 1
323E move.w -[A7], D0
3240 jsr [PC + 0x70C /* 0000394E */]
3244 pea.l [A6 - 0x20]
3248 clr.w -[A7]
324A jsr [PC + 0x7E2 /* 00003A2E */]
324E bra +0xA0 /* 000032EE */
label00003252:
3252 pea.l [A6 - 0x20]
3256 move.w -[A7], D6
3258 move.w D0, [A5 - 0x3C4]
325C addq.w D0, 1
325E move.w -[A7], D0
3260 clr.w -[A7]
3262 jsr [PC + 0x87A /* 00003ADE */]
3266 move.w -[A7], 0xD6
326A jsr [PC - 0x2E9A /* 000003D2 */]
326E moveq.l D7, 0x07
label00003270:
3270 pea.l [A6 - 0x18]
3274 move.w -[A7], 0x3
3278 move.w -[A7], D7
327A clr.w -[A7]
327C jsr [PC + 0x860 /* 00003ADE */]
3280 pea.l [A6 - 0x18]
3284 pea.l [A6 - 0x20]
3288 jsr [PC + 0xA54 /* 00003CDE */]
328C pea.l [A6 - 0x20]
3290 move.w -[A7], [A5 - 0x114]
3294 jsr [PC + 0x798 /* 00003A2E */]
3298 addq.w D7, 1
329A cmpi.w D7, 0xA /* '\n' */
329E ble -0x2E /* 00003270 */
32A0 move.w D0, D6
32A2 muls.w D0, 0xE
32A6 move.w D1, [A5 - 0x3C4]
32AA addq.w D1, 1
32AC add.w D0, D1
32AE addi.w D0, 0xFC44
32B2 clr.b [A5 + D0.w]
32B6 move.w -[A7], D6
32B8 move.w D0, [A5 - 0x3C4]
32BC addq.w D0, 1
32BE move.w -[A7], D0
32C0 jsr [PC + 0x68C /* 0000394E */]
32C4 pea.l [A6 - 0x20]
32C8 clr.w -[A7]
32CA jsr [PC + 0x762 /* 00003A2E */]
32CE bra +0x20 /* 000032EE */
label000032D0:
32D0 beq -0x36C /* 00002F64 */
32D4 subq.b D0, 1
32D6 beq -0x104 /* 000031D2 */
32DA subq.b D0, 4
32DC beq -0x8A /* 00003252 */
32E0 subq.b D0, 1
32E2 beq -0x190 /* 00003152 */
32E6 move.w -[A7], 0xD0
32EA jsr [PC - 0x2F1A /* 000003D2 */]
label000032EE:
32EE pea.l [A6 - 0x20]
32F2 move.w -[A7], [A5 - 0x3C6]
32F6 move.w -[A7], [A5 - 0x3C4]
32FA clr.w -[A7]
32FC jsr [PC + 0x7E0 /* 00003ADE */]
3300 moveq.l D7, 0x04
label00003302:
3302 pea.l [A6 - 0x18]
3306 move.w -[A7], 0x5
330A move.w -[A7], D7
330C jsr [PC + 0x916 /* 00003C24 */]
3310 move.w -[A7], [A5 - 0x3C6]
3314 move.w -[A7], [A5 - 0x3C4]
3318 jsr [PC + 0x634 /* 0000394E */]
331C pea.l [A6 - 0x18]
3320 pea.l [A6 - 0x20]
3324 jsr [PC + 0x690 /* 000039B6 */]
3328 pea.l [A6 - 0x20]
332C move.w -[A7], [A5 - 0x114]
3330 jsr [PC + 0x6FC /* 00003A2E */]
3334 subq.w D7, 1
3336 cmpi.w D7, 0x1
333A bge -0x38 /* 00003302 */
333C move.b [A5 - 0x3C2], 0x3
3342 bra +0x5F8 /* 0000393A */
3346 pea.l [A6 - 0x20]
334A move.w -[A7], [A5 - 0x3C6]
334E move.w -[A7], [A5 - 0x3C4]
3352 clr.w -[A7]
3354 jsr [PC + 0x788 /* 00003ADE */]
3358 moveq.l D7, 0x05
label0000335A:
335A pea.l [A6 - 0x18]
335E move.w -[A7], 0x5
3362 move.w -[A7], D7
3364 jsr [PC + 0x8BE /* 00003C24 */]
3368 move.w -[A7], [A5 - 0x3C6]
336C move.w -[A7], [A5 - 0x3C4]
3370 jsr [PC + 0x5DC /* 0000394E */]
3374 pea.l [A6 - 0x18]
3378 pea.l [A6 - 0x20]
337C jsr [PC + 0x638 /* 000039B6 */]
3380 pea.l [A6 - 0x20]
3384 move.w -[A7], [A5 - 0x114]
3388 jsr [PC + 0x6A4 /* 00003A2E */]
338C addq.w D7, 1
338E cmpi.w D7, 0x7
3392 ble -0x38 /* 0000335A */
3394 move.w D0, [A5 - 0x3C6]
3398 muls.w D0, 0xE
339C move.w D1, [A5 - 0x3C4]
33A0 add.w D0, D1
33A2 addi.w D0, 0xFC44
33A6 tst.b [A5 + D0.w]
33AA seq D0
33AC move.w D1, [A5 - 0x3C6]
33B0 muls.w D1, 0xE
33B4 move.w D2, [A5 - 0x3C4]
33B8 subq.w D2, 1
33BA add.w D1, D2
33BC moveq.l D2, 0x00
33BE addi.w D1, 0xFC44
33C2 move.b D2, [A5 + D1.w]
33C6 move.w -[A7], D2
33C8 pea.l [PC + 0x57C /* 00003946, value 0xC201E201 */]
33CC pea.l [A6 - 0x48]
33D0 move.w -[A7], 0x2
33D4 jsr [PC - 0x323C /* 0000019A */]
33D8 pea.l [A6 - 0x48]
33DC jsr [PC - 0x31F8 /* 000001E6 */]
33E0 sne D1
33E2 and.b D0, D1
33E4 move.w D1, [A5 - 0x3C6]
33E8 muls.w D1, 0xE
33EC move.w D2, [A5 - 0x3C4]
33F0 addq.w D2, 1
33F2 add.w D1, D2
33F4 addi.w D1, 0xFC44
33F8 cmpi.b [A5 + D1.w], 0x6
33FE sne D1
3400 and.b D0, D1
3402 beq +0x9E /* 000034A0 */
3406 move.w -[A7], 0xD1
340A jsr [PC - 0x303A /* 000003D2 */]
340E pea.l [A6 - 0x20]
3412 move.w -[A7], [A5 - 0x3C6]
3416 move.w D0, [A5 - 0x3C4]
341A subq.w D0, 1
341C move.w -[A7], D0
341E clr.w -[A7]
3420 jsr [PC + 0x794 /* 00003BB6 */]
3424 pea.l [A6 - 0x18]
3428 move.w -[A7], 0x4
342C move.w -[A7], 0x1
3430 clr.w -[A7]
3432 jsr [PC + 0x782 /* 00003BB6 */]
3436 move.b D0, [A5 - 0x3C1]
343A subq.b D0, 1
343C beq +0xE /* 0000344A */
343E pea.l [A6 - 0x18]
3442 move.w -[A7], 0x28 /* '(' */
3446 clr.w -[A7]
3448 syscall OffsetRect
label0000344A:
344A moveq.l D7, 0x01
label0000344C:
344C pea.l [A6 - 0x18]
3450 clr.w -[A7]
3452 move.w -[A7], 0x5
3456 syscall OffsetRect
3458 pea.l [A6 - 0x18]
345C pea.l [A6 - 0x20]
3460 jsr [PC + 0x87C /* 00003CDE */]
3464 pea.l [A6 - 0x20]
3468 move.w -[A7], [A5 - 0x114]
346C jsr [PC + 0x5C0 /* 00003A2E */]
3470 addq.w D7, 1
3472 cmpi.w D7, 0x8
3476 ble -0x2A /* 0000344C */
3478 move.w D0, [A5 - 0x3C4]
347C subq.w D0, 1
347E move.w [A5 - 0x3C4], D0
3482 move.w D0, [A5 - 0x3C6]
3486 muls.w D0, 0xE
348A move.w D1, [A5 - 0x3C4]
348E addq.w D1, 1
3490 add.w D0, D1
3492 addi.w D0, 0xFC44
3496 move.b [A5 + D0.w], 0x6
349C bra +0xAE /* 0000354A */
label000034A0:
34A0 move.w D0, [A5 - 0x3C6]
34A4 muls.w D0, 0xE
34A8 move.w D1, [A5 - 0x3C4]
34AC subq.w D1, 1
34AE add.w D0, D1
34B0 addi.w D0, 0xFC44
34B4 cmpi.b [A5 + D0.w], 0x6
34BA bne +0x88 /* 00003542 */
34BE pea.l [A6 - 0x20]
34C2 move.w -[A7], [A5 - 0x3C6]
34C6 move.w D0, [A5 - 0x3C4]
34CA subq.w D0, 1
34CC move.w -[A7], D0
34CE clr.w -[A7]
34D0 jsr [PC + 0x60C /* 00003ADE */]
34D4 move.w -[A7], 0xD3
34D8 jsr [PC - 0x3108 /* 000003D2 */]
34DC moveq.l D7, 0x04
label000034DE:
34DE pea.l [A6 - 0x18]
34E2 move.w -[A7], 0x4
34E6 move.w -[A7], D7
34E8 clr.w -[A7]
34EA jsr [PC + 0x5F2 /* 00003ADE */]
34EE pea.l [A6 - 0x18]
34F2 pea.l [A6 - 0x20]
34F6 jsr [PC + 0x7E6 /* 00003CDE */]
34FA pea.l [A6 - 0x20]
34FE move.w -[A7], [A5 - 0x114]
3502 jsr [PC + 0x52A /* 00003A2E */]
3506 addq.w D7, 1
3508 cmpi.w D7, 0x9 /* '\t' */
350C ble -0x2E /* 000034DE */
350E move.w D0, [A5 - 0x3C6]
3512 muls.w D0, 0xE
3516 move.w D1, [A5 - 0x3C4]
351A subq.w D1, 1
351C add.w D0, D1
351E addi.w D0, 0xFC44
3522 clr.b [A5 + D0.w]
3526 move.w -[A7], [A5 - 0x3C6]
352A move.w D0, [A5 - 0x3C4]
352E subq.w D0, 1
3530 move.w -[A7], D0
3532 jsr [PC + 0x41A /* 0000394E */]
3536 pea.l [A6 - 0x20]
353A clr.w -[A7]
353C jsr [PC + 0x4F0 /* 00003A2E */]
3540 bra +0xA /* 0000354A */
label00003542:
3542 move.w -[A7], 0xD0
3546 jsr [PC - 0x3176 /* 000003D2 */]
label0000354A:
354A pea.l [A6 - 0x20]
354E move.w -[A7], [A5 - 0x3C6]
3552 move.w -[A7], [A5 - 0x3C4]
3556 clr.w -[A7]
3558 jsr [PC + 0x584 /* 00003ADE */]
355C moveq.l D7, 0x07
label0000355E:
355E pea.l [A6 - 0x18]
3562 move.w -[A7], 0x5
3566 move.w -[A7], D7
3568 jsr [PC + 0x6BA /* 00003C24 */]
356C move.w -[A7], [A5 - 0x3C6]
3570 move.w -[A7], [A5 - 0x3C4]
3574 jsr [PC + 0x3D8 /* 0000394E */]
3578 pea.l [A6 - 0x18]
357C pea.l [A6 - 0x20]
3580 jsr [PC + 0x434 /* 000039B6 */]
3584 pea.l [A6 - 0x20]
3588 move.w -[A7], [A5 - 0x114]
358C jsr [PC + 0x4A0 /* 00003A2E */]
3590 subq.w D7, 1
3592 cmpi.w D7, 0x5
3596 bge -0x38 /* 0000355E */
3598 move.b [A5 - 0x3C2], 0x2
359E bra +0x39C /* 0000393A */
35A2 clr.b [A5 - 0x3C0]
35A6 pea.l [A6 - 0x20]
35AA move.w -[A7], [A5 - 0x3C6]
35AE move.w -[A7], [A5 - 0x3C4]
35B2 clr.w -[A7]
35B4 jsr [PC + 0x528 /* 00003ADE */]
35B8 moveq.l D7, 0x01
label000035BA:
35BA pea.l [A6 - 0x18]
35BE move.w -[A7], 0x6
35C2 move.w -[A7], D7
35C4 jsr [PC + 0x65E /* 00003C24 */]
35C8 move.w -[A7], [A5 - 0x3C6]
35CC move.w -[A7], [A5 - 0x3C4]
35D0 jsr [PC + 0x37C /* 0000394E */]
35D4 pea.l [A6 - 0x18]
35D8 pea.l [A6 - 0x20]
35DC jsr [PC + 0x3D8 /* 000039B6 */]
35E0 pea.l [A6 - 0x20]
35E4 move.w -[A7], [A5 - 0x114]
35E8 jsr [PC + 0x444 /* 00003A2E */]
35EC addq.w D7, 1
35EE cmpi.w D7, 0x8
35F2 ble -0x38 /* 000035BA */
35F4 move.w -[A7], [A5 - 0x3C6]
35F8 move.w -[A7], [A5 - 0x3C4]
35FC jsr [PC + 0x350 /* 0000394E */]
3600 pea.l [A6 - 0x20]
3604 clr.w -[A7]
3606 jsr [PC + 0x426 /* 00003A2E */]
360A move.b [A5 - 0x3C2], 0x5
3610 bra +0x32A /* 0000393A */
3614 move.w D6, [A5 - 0x3C4]
3618 addq.w D6, 1
361A bra +0xC /* 00003626 */
label0000361C:
361C addq.w D6, 1
361E cmpi.w D6, 0xC
3622 ble +0x4 /* 00003626 */
3624 moveq.l D6, 0x01
label00003626:
3626 move.w D0, [A5 - 0x3C6]
362A muls.w D0, 0xE
362E add.w D0, D6
3630 addi.w D0, 0xFC44
3634 cmpi.b [A5 + D0.w], 0xF
363A bne -0x1E /* 0000361C */
363C moveq.l D7, 0x01
label0000363E:
363E pea.l [A6 - 0x20]
3642 move.w -[A7], [A5 - 0x3C6]
3646 move.w -[A7], [A5 - 0x3C4]
364A clr.w -[A7]
364C jsr [PC + 0x490 /* 00003ADE */]
3650 pea.l [A6 - 0x18]
3654 move.w -[A7], 0x6
3658 move.w -[A7], D7
365A jsr [PC + 0x5C8 /* 00003C24 */]
365E move.w -[A7], [A5 - 0x3C6]
3662 move.w -[A7], [A5 - 0x3C4]
3666 jsr [PC + 0x2E6 /* 0000394E */]
366A pea.l [A6 - 0x18]
366E pea.l [A6 - 0x20]
3672 jsr [PC + 0x342 /* 000039B6 */]
3676 pea.l [A6 - 0x20]
367A move.w -[A7], 0x2
367E jsr [PC + 0x3AE /* 00003A2E */]
3682 pea.l [A6 - 0x20]
3686 move.w -[A7], [A5 - 0x3C6]
368A move.w -[A7], D6
368C clr.w -[A7]
368E jsr [PC + 0x44E /* 00003ADE */]
3692 pea.l [A6 - 0x18]
3696 move.w -[A7], 0x6
369A moveq.l D0, 0x09
369C sub.w D0, D7
369E move.w -[A7], D0
36A0 jsr [PC + 0x582 /* 00003C24 */]
36A4 move.w -[A7], [A5 - 0x3C6]
36A8 move.w -[A7], D6
36AA jsr [PC + 0x2A2 /* 0000394E */]
36AE pea.l [A6 - 0x18]
36B2 pea.l [A6 - 0x20]
36B6 jsr [PC + 0x2FE /* 000039B6 */]
36BA pea.l [A6 - 0x20]
36BE move.w -[A7], 0x2
36C2 jsr [PC + 0x36A /* 00003A2E */]
36C6 pea.l [A6 - 0x20]
36CA move.w -[A7], [A5 - 0x3C6]
36CE move.w -[A7], [A5 - 0x3C4]
36D2 clr.w -[A7]
36D4 jsr [PC + 0x408 /* 00003ADE */]
36D8 addq.w D7, 1
36DA cmpi.w D7, 0x8
36DE ble -0xA0 /* 0000363E */
36E2 move.w -[A7], [A5 - 0x3C6]
36E6 move.w -[A7], [A5 - 0x3C4]
36EA jsr [PC + 0x262 /* 0000394E */]
36EE pea.l [A6 - 0x20]
36F2 clr.w -[A7]
36F4 jsr [PC + 0x338 /* 00003A2E */]
36F8 move.w [A5 - 0x3C4], D6
36FC clr.b [A5 - 0x3C2]
3700 move.b [A5 - 0x3C0], 0x1
3706 bra +0x234 /* 0000393A */
370A clr.b [A5 - 0x3C0]
370E subq.w A7, 4
3710 syscall TickCount
3712 moveq.l D5, 0x1E
3714 add.l D5, [A7]+
label00003716:
3716 subq.w A7, 4
3718 syscall TickCount
371A cmp.l D5, [A7]+
371C bgt -0x6 /* 00003716 */
371E pea.l [A6 - 0x20]
3722 move.w -[A7], [A5 - 0x3C6]
3726 move.w -[A7], [A5 - 0x3C4]
372A clr.w -[A7]
372C jsr [PC + 0x3B0 /* 00003ADE */]
3730 tst.b [A5 - 0x205]
3734 beq +0x10 /* 00003744 */
3736 clr.b [A5 - 0x205]
373A move.w -[A7], 0xCC
373E jsr [PC - 0x336E /* 000003D2 */]
3742 bra +0xA /* 0000374C */
label00003744:
3744 move.w -[A7], 0xD5
3748 jsr [PC - 0x3378 /* 000003D2 */]
label0000374C:
374C moveq.l D7, 0x08
label0000374E:
374E pea.l [A6 - 0x18]
3752 move.w -[A7], 0x6
3756 move.w -[A7], D7
3758 jsr [PC + 0x4CA /* 00003C24 */]
375C move.w -[A7], [A5 - 0x3C6]
3760 move.w -[A7], [A5 - 0x3C4]
3764 jsr [PC + 0x1E8 /* 0000394E */]
3768 pea.l [A6 - 0x18]
376C pea.l [A6 - 0x20]
3770 jsr [PC + 0x244 /* 000039B6 */]
3774 pea.l [A6 - 0x20]
3778 move.w -[A7], [A5 - 0x114]
377C jsr [PC + 0x2B0 /* 00003A2E */]
3780 subq.w D7, 1
3782 cmpi.w D7, 0x1
3786 bge -0x38 /* 0000374E */
3788 clr.b [A5 - 0x3C2]
378C bra +0x1AE /* 0000393A */
3790 clr.b [A5 - 0x3C0]
3794 pea.l [A6 - 0x20]
3798 move.w -[A7], [A5 - 0x3C6]
379C move.w -[A7], [A5 - 0x3C4]
37A0 clr.w -[A7]
37A2 jsr [PC + 0x33A /* 00003ADE */]
37A6 moveq.l D7, 0x05
label000037A8:
37A8 pea.l [A6 - 0x18]
37AC move.w -[A7], 0x5
37B0 move.w -[A7], D7
37B2 jsr [PC + 0x470 /* 00003C24 */]
37B6 move.w -[A7], [A5 - 0x3C6]
37BA move.w -[A7], [A5 - 0x3C4]
37BE jsr [PC + 0x18E /* 0000394E */]
37C2 pea.l [A6 - 0x18]
37C6 pea.l [A6 - 0x20]
37CA jsr [PC + 0x1EA /* 000039B6 */]
37CE pea.l [A6 - 0x20]
37D2 move.w -[A7], [A5 - 0x114]
37D6 jsr [PC + 0x256 /* 00003A2E */]
37DA addq.w D7, 1
37DC cmpi.w D7, 0x7
37E0 ble -0x38 /* 000037A8 */
37E2 move.w -[A7], 0xC9
37E6 jsr [PC - 0x3416 /* 000003D2 */]
37EA moveq.l D7, 0x04
label000037EC:
37EC pea.l [A6 - 0x18]
37F0 move.w -[A7], D7
37F2 move.w -[A7], 0x9 /* '\t' */
37F6 jsr [PC + 0x42C /* 00003C24 */]
37FA move.w -[A7], [A5 - 0x3C6]
37FE move.w -[A7], [A5 - 0x3C4]
3802 jsr [PC + 0x14A /* 0000394E */]
3806 pea.l [A6 - 0x18]
380A pea.l [A6 - 0x20]
380E jsr [PC + 0x1A6 /* 000039B6 */]
3812 pea.l [A6 - 0x20]
3816 move.w D0, [A5 - 0x114]
381A add.w D0, D0
381C move.w -[A7], D0
381E jsr [PC + 0x20E /* 00003A2E */]
3822 addq.w D7, 1
3824 cmpi.w D7, 0x7
3828 ble -0x3C /* 000037EC */
382A move.b [A5 - 0x3C2], 0x5
3830 move.b [A5 - 0x438], 0x1
3836 bra +0x104 /* 0000393A */
383A clr.b [A5 - 0x3C1]
383E pea.l [A6 - 0x18]
3842 move.w -[A7], 0x1
3846 move.w -[A7], 0x1
384A jsr [PC + 0x3D8 /* 00003C24 */]
384E pea.l [A6 - 0x20]
3852 move.w -[A7], [A5 - 0x3C6]
3856 move.w -[A7], [A5 - 0x3C4]
385A clr.w -[A7]
385C jsr [PC + 0x280 /* 00003ADE */]
3860 move.w -[A7], [A5 - 0x3C6]
3864 move.w -[A7], [A5 - 0x3C4]
3868 jsr [PC + 0xE4 /* 0000394E */]
386C pea.l [A6 - 0x18]
3870 pea.l [A6 - 0x20]
3874 jsr [PC + 0x140 /* 000039B6 */]
3878 pea.l [A6 - 0x20]
387C move.w -[A7], [A5 - 0x114]
3880 jsr [PC + 0x1AC /* 00003A2E */]
3884 pea.l [A6 - 0x20]
3888 move.w D0, [A5 - 0x3C6]
388C subq.w D0, 1
388E move.w -[A7], D0
3890 move.w -[A7], [A5 - 0x3C4]
3894 clr.w -[A7]
3896 jsr [PC + 0x2B0 /* 00003B48 */]
389A jsr [PC + 0x492 /* 00003D2E */]
389E move.w -[A7], 0xC9
38A2 jsr [PC - 0x34D2 /* 000003D2 */]
38A6 moveq.l D7, 0x01
label000038A8:
38A8 pea.l [A6 - 0x18]
38AC cmpi.b [A5 - 0x3BD], 0x1
38B2 seq D0
38B4 andi.w D0, 0x1
38B8 add.w D0, D0
38BA addq.w D0, 1
38BC move.w -[A7], D0
38BE move.w -[A7], D7
38C0 clr.w -[A7]
38C2 jsr [PC + 0x284 /* 00003B48 */]
38C6 movea.l A0, [A5 - 0x44E]
38CA pea.l [A0 + 0x2]
38CE movea.l A0, [A5 - 0x456]
38D2 pea.l [A0 + 0x2]
38D6 pea.l [A6 - 0x18]
38DA pea.l [A6 - 0x20]
38DE clr.w -[A7]
38E0 clr.l -[A7]
38E2 syscall CopyBits
38E4 pea.l [A6 - 0x20]
38E8 move.w -[A7], [A5 - 0x10C]
38EC jsr [PC + 0x140 /* 00003A2E */]
38F0 addq.w D7, 1
38F2 cmpi.w D7, 0x11
38F6 ble -0x4E /* 000038A8 */
38F8 move.b [A5 - 0x3C2], 0x6
38FE move.b [A5 - 0x438], 0x1
3904 bra +0x36 /* 0000393A */
label00003906:
3906 andi.w D0, 0xFF
390A cmpi.w D0, 0x10
390E bcc +0x2C /* 0000393A */
3910 add.w D0, D0
3912 move.w D0, [PC + D0.w + 0x6]
3916 jmp [PC + D0.w + 0x2]
391A bfextu D6, D2 {D0:16}
391E asr D4, 6
3920 bfclr [A4] {D4:D4}
3924 rol D4.w, D6
3926 bfffo D6, [A2] {D1:D6}
392A .invalid 0xF03A, 0xF4E4 // unimplemented
3930 .extension 0xC88 <<F/2-3/6>> // unimplemented
3934 .extension 0xCFA <<F/2-3/6>> // unimplemented
3938 .extension 0xF20 <<F/4-5/7>> // unimplemented
label0000393A:
393A movem.l D5,D6,D7, [A7]+
393E unlink A6
3940 movea.l A0, [A7]+
3942 addq.w A7, 2
3944 jmp [A0]
3946 and.b D1, D1
3948 asr D1.b, 1
394A ror D1.b, 5
394C .invalid fp4, (packed_real) [A1]+
// begin alternate branch 0000394E-00003952
fn0000394E:
394E link A6, -0x0020
// end alternate branch 0000394E-00003952
fn0000394E: // (misaligned)
3950 .invalid <<F/7/7>>
3952 pea.l [A6 - 0x18]
3956 move.w -[A7], [A6 + 0xA]
395A move.w -[A7], [A6 + 0x8]
395E clr.w -[A7]
3960 jsr [PC + 0x17C /* 00003ADE */]
3964 move.l -[A7], [A5 - 0x456]
3968 clr.l -[A7]
396A move.l D0, 0x80006
3970 syscall QDExtensions
3972 move.w D0, [A6 + 0xA]
3976 muls.w D0, 0xE
397A move.w D1, [A6 + 0x8]
397E add.w D0, D1
3980 addi.w D0, 0xFC44
3984 tst.b [A5 + D0.w]
3988 bne +0xA /* 00003992 */
398A pea.l [A6 - 0x18]
398E syscall PaintRect
3990 bra +0x20 /* 000039B0 */
label00003992:
3992 movea.l A0, [A5 - 0x452]
3996 pea.l [A0 + 0x2]
399A movea.l A0, [A5 - 0x456]
399E pea.l [A0 + 0x2]
39A2 pea.l [A6 - 0x18]
39A6 pea.l [A6 - 0x18]
39AA clr.w -[A7]
39AC clr.l -[A7]
39AE syscall CopyBits
label000039B0:
39B0 unlink A6
39B2 move.l [A7], [A7]+
39B4 rts
fn000039B6:
39B6 link A6, -0x0020
39BA movea.l A0, [A6 + 0xC]
39BE lea.l A1, [A6 - 0x20]
39C2 move.l [A1]+, [A0]+
39C4 move.l [A1]+, [A0]+
39C6 movea.l A0, [A6 + 0x8]
39CA lea.l A1, [A6 - 0x18]
39CE move.l [A1]+, [A0]+
39D0 move.l [A1]+, [A0]+
39D2 move.l -[A7], [A5 - 0x442]
39D6 move.w D0, [A6 - 0x16]
39DA sub.w D0, [A6 - 0x1E]
39DE move.w -[A7], D0
39E0 move.w D0, [A6 - 0x18]
39E4 sub.w D0, [A6 - 0x20]
39E8 move.w -[A7], D0
39EA syscall OffsetRgn/OfsetRgn
39EC movea.l A0, [A5 - 0x44A]
39F0 pea.l [A0 + 0x2]
39F4 movea.l A0, [A5 - 0x456]
39F8 pea.l [A0 + 0x2]
39FC pea.l [A6 - 0x20]
3A00 pea.l [A6 - 0x18]
3A04 clr.w -[A7]
3A06 move.l -[A7], [A5 - 0x442]
3A0A syscall CopyBits
3A0C move.l -[A7], [A5 - 0x442]
3A10 move.w D0, [A6 - 0x1E]
3A14 sub.w D0, [A6 - 0x16]
3A18 move.w -[A7], D0
3A1A move.w D0, [A6 - 0x20]
3A1E sub.w D0, [A6 - 0x18]
3A22 move.w -[A7], D0
3A24 syscall OffsetRgn/OfsetRgn
3A26 unlink A6
3A28 movea.l A0, [A7]+
3A2A addq.w A7, 8
3A2C jmp [A0]
fn00003A2E:
3A2E link A6, -0x001A
3A32 move.l -[A7], D7
3A34 movea.l A0, [A6 + 0xA]
3A38 lea.l A1, [A6 - 0x18]
3A3C move.l [A1]+, [A0]+
3A3E move.l [A1]+, [A0]+
label00003A40:
3A40 subq.w A7, 4
3A42 syscall TickCount
3A44 move.l D0, [A7]+
3A46 cmp.l D0, [A5 - 0x20A]
3A4A blt -0xA /* 00003A40 */
3A4C move.l -[A7], [A5 - 0x432]
3A50 move.l -[A7], [A5 - 0x42E]
3A54 move.l D0, 0x80006
3A5A syscall QDExtensions
3A5C movea.l A0, [A5 - 0x456]
3A60 pea.l [A0 + 0x2]
3A64 movea.l A0, [A5 - 0x432]
3A68 pea.l [A0 + 0x2]
3A6C pea.l [A6 - 0x18]
3A70 pea.l [A6 - 0x18]
3A74 clr.w -[A7]
3A76 clr.l -[A7]
3A78 syscall CopyBits
3A7A subq.w A7, 4
3A7C syscall TickCount
3A7E move.w D0, [A6 + 0x8]
3A82 ext.l D0
3A84 add.l D0, [A7]+
3A86 move.l [A5 - 0x20A], D0
3A8A moveq.l D7, 0x01
label00003A8C:
3A8C move.w D0, D7
3A8E muls.w D0, 0xC
3A92 move.w D1, D7
3A94 muls.w D1, 0xC
3A98 move.l -[A7], D0
3A9A move.l -[A7], D1
3A9C subq.w A7, 4
3A9E syscall TickCount
3AA0 move.l D2, [A7]+
3AA2 move.l D1, [A7]+
3AA4 move.l D0, [A7]+
3AA6 addi.w D1, 0xFDF8
3AAA cmp.l D2, [A5 + D1.w]
3AAE sge D1
3AB0 addi.w D0, 0xFDF0
3AB4 and.b D1, [A5 + D0.w]
3AB8 beq +0x14 /* 00003ACC */
3ABA move.w D0, D7
3ABC muls.w D0, 0xC
3AC0 addi.w D0, 0xFDF0
3AC4 pea.l [A5 + D0.w]
3AC8 jsr [PC - 0x18D4 /* 000021F6 */]
label00003ACC:
3ACC addq.w D7, 1
3ACE cmpi.w D7, 0x14
3AD2 ble -0x46 /* 00003A8C */
3AD4 move.l D7, [A7]+
3AD6 unlink A6
3AD8 movea.l A0, [A7]+
3ADA addq.w A7, 6
3ADC jmp [A0]
fn00003ADE:
3ADE link A6, -0x0012
3AE2 movem.l -[A7], D4,D5,D6,D7,A4
3AE6 movea.l A4, [A6 + 0xE]
3AEA move.w D6, [A6 + 0x8]
3AEE move.w D5, [A6 + 0xC]
3AF2 move.w D4, [A6 + 0xA]
3AF6 move.l -[A7], A4
3AF8 move.w D0, D5
3AFA muls.w D0, 0x28 /* '(' */
3AFE addi.w D0, 0xFFD8
3B02 move.w -[A7], D0
3B04 move.w D0, D4
3B06 muls.w D0, 0x28 /* '(' */
3B0A addi.w D0, 0xFFD8
3B0E move.w -[A7], D0
3B10 move.w D0, D5
3B12 muls.w D0, 0x28 /* '(' */
3B16 move.w -[A7], D0
3B18 move.w D0, D4
3B1A muls.w D0, 0x28 /* '(' */
3B1E move.w -[A7], D0
3B20 syscall SetRect
3B22 tst.w D6
3B24 ble +0x16 /* 00003B3A */
3B26 move.w D7, D6
3B28 sub.w D7, [A4 + 0x6]
3B2C move.w D0, D6
3B2E sub.w D0, [A4 + 0x2]
3B32 move.w [A4 + 0x6], D0
3B36 move.w [A4 + 0x2], D7
label00003B3A:
3B3A movem.l D4,D5,D6,D7,A4, [A7]+
3B3E unlink A6
3B40 movea.l A0, [A7]+
3B42 lea.l A7, [A7 + 0xA]
3B46 jmp [A0]
fn00003B48:
3B48 link A6, -0x0012
3B4C movem.l -[A7], D4,D5,D6,D7,A4
3B50 movea.l A4, [A6 + 0xE]
3B54 move.w D6, [A6 + 0x8]
3B58 move.w D5, [A6 + 0xC]
3B5C move.w D4, [A6 + 0xA]
3B60 move.l -[A7], A4
3B62 move.w D0, D5
3B64 muls.w D0, 0x28 /* '(' */
3B68 addi.w D0, 0xFFD8
3B6C move.w -[A7], D0
3B6E move.w D0, D4
3B70 muls.w D0, 0x28 /* '(' */
3B74 addi.w D0, 0xFFD8
3B78 move.w -[A7], D0
3B7A move.w D0, D5
3B7C muls.w D0, 0x28 /* '(' */
3B80 addi.w D0, 0x28 /* '(' */
3B84 move.w -[A7], D0
3B86 move.w D0, D4
3B88 muls.w D0, 0x28 /* '(' */
3B8C move.w -[A7], D0
3B8E syscall SetRect
3B90 tst.w D6
3B92 ble +0x16 /* 00003BA8 */
3B94 move.w D7, D6
3B96 sub.w D7, [A4 + 0x6]
3B9A move.w D0, D6
3B9C sub.w D0, [A4 + 0x2]
3BA0 move.w [A4 + 0x6], D0
3BA4 move.w [A4 + 0x2], D7
label00003BA8:
3BA8 movem.l D4,D5,D6,D7,A4, [A7]+
3BAC unlink A6
3BAE movea.l A0, [A7]+
3BB0 lea.l A7, [A7 + 0xA]
3BB4 jmp [A0]
fn00003BB6:
3BB6 link A6, -0x0012
3BBA movem.l -[A7], D4,D5,D6,D7,A4
3BBE movea.l A4, [A6 + 0xE]
3BC2 move.w D6, [A6 + 0x8]
3BC6 move.w D5, [A6 + 0xC]
3BCA move.w D4, [A6 + 0xA]
3BCE move.l -[A7], A4
3BD0 move.w D0, D5
3BD2 muls.w D0, 0x28 /* '(' */
3BD6 addi.w D0, 0xFFD8
3BDA move.w -[A7], D0
3BDC move.w D0, D4
3BDE muls.w D0, 0x28 /* '(' */
3BE2 addi.w D0, 0xFFD8
3BE6 move.w -[A7], D0
3BE8 move.w D0, D5
3BEA muls.w D0, 0x28 /* '(' */
3BEE move.w -[A7], D0
3BF0 move.w D0, D4
3BF2 muls.w D0, 0x28 /* '(' */
3BF6 addi.w D0, 0x28 /* '(' */
3BFA move.w -[A7], D0
3BFC syscall SetRect
3BFE tst.w D6
3C00 ble +0x16 /* 00003C16 */
3C02 move.w D7, D6
3C04 sub.w D7, [A4 + 0x6]
3C08 move.w D0, D6
3C0A sub.w D0, [A4 + 0x2]
3C0E move.w [A4 + 0x6], D0
3C12 move.w [A4 + 0x2], D7
label00003C16:
3C16 movem.l D4,D5,D6,D7,A4, [A7]+
3C1A unlink A6
3C1C movea.l A0, [A7]+
3C1E lea.l A7, [A7 + 0xA]
3C22 jmp [A0]
fn00003C24:
3C24 link A6, 0x0000
3C28 move.l -[A7], A4
3C2A movea.l A4, [A6 + 0xC]
3C2E tst.b [A5 - 0x3C1]
3C32 beq +0x14 /* 00003C46 */
3C34 move.l -[A7], A4
3C36 move.w -[A7], [A6 + 0xA]
3C3A move.w -[A7], [A6 + 0x8]
3C3E clr.w -[A7]
3C40 jsr [PC - 0x164 /* 00003ADE */]
3C44 bra +0x14 /* 00003C58 */
label00003C46:
3C46 move.l -[A7], A4
3C48 move.w -[A7], [A6 + 0xA]
3C4C move.w -[A7], [A6 + 0x8]
3C50 move.w -[A7], 0x1E0
3C54 jsr [PC - 0x178 /* 00003ADE */]
label00003C58:
3C58 movea.l A4, [A7]+
3C5A unlink A6
3C5C movea.l A0, [A7]+
3C5E addq.w A7, 8
3C60 jmp [A0]
fn00003C62:
3C62 link A6, 0x0000
3C66 move.l -[A7], A4
3C68 movea.l A4, [A6 + 0xC]
3C6C tst.b [A5 - 0x3C1]
3C70 beq +0x14 /* 00003C84 */
3C72 move.l -[A7], A4
3C74 move.w -[A7], [A6 + 0xA]
3C78 move.w -[A7], [A6 + 0x8]
3C7C clr.w -[A7]
3C7E jsr [PC - 0x138 /* 00003B48 */]
3C82 bra +0x14 /* 00003C96 */
label00003C84:
3C84 move.l -[A7], A4
3C86 move.w -[A7], [A6 + 0xA]
3C8A move.w -[A7], [A6 + 0x8]
3C8E move.w -[A7], 0x1E0
3C92 jsr [PC - 0x14C /* 00003B48 */]
label00003C96:
3C96 movea.l A4, [A7]+
3C98 unlink A6
3C9A movea.l A0, [A7]+
3C9C addq.w A7, 8
3C9E jmp [A0]
fn00003CA0:
3CA0 link A6, 0x0000
3CA4 move.l -[A7], A4
3CA6 movea.l A4, [A6 + 0xC]
3CAA tst.b [A5 - 0x3C1]
3CAE beq +0x14 /* 00003CC2 */
3CB0 move.l -[A7], A4
3CB2 move.w -[A7], [A6 + 0xA]
3CB6 move.w -[A7], [A6 + 0x8]
3CBA clr.w -[A7]
3CBC jsr [PC - 0x108 /* 00003BB6 */]
3CC0 bra +0x14 /* 00003CD4 */
label00003CC2:
3CC2 move.l -[A7], A4
3CC4 move.w -[A7], [A6 + 0xA]
3CC8 move.w -[A7], [A6 + 0x8]
3CCC move.w -[A7], 0x1E0
3CD0 jsr [PC - 0x11C /* 00003BB6 */]
label00003CD4:
3CD4 movea.l A4, [A7]+
3CD6 unlink A6
3CD8 movea.l A0, [A7]+
3CDA addq.w A7, 8
3CDC jmp [A0]
fn00003CDE:
3CDE link A6, -0x0020
3CE2 movea.l A0, [A6 + 0xC]
3CE6 lea.l A1, [A6 - 0x20]
3CEA move.l [A1]+, [A0]+
3CEC move.l [A1]+, [A0]+
3CEE movea.l A0, [A6 + 0x8]
3CF2 lea.l A1, [A6 - 0x18]
3CF6 move.l [A1]+, [A0]+
3CF8 move.l [A1]+, [A0]+
3CFA move.l -[A7], [A5 - 0x456]
3CFE clr.l -[A7]
3D00 move.l D0, 0x80006
3D06 syscall QDExtensions
3D08 movea.l A0, [A5 - 0x44E]
3D0C pea.l [A0 + 0x2]
3D10 movea.l A0, [A5 - 0x456]
3D14 pea.l [A0 + 0x2]
3D18 pea.l [A6 - 0x20]
3D1C pea.l [A6 - 0x18]
3D20 clr.w -[A7]
3D22 clr.l -[A7]
3D24 syscall CopyBits
3D26 unlink A6
3D28 movea.l A0, [A7]+
3D2A addq.w A7, 8
3D2C jmp [A0]
fn00003D2E:
3D2E link A6, -0x0048
3D32 move.l -[A7], A4
3D34 pea.l [A6 - 0x1C]
3D38 clr.w -[A7]
3D3A clr.w -[A7]
3D3C move.w -[A7], 0xA0
3D40 move.w -[A7], 0x2A8
3D44 syscall SetRect
3D46 subq.w A7, 4
3D48 pea.l [A5 - 0x44E]
3D4C move.w -[A7], 0x8
3D50 pea.l [A6 - 0x1C]
3D54 clr.l -[A7]
3D56 clr.l -[A7]
3D58 clr.l [A6 - 0x24]
3D5C move.l -[A7], [A6 - 0x24]
3D60 move.l D0, 0x160003
3D66 syscall QDExtensions
3D68 move.l D0, [A7]+
3D6A move.l [A6 - 0x28], D0
3D6E pea.l [A6 - 0x28]
3D72 pea.l [A6 - 0x48]
3D76 move.w -[A7], 0x4
3D7A jsr [PC - 0x3BE2 /* 0000019A */]
3D7E move.l [A6 - 0x20], [A6 - 0x2C]
3D84 move.l -[A7], [A5 - 0x44E]
3D88 clr.l -[A7]
3D8A move.l D0, 0x80006
3D90 syscall QDExtensions
3D92 subq.w A7, 4
3D94 move.w -[A7], 0x86
3D98 syscall GetPicture
3D9A movea.l A4, [A7]+
3D9C move.l -[A7], A4
3D9E pea.l [A6 - 0x1C]
3DA2 syscall DrawPicture
3DA4 move.l -[A7], A4
3DA6 syscall ReleaseResource
3DA8 move.l -[A7], [A5 - 0x432]
3DAC move.l -[A7], [A5 - 0x42E]
3DB0 move.l D0, 0x80006
3DB6 syscall QDExtensions
3DB8 movea.l A4, [A7]+
3DBA unlink A6
3DBC rts
fn00003DBE:
3DBE link A6, -0x0020
3DC2 move.l -[A7], A4
3DC4 movea.l A4, [A6 + 0xC]
3DC8 movea.l A0, [A6 + 0x8]
3DCC lea.l A1, [A6 - 0x18]
3DD0 move.l [A1]+, [A0]+
3DD2 move.l [A1]+, [A0]+
3DD4 move.w D0, [A6 + 0x10]
3DD8 bra +0x1E6 /* 00003FBE */
label00003DDC:
3DDC pea.l [A6 - 0x20]
3DE0 move.w -[A7], 0x1
3DE4 subq.w A7, 2
3DE6 syscall Random
3DE8 move.w D0, [A7]+
3DEA ext.l D0
3DEC divs.w D0, 0x9 /* '\t' */
3DF0 swap.w D0
3DF2 tst.w D0
3DF4 bpl +0x4 /* 00003DF8 */
3DF6 neg.w D0
label00003DF8:
3DF8 addq.w D0, 2
3DFA move.w -[A7], D0
3DFC clr.w -[A7]
3DFE jsr [PC - 0x322 /* 00003ADE */]
3E02 move.b [A4], 0x1
3E06 bra +0x21E /* 00004024 */
label00003E0A:
3E0A pea.l [A6 - 0x20]
3E0E move.w -[A7], 0x2
3E12 subq.w A7, 2
3E14 syscall Random
3E16 move.w D0, [A7]+
3E18 ext.l D0
3E1A divs.w D0, 0x9 /* '\t' */
3E1E swap.w D0
3E20 tst.w D0
3E22 bpl +0x4 /* 00003E26 */
3E24 neg.w D0
label00003E26:
3E26 addq.w D0, 2
3E28 move.w -[A7], D0
3E2A clr.w -[A7]
3E2C jsr [PC - 0x350 /* 00003ADE */]
3E30 move.b [A4], 0x2
3E34 bra +0x1F0 /* 00004024 */
label00003E38:
3E38 pea.l [A6 - 0x20]
3E3C move.w -[A7], 0x4
3E40 move.w -[A7], 0xA /* '\n' */
3E44 clr.w -[A7]
3E46 jsr [PC - 0x36A /* 00003ADE */]
3E4A move.b [A4], 0x3
3E4E bra +0x1D6 /* 00004024 */
label00003E52:
3E52 pea.l [A6 - 0x20]
3E56 move.w -[A7], 0x4
3E5A move.w -[A7], 0xB
3E5E clr.w -[A7]
3E60 jsr [PC - 0x384 /* 00003ADE */]
3E64 move.b [A4], 0x4
3E68 bra +0x1BC /* 00004024 */
label00003E6C:
3E6C pea.l [A6 - 0x20]
3E70 move.w -[A7], 0x5
3E74 move.w -[A7], 0x4
3E78 clr.w -[A7]
3E7A jsr [PC - 0x39E /* 00003ADE */]
3E7E move.b [A4], 0x7
3E82 bra +0x1A2 /* 00004024 */
label00003E86:
3E86 pea.l [A6 - 0x20]
3E8A move.w -[A7], 0x5
3E8E move.w -[A7], 0x5
3E92 clr.w -[A7]
3E94 jsr [PC - 0x3B8 /* 00003ADE */]
3E98 move.b [A4], 0x8
3E9C bra +0x188 /* 00004024 */
label00003EA0:
3EA0 pea.l [A6 - 0x20]
3EA4 move.w -[A7], 0x5
3EA8 move.w -[A7], 0x6
3EAC clr.w -[A7]
3EAE jsr [PC - 0x3D2 /* 00003ADE */]
3EB2 move.b [A4], 0x9 /* '\t' */
3EB6 bra +0x16E /* 00004024 */
label00003EBA:
3EBA pea.l [A6 - 0x20]
3EBE move.w -[A7], 0x5
3EC2 move.w -[A7], 0x7
3EC6 clr.w -[A7]
3EC8 jsr [PC - 0x3EC /* 00003ADE */]
3ECC move.b [A4], 0xA /* '\n' */
3ED0 bra +0x154 /* 00004024 */
label00003ED4:
3ED4 pea.l [A6 - 0x20]
3ED8 move.w -[A7], 0x6
3EDC move.w -[A7], 0x1
3EE0 clr.w -[A7]
3EE2 jsr [PC - 0x406 /* 00003ADE */]
3EE6 move.b [A4], 0xB
3EEA bra +0x13A /* 00004024 */
label00003EEE:
3EEE pea.l [A6 - 0x20]
3EF2 move.w -[A7], 0x6
3EF6 move.w -[A7], 0x2
3EFA clr.w -[A7]
3EFC jsr [PC - 0x420 /* 00003ADE */]
3F00 move.b [A4], 0xC
3F04 bra +0x120 /* 00004024 */
label00003F08:
3F08 pea.l [A6 - 0x20]
3F0C move.w -[A7], 0x6
3F10 move.w -[A7], 0x3
3F14 clr.w -[A7]
3F16 jsr [PC - 0x43A /* 00003ADE */]
3F1A move.b [A4], 0xD /* '\r' */
3F1E bra +0x106 /* 00004024 */
label00003F22:
3F22 pea.l [A6 - 0x20]
3F26 move.w -[A7], 0x6
3F2A move.w -[A7], 0x7
3F2E clr.w -[A7]
3F30 jsr [PC - 0x454 /* 00003ADE */]
3F34 move.b [A4], 0xE
3F38 bra +0xEC /* 00004024 */
label00003F3C:
3F3C pea.l [A6 - 0x20]
3F40 move.w -[A7], 0x6
3F44 move.w -[A7], 0x9 /* '\t' */
3F48 clr.w -[A7]
3F4A jsr [PC - 0x46E /* 00003ADE */]
3F4E move.b [A4], 0xF
3F52 bra +0xD2 /* 00004024 */
label00003F56:
3F56 pea.l [A6 - 0x20]
3F5A move.w -[A7], 0x6
3F5E move.w -[A7], 0x8
3F62 clr.w -[A7]
3F64 jsr [PC - 0x488 /* 00003ADE */]
3F68 move.b [A4], 0x10
3F6C bra +0xB8 /* 00004024 */
label00003F70:
3F70 pea.l [A6 - 0x20]
3F74 move.w -[A7], 0x4
3F78 move.w -[A7], 0xA /* '\n' */
3F7C clr.w -[A7]
3F7E jsr [PC - 0x4A2 /* 00003ADE */]
3F82 move.b [A4], 0x9 /* '\t' */
3F86 bra +0x9E /* 00004024 */
label00003F8A:
3F8A pea.l [A6 - 0x20]
3F8E move.w -[A7], 0x6
3F92 move.w -[A7], 0xA /* '\n' */
3F96 clr.w -[A7]
3F98 jsr [PC - 0x4BC /* 00003ADE */]
3F9C move.b [A4], 0x9 /* '\t' */
3FA0 bra +0x84 /* 00004024 */
label00003FA4:
3FA4 pea.l [A6 - 0x20]
3FA8 move.w -[A7], 0x6
3FAC move.w -[A7], 0xB
3FB0 clr.w -[A7]
3FB2 jsr [PC - 0x4D6 /* 00003ADE */]
3FB6 move.b [A4], 0x9 /* '\t' */
3FBA bra +0x6A /* 00004024 */
label00003FBE:
3FBE addi.w D0, 0xFFDF
3FC2 beq -0xEE /* 00003ED4 */
3FC6 subq.w D0, 2
3FC8 beq -0xC0 /* 00003F08 */
3FCC subq.w D0, 1
3FCE beq -0xAC /* 00003F22 */
3FD2 subq.w D0, 1
3FD4 beq -0x98 /* 00003F3C */
3FD8 subq.w D0, 1
3FDA beq -0x36 /* 00003FA4 */
3FDC subq.w D0, 2
3FDE beq -0x88 /* 00003F56 */
3FE2 subq.w D0, 7
3FE4 beq -0x74 /* 00003F70 */
3FE6 subq.w D0, 2
3FE8 beq -0x20C /* 00003DDC */
3FEC subq.w D0, 1
3FEE beq -0x1E4 /* 00003E0A */
3FF2 subq.w D0, 1
3FF4 beq -0x1BC /* 00003E38 */
3FF8 subq.w D0, 1
3FFA beq -0x1A8 /* 00003E52 */
3FFE subq.w D0, 1
4000 beq -0x194 /* 00003E6C */
4004 subq.w D0, 1
4006 beq -0x180 /* 00003E86 */
400A subq.w D0, 1
400C beq -0x16C /* 00003EA0 */
4010 subq.w D0, 1
4012 beq -0x158 /* 00003EBA */
4016 subq.w D0, 8
4018 beq -0x12A /* 00003EEE */
401C addi.w D0, 0xFFE2
4020 beq -0x96 /* 00003F8A */
label00004024:
4024 move.l -[A7], [A5 - 0x452]
4028 clr.l -[A7]
402A move.l D0, 0x80006
4030 syscall QDExtensions
4032 movea.l A0, [A5 - 0x44E]
4036 pea.l [A0 + 0x2]
403A movea.l A0, [A5 - 0x452]
403E pea.l [A0 + 0x2]
4042 pea.l [A6 - 0x20]
4046 pea.l [A6 - 0x18]
404A clr.w -[A7]
404C clr.l -[A7]
404E syscall CopyBits
4050 move.l -[A7], [A5 - 0x432]
4054 move.l -[A7], [A5 - 0x42E]
4058 move.l D0, 0x80006
405E syscall QDExtensions
4060 movea.l A4, [A7]+
4062 unlink A6
4064 movea.l A0, [A7]+
4066 lea.l A7, [A7 + 0xA]
406A jmp [A0]
fn0000406C:
406C link A6, -0x0012
4070 move.l -[A7], D7
4072 moveq.l D7, 0x01
label00004074:
4074 move.w D0, D7
4076 muls.w D0, 0xC
407A addi.w D0, 0xFDF0
407E move.b D0, [A5 + D0.w]
4082 subq.b D0, 1
4084 beq +0x8 /* 0000408C */
4086 move.w [A6 + 0x8], D7
408A bra +0x10 /* 0000409A */
label0000408C:
408C addq.w D7, 1
408E cmpi.w D7, 0x14
4092 ble -0x1E /* 00004074 */
4094 move.w [A6 + 0x8], 0x14
label0000409A:
409A move.l D7, [A7]+
409C unlink A6
409E rts
fn000040A0:
40A0 link A6, -0x0014
40A4 movem.l -[A7], D6,D7
40A8 moveq.l D6, 0x01
label000040AA:
40AA move.w D0, D6
40AC muls.w D0, 0xC
40B0 move.w D1, D6
40B2 muls.w D1, 0xC
40B6 addi.w D1, 0xFDF2
40BA move.w D1, [A5 + D1.w]
40BE cmp.w D1, [A5 - 0x3C6]
40C2 seq D1
40C4 addi.w D0, 0xFDF0
40C8 and.b D1, [A5 + D0.w]
40CC move.w D0, D6
40CE muls.w D0, 0xC
40D2 move.w D2, [A5 - 0x3C4]
40D6 addq.w D2, 1
40D8 addi.w D0, 0xFDF4
40DC cmp.w D2, [A5 + D0.w]
40E0 seq D0
40E2 and.b D1, D0
40E4 bne +0x76 /* 0000415A */
40E6 addq.w D6, 1
40E8 cmpi.w D6, 0x14
40EC ble -0x42 /* 000040AA */
40EE subq.w A7, 2
40F0 jsr [PC - 0x86 /* 0000406C */]
40F4 move.w D7, [A7]+
40F6 move.w D0, D7
40F8 muls.w D0, 0xC
40FC addi.w D0, 0xFDF0
4100 move.b [A5 + D0.w], 0x1
4106 move.w D0, D7
4108 muls.w D0, 0xC
410C addi.w D0, 0xFDF2
4110 move.w [A5 + D0.w], [A5 - 0x3C6]
4116 move.w D0, [A5 - 0x3C4]
411A addq.w D0, 1
411C move.w D1, D7
411E muls.w D1, 0xC
4122 addi.w D1, 0xFDF4
4126 move.w [A5 + D1.w], D0
412A move.w D0, D7
412C muls.w D0, 0xC
4130 addi.w D0, 0xFDF6
4134 clr.w [A5 + D0.w]
4138 subq.w A7, 4
413A syscall TickCount
413C move.w D0, [A5 - 0x10A]
4140 ext.l D0
4142 add.l D0, [A7]+
4144 move.w D1, D7
4146 muls.w D1, 0xC
414A addi.w D1, 0xFDF8
414E move.l [A5 + D1.w], D0
4152 move.w -[A7], 0xD2
4156 jsr [PC - 0x3D86 /* 000003D2 */]
label0000415A:
415A movem.l D6,D7, [A7]+
415E unlink A6
4160 rts
fn00004162:
4162 link A6, -0x0046
4166 movem.l -[A7], D3,D5,D6,D7
416A pea.l [A6 - 0x20]
416E syscall GetKeys
4170 move.b D0, [A5 - 0x3CA]
4174 bra +0x84 /* 000041F8 */
label00004178:
4178 move.w [A5 - 0x114], 0x2
417E move.w [A5 - 0x110], 0x2
4184 move.w [A5 - 0x112], 0x1
418A move.w [A5 - 0x10A], 0x2
4190 move.w [A5 - 0x10E], 0x1
4196 move.w [A5 - 0x10C], 0x7
419C bra +0x68 /* 00004204 */
label0000419E:
419E move.w [A5 - 0x114], 0x3
41A4 cmpi.b [A5 - 0x3C2], 0x4
41AA seq D0
41AC andi.w D0, 0x1
41B0 moveq.l D1, 0x03
41B2 sub.w D1, D0
41B4 move.w [A5 - 0x110], D1
41B8 move.w [A5 - 0x112], 0x2
41BE move.w [A5 - 0x10A], 0x4
41C4 move.w [A5 - 0x10E], 0x1
41CA move.w [A5 - 0x10C], 0x8
41D0 bra +0x34 /* 00004204 */
label000041D2:
41D2 move.w [A5 - 0x114], 0x4
41D8 move.w [A5 - 0x110], 0x4
41DE move.w [A5 - 0x112], 0x3
41E4 move.w [A5 - 0x10A], 0x5
41EA move.w [A5 - 0x10E], 0x2
41F0 move.w [A5 - 0x10C], 0xA /* '\n' */
41F6 bra +0xE /* 00004204 */
label000041F8:
41F8 beq -0x80 /* 00004178 */
41FC subq.b D0, 1
41FE beq -0x2C /* 000041D2 */
4200 subq.b D0, 1
4202 beq -0x64 /* 0000419E */
label00004204:
4204 move.b D0, [A5 - 0x3C2]
4208 bra +0x5B8 /* 000047C0 */
420C clr.b D7
420E moveq.l D0, 0x7B
4210 move.w D1, D0
4212 lsr D1.w, 3
4214 btst [A6 + D1.w - 0x20], D0
4218 sne D0
421A moveq.l D1, 0x00
421C move.w D2, D1
421E lsr D2.w, 3
4220 btst [A6 + D2.w - 0x20], D1
4224 sne D1
4226 or.b D0, D1
4228 beq +0x26 /* 0000424E */
422A tst.b [A5 - 0x3C1]
422E beq +0x10 /* 0000423E */
4230 clr.b [A5 - 0x3C1]
4234 subq.w A7, 4
4236 syscall TickCount
4238 move.l [A5 - 0x108], [A7]+
423C bra +0x12 /* 0000424E */
label0000423E:
423E subq.w A7, 4
4240 syscall TickCount
4242 move.l D0, [A5 - 0x108]
4246 addq.l D0, 2
4248 cmp.l D0, [A7]+
424A bge +0x4 /* 0000424E */
424C moveq.l D7, 0x01
label0000424E:
424E moveq.l D0, 0x7C
4250 move.w D1, D0
4252 lsr D1.w, 3
4254 btst [A6 + D1.w - 0x20], D0
4258 sne D0
425A moveq.l D1, 0x02
425C move.w D2, D1
425E lsr D2.w, 3
4260 btst [A6 + D2.w - 0x20], D1
4264 sne D1
4266 or.b D0, D1
4268 beq +0x2A /* 00004292 */
426A move.b D0, [A5 - 0x3C1]
426E subq.b D0, 1
4270 beq +0x12 /* 00004282 */
4272 move.b [A5 - 0x3C1], 0x1
4278 subq.w A7, 4
427A syscall TickCount
427C move.l [A5 - 0x108], [A7]+
4280 bra +0x12 /* 00004292 */
label00004282:
4282 subq.w A7, 4
4284 syscall TickCount
4286 move.l D0, [A5 - 0x108]
428A addq.l D0, 2
428C cmp.l D0, [A7]+
428E bge +0x4 /* 00004292 */
4290 moveq.l D7, 0x01
label00004292:
4292 moveq.l D0, 0x31
4294 move.w D1, D0
4296 lsr D1.w, 3
4298 btst [A6 + D1.w - 0x20], D0
429C sne D0
429E moveq.l D1, 0x24
42A0 move.w D2, D1
42A2 lsr D2.w, 3
42A4 btst [A6 + D2.w - 0x20], D1
42A8 sne D1
42AA or.b D0, D1
42AC beq +0x4 /* 000042B0 */
42AE moveq.l D7, 0x08
label000042B0:
42B0 moveq.l D0, 0x7D
42B2 move.w D1, D0
42B4 lsr D1.w, 3
42B6 btst [A6 + D1.w - 0x20], D0
42BA sne D0
42BC moveq.l D1, 0x01
42BE move.w D2, D1
42C0 lsr D2.w, 3
42C2 btst [A6 + D2.w - 0x20], D1
42C6 sne D1
42C8 or.b D0, D1
42CA beq +0x4 /* 000042CE */
42CC moveq.l D7, 0x03
label000042CE:
42CE moveq.l D0, 0x7E
42D0 move.w D1, D0
42D2 lsr D1.w, 3
42D4 btst [A6 + D1.w - 0x20], D0
42D8 sne D0
42DA moveq.l D1, 0x0D
42DC move.w D2, D1
42DE lsr D2.w, 3
42E0 btst [A6 + D2.w - 0x20], D1
42E4 sne D1
42E6 or.b D0, D1
42E8 beq +0x4 /* 000042EC */
42EA moveq.l D7, 0x02
label000042EC:
42EC move.w D0, [A5 - 0x3C6]
42F0 muls.w D0, 0xE
42F4 move.w D1, [A5 - 0x3C4]
42F8 addq.w D1, 1
42FA add.w D0, D1
42FC moveq.l D1, 0x00
42FE addi.w D0, 0xFC44
4302 move.b D1, [A5 + D0.w]
4306 move.w -[A7], D1
4308 pea.l [PC + 0x4EA /* 000047F4, value 0xC2994E56 */]
430C pea.l [A6 - 0x46]
4310 move.w -[A7], 0x2
4314 jsr [PC - 0x417C /* 0000019A */]
4318 pea.l [A6 - 0x46]
431C jsr [PC - 0x4138 /* 000001E6 */]
4320 sne D0
4322 move.w D1, [A5 - 0x3C6]
4326 muls.w D1, 0xE
432A move.w D2, [A5 - 0x3C4]
432E add.w D1, D2
4330 addi.w D1, 0xFC44
4334 cmpi.b [A5 + D1.w], 0xE
433A seq D1
433C cmpi.b [A5 - 0x3C2], 0x4
4342 sne D2
4344 and.b D1, D2
4346 addq.b D1, 1
4348 and.b D0, D1
434A beq +0x4 /* 0000434E */
434C moveq.l D7, 0x06
label0000434E:
434E move.w D0, [A5 - 0x3C6]
4352 muls.w D0, 0xE
4356 move.w D1, [A5 - 0x3C4]
435A add.w D0, D1
435C addi.w D0, 0xFC44
4360 cmpi.b [A5 + D0.w], 0xD /* '\r' */
4366 bne +0x4 /* 0000436A */
4368 moveq.l D7, 0x07
label0000436A:
436A move.w D0, [A5 - 0x3C6]
436E muls.w D0, 0xE
4372 move.w D1, [A5 - 0x3C4]
4376 add.w D0, D1
4378 addi.w D0, 0xFC44
437C cmpi.b [A5 + D0.w], 0x7
4382 bne +0x10 /* 00004392 */
4384 moveq.l D7, 0x0B
4386 move.w -[A7], 0xCD
438A jsr [PC - 0x3FBA /* 000003D2 */]
438E bra +0x7A /* 00004408 */
label00004392:
4392 move.w D0, [A5 - 0x3C6]
4396 muls.w D0, 0xE
439A move.w D1, [A5 - 0x3C4]
439E addq.w D1, 1
43A0 add.w D0, D1
43A2 addi.w D0, 0xFC44
43A6 cmpi.b [A5 + D0.w], 0x8
43AC bne +0xE /* 000043BA */
43AE moveq.l D7, 0x0B
43B0 move.w -[A7], 0xCE
43B4 jsr [PC - 0x3FE4 /* 000003D2 */]
43B8 bra +0x50 /* 00004408 */
label000043BA:
43BA move.w D0, [A5 - 0x3C6]
43BE muls.w D0, 0xE
43C2 move.w D1, [A5 - 0x3C4]
43C6 add.w D0, D1
43C8 addi.w D0, 0xFC44
43CC cmpi.b [A5 + D0.w], 0xF
43D2 seq D0
43D4 move.b D1, [A5 - 0x3C0]
43D8 subq.b D1, 1
43DA and.b D0, D1
43DC beq +0xE /* 000043EA */
43DE moveq.l D7, 0x0D
43E0 move.w -[A7], 0xD7
43E4 jsr [PC - 0x4014 /* 000003D2 */]
43E8 bra +0x20 /* 00004408 */
label000043EA:
43EA move.w D0, [A5 - 0x3C6]
43EE subq.w D0, 1
43F0 muls.w D0, 0xE
43F4 move.w D1, [A5 - 0x3C4]
43F8 add.w D0, D1
43FA addi.w D0, 0xFC44
43FE cmpi.b [A5 + D0.w], 0x10
4404 bne +0x4 /* 00004408 */
4406 moveq.l D7, 0x0F
label00004408:
4408 cmpi.b [A5 - 0x3C2], 0x4
440E seq D0
4410 moveq.l D1, 0x00
4412 move.b D1, D7
4414 move.w -[A7], D1
4416 pea.l [PC + 0x3DA /* 000047F2, value 0x8C0C299 */]
441A pea.l [A6 - 0x46]
441E move.w -[A7], 0x2
4422 jsr [PC - 0x428A /* 0000019A */]
4426 pea.l [A6 - 0x46]
442A jsr [PC - 0x4246 /* 000001E6 */]
442E seq D1
4430 and.b D0, D1
4432 beq +0x3AE /* 000047E0 */
4436 move.w -[A7], 0xD4
443A jsr [PC - 0x406A /* 000003D2 */]
443E bra +0x3A2 /* 000047E0 */
4442 moveq.l D7, 0x05
4444 moveq.l D0, 0x7D
4446 move.w D1, D0
4448 lsr D1.w, 3
444A btst [A6 + D1.w - 0x20], D0
444E sne D0
4450 moveq.l D1, 0x01
4452 move.w D2, D1
4454 lsr D2.w, 3
4456 btst [A6 + D2.w - 0x20], D1
445A sne D1
445C or.b D0, D1
445E beq +0x4 /* 00004462 */
4460 moveq.l D7, 0x04
label00004462:
4462 moveq.l D0, 0x7E
4464 move.w D1, D0
4466 lsr D1.w, 3
4468 btst [A6 + D1.w - 0x20], D0
446C sne D0
446E moveq.l D1, 0x0D
4470 move.w D2, D1
4472 lsr D2.w, 3
4474 btst [A6 + D2.w - 0x20], D1
4478 sne D1
447A or.b D0, D1
447C beq +0x4 /* 00004480 */
447E moveq.l D7, 0x05
label00004480:
4480 moveq.l D0, 0x31
4482 move.w D1, D0
4484 lsr D1.w, 3
4486 btst [A6 + D1.w - 0x20], D0
448A sne D0
448C moveq.l D1, 0x24
448E move.w D2, D1
4490 lsr D2.w, 3
4492 btst [A6 + D2.w - 0x20], D1
4496 sne D1
4498 or.b D0, D1
449A moveq.l D1, 0x7D
449C move.w D2, D1
449E lsr D2.w, 3
44A0 btst [A6 + D2.w - 0x20], D1
44A4 sne D1
44A6 moveq.l D2, 0x01
44A8 move.w D3, D2
44AA lsr D3.w, 3
44AC btst [A6 + D3.w - 0x20], D2
44B0 sne D2
44B2 or.b D1, D2
44B4 and.b D0, D1
44B6 beq +0x4 /* 000044BA */
44B8 moveq.l D7, 0x09
label000044BA:
44BA move.w D0, [A5 - 0x3C6]
44BE muls.w D0, 0xE
44C2 move.w D1, [A5 - 0x3C4]
44C6 addq.w D1, 1
44C8 add.w D0, D1
44CA moveq.l D1, 0x00
44CC addi.w D0, 0xFC44
44D0 move.b D1, [A5 + D0.w]
44D4 move.w -[A7], D1
44D6 pea.l [PC + 0x318 /* 000047F0, value 0xC29908C0 */]
44DA pea.l [A6 - 0x46]
44DE move.w -[A7], 0x2
44E2 jsr [PC - 0x434A /* 0000019A */]
44E6 pea.l [A6 - 0x46]
44EA jsr [PC - 0x4306 /* 000001E6 */]
44EE sne D0
44F0 move.w D1, [A5 - 0x3C6]
44F4 muls.w D1, 0xE
44F8 move.w D2, [A5 - 0x3C4]
44FC add.w D1, D2
44FE addi.w D1, 0xFC44
4502 cmpi.b [A5 + D1.w], 0xE
4508 sne D1
450A and.b D0, D1
450C beq +0x4 /* 00004510 */
450E moveq.l D7, 0x06
label00004510:
4510 move.w D0, [A5 - 0x3C6]
4514 muls.w D0, 0xE
4518 move.w D1, [A5 - 0x3C4]
451C add.w D0, D1
451E addi.w D0, 0xFC44
4522 cmpi.b [A5 + D0.w], 0xD /* '\r' */
4528 bne +0x4 /* 0000452C */
452A moveq.l D7, 0x07
label0000452C:
452C move.w D0, [A5 - 0x3C6]
4530 muls.w D0, 0xE
4534 move.w D1, [A5 - 0x3C4]
4538 add.w D0, D1
453A addi.w D0, 0xFC44
453E cmpi.b [A5 + D0.w], 0x7
4544 bne +0x10 /* 00004554 */
4546 moveq.l D7, 0x0B
4548 move.w -[A7], 0xCD
454C jsr [PC - 0x417C /* 000003D2 */]
4550 bra +0x290 /* 000047E0 */
label00004554:
4554 move.w D0, [A5 - 0x3C6]
4558 muls.w D0, 0xE
455C move.w D1, [A5 - 0x3C4]
4560 addq.w D1, 1
4562 add.w D0, D1
4564 addi.w D0, 0xFC44
4568 cmpi.b [A5 + D0.w], 0x8
456E bne +0x10 /* 0000457E */
4570 moveq.l D7, 0x0B
4572 move.w -[A7], 0xCE
4576 jsr [PC - 0x41A6 /* 000003D2 */]
457A bra +0x266 /* 000047E0 */
label0000457E:
457E move.w D0, [A5 - 0x3C6]
4582 muls.w D0, 0xE
4586 move.w D1, [A5 - 0x3C4]
458A add.w D0, D1
458C addi.w D0, 0xFC44
4590 cmpi.b [A5 + D0.w], 0xF
4596 seq D0
4598 move.b D1, [A5 - 0x3C0]
459C subq.b D1, 1
459E and.b D0, D1
45A0 beq +0x240 /* 000047E0 */
45A4 moveq.l D7, 0x0D
45A6 move.w -[A7], 0xD7
45AA jsr [PC - 0x41DA /* 000003D2 */]
45AE bra +0x232 /* 000047E0 */
45B2 clr.b D7
45B4 moveq.l D0, 0x7E
45B6 move.w D1, D0
45B8 lsr D1.w, 3
45BA btst [A6 + D1.w - 0x20], D0
45BE sne D0
45C0 moveq.l D1, 0x0D
45C2 move.w D2, D1
45C4 lsr D2.w, 3
45C6 btst [A6 + D2.w - 0x20], D1
45CA sne D1
45CC or.b D0, D1
45CE beq +0x4 /* 000045D2 */
45D0 moveq.l D7, 0x02
label000045D2:
45D2 moveq.l D0, 0x7B
45D4 move.w D1, D0
45D6 lsr D1.w, 3
45D8 btst [A6 + D1.w - 0x20], D0
45DC sne D0
45DE moveq.l D1, 0x00
45E0 move.w D2, D1
45E2 lsr D2.w, 3
45E4 btst [A6 + D2.w - 0x20], D1
45E8 sne D1
45EA or.b D0, D1
45EC beq +0x6 /* 000045F2 */
45EE clr.b [A5 - 0x3C1]
label000045F2:
45F2 moveq.l D0, 0x7C
45F4 move.w D1, D0
45F6 lsr D1.w, 3
45F8 btst [A6 + D1.w - 0x20], D0
45FC sne D0
45FE moveq.l D1, 0x02
4600 move.w D2, D1
4602 lsr D2.w, 3
4604 btst [A6 + D2.w - 0x20], D1
4608 sne D1
460A or.b D0, D1
460C beq +0x8 /* 00004614 */
460E move.b [A5 - 0x3C1], 0x1
label00004614:
4614 moveq.l D0, 0x31
4616 move.w D1, D0
4618 lsr D1.w, 3
461A btst [A6 + D1.w - 0x20], D0
461E sne D0
4620 moveq.l D1, 0x24
4622 move.w D2, D1
4624 lsr D2.w, 3
4626 btst [A6 + D2.w - 0x20], D1
462A sne D1
462C or.b D0, D1
462E moveq.l D1, 0x7E
4630 move.w D2, D1
4632 lsr D2.w, 3
4634 btst [A6 + D2.w - 0x20], D1
4638 sne D1
463A moveq.l D2, 0x0D
463C move.w D3, D2
463E lsr D3.w, 3
4640 btst [A6 + D3.w - 0x20], D2
4644 sne D2
4646 or.b D1, D2
4648 and.b D0, D1
464A beq +0x4 /* 0000464E */
464C moveq.l D7, 0x0A
label0000464E:
464E move.w D0, [A5 - 0x3C6]
4652 muls.w D0, 0xE
4656 move.w D1, [A5 - 0x3C4]
465A add.w D0, D1
465C addi.w D0, 0xFC44
4660 cmpi.b [A5 + D0.w], 0x4
4666 bne +0x4 /* 0000466A */
4668 moveq.l D7, 0x0E
label0000466A:
466A move.w D0, [A5 - 0x3C6]
466E muls.w D0, 0xE
4672 move.w D1, [A5 - 0x3C4]
4676 addq.w D1, 1
4678 add.w D0, D1
467A moveq.l D1, 0x00
467C addi.w D0, 0xFC44
4680 move.b D1, [A5 + D0.w]
4684 move.w -[A7], D1
4686 pea.l [PC + 0x166 /* 000047EE, value 0xC299C299 */]
468A pea.l [A6 - 0x46]
468E move.w -[A7], 0x2
4692 jsr [PC - 0x44FA /* 0000019A */]
4696 pea.l [A6 - 0x46]
469A jsr [PC - 0x44B6 /* 000001E6 */]
469E sne D0
46A0 move.w D1, [A5 - 0x3C6]
46A4 muls.w D1, 0xE
46A8 move.w D2, [A5 - 0x3C4]
46AC add.w D1, D2
46AE addi.w D1, 0xFC44
46B2 cmpi.b [A5 + D1.w], 0xE
46B8 sne D1
46BA and.b D0, D1
46BC beq +0x4 /* 000046C0 */
46BE moveq.l D7, 0x06
label000046C0:
46C0 move.w D0, [A5 - 0x3C6]
46C4 muls.w D0, 0xE
46C8 move.w D1, [A5 - 0x3C4]
46CC add.w D0, D1
46CE addi.w D0, 0xFC44
46D2 cmpi.b [A5 + D0.w], 0xD /* '\r' */
46D8 seq D0
46DA move.w D1, [A5 - 0x3C6]
46DE muls.w D1, 0xE
46E2 move.w D2, [A5 - 0x3C4]
46E6 subq.w D2, 1
46E8 add.w D1, D2
46EA addi.w D1, 0xFC44
46EE cmpi.b [A5 + D1.w], 0xD /* '\r' */
46F4 seq D1
46F6 or.b D0, D1
46F8 beq +0x4 /* 000046FC */
46FA moveq.l D7, 0x07
label000046FC:
46FC move.w D0, [A5 - 0x3C6]
4700 muls.w D0, 0xE
4704 move.w D1, [A5 - 0x3C4]
4708 add.w D0, D1
470A addi.w D0, 0xFC44
470E cmpi.b [A5 + D0.w], 0x7
4714 bne +0x10 /* 00004724 */
4716 moveq.l D7, 0x0B
4718 move.w -[A7], 0xCD
471C jsr [PC - 0x434C /* 000003D2 */]
4720 bra +0xC0 /* 000047E0 */
label00004724:
4724 move.w D0, [A5 - 0x3C6]
4728 muls.w D0, 0xE
472C move.w D1, [A5 - 0x3C4]
4730 addq.w D1, 1
4732 add.w D0, D1
4734 addi.w D0, 0xFC44
4738 cmpi.b [A5 + D0.w], 0x8
473E bne +0x10 /* 0000474E */
4740 moveq.l D7, 0x0B
4742 move.w -[A7], 0xCE
4746 jsr [PC - 0x4376 /* 000003D2 */]
474A bra +0x96 /* 000047E0 */
label0000474E:
474E move.w D0, [A5 - 0x3C6]
4752 muls.w D0, 0xE
4756 move.w D1, [A5 - 0x3C4]
475A add.w D0, D1
475C addi.w D0, 0xFC44
4760 cmpi.b [A5 + D0.w], 0xF
4766 seq D0
4768 move.b D1, [A5 - 0x3C0]
476C subq.b D1, 1
476E and.b D0, D1
4770 beq +0x70 /* 000047E0 */
4774 moveq.l D7, 0x0D
4776 move.w -[A7], 0xD7
477A jsr [PC - 0x43AA /* 000003D2 */]
477E bra +0x62 /* 000047E0 */
4780 moveq.l D7, 0x0C
4782 move.w [A5 - 0x3C6], 0x1
4788 move.w [A5 - 0x3C4], 0x1
478E moveq.l D5, 0x01
label00004790:
4790 moveq.l D6, 0x01
label00004792:
4792 move.w D0, D5
4794 muls.w D0, 0xE
4798 add.w D0, D6
479A addi.w D0, 0xFC44
479E cmpi.b [A5 + D0.w], 0x3
47A4 bne +0xA /* 000047AE */
47A6 move.w [A5 - 0x3C6], D5
47AA move.w [A5 - 0x3C4], D6
label000047AE:
47AE addq.w D6, 1
47B0 cmpi.w D6, 0xC
47B4 ble -0x22 /* 00004792 */
47B6 addq.w D5, 1
47B8 cmpi.w D5, 0x10
47BC ble -0x2C /* 00004790 */
47BE bra +0x22 /* 000047E0 */
label000047C0:
47C0 andi.w D0, 0xFF
47C4 cmpi.w D0, 0x6
47C8 bcc +0x18 /* 000047E0 */
47CA add.w D0, D0
47CC move.w D0, [PC + D0.w + 0x6]
47D0 jmp [PC + D0.w + 0x2]
47D4 .unknown 0xFA38 0xFA38 (W = 5)
47D8 .invalid <<F/7/6>>
47DA .extension 0xC6E <<F/1/6>>, 0xFA38 // unimplemented
47DE .invalid <<F/6/7>>
label000047E0:
47E0 move.b -[A7], D7
47E2 jsr [PC - 0x2518 /* 000022CC */]
47E6 movem.l D3,D5,D6,D7, [A7]+
47EA unlink A6
47EC rts
47EE and.l D1, [A1]+
47F0 and.l D1, [A1]+
47F2 bset.b D0, 0x99
fn000047F6:
47F6 link A6, -0x0052
47FA move.l -[A7], A4
47FC bra +0x38 /* 00004834 */
47FE move.b D0, [A5 - 0x3BE]
4802 bra +0x28 /* 0000482A */
label00004804:
4804 move.b [A5 - 0x3BD], [A5 - 0x3BE]
480A bra +0x2A /* 00004834 */
label0000480C:
480C subq.w A7, 2
480E move.w -[A7], 0x2
4812 jsr [PC - 0x4490 /* 00000384 */]
4816 cmpi.w [A7]+, 0x1
481A bne +0xA /* 00004824 */
481C move.b [A5 - 0x3BD], 0x1
4822 bra +0x12 /* 00004834 */
label00004824:
4824 clr.b [A5 - 0x3BD]
4828 bra +0xC /* 00004834 */
label0000482A:
482A beq -0x26 /* 00004804 */
482C subq.b D0, 1
482E beq -0x2A /* 00004804 */
4830 subq.b D0, 1
4832 beq -0x26 /* 0000480C */
label00004834:
4834 cmpi.w [A5 - 0x3CC], 0x1A
483A bge +0x8 /* 00004842 */
483C clr.b [A5 - 0x3BD]
4840 bra +0x8 /* 00004848 */
label00004842:
4842 move.b [A5 - 0x3BD], 0x1
label00004848:
4848 subq.w A7, 4
484A cmpi.b [A5 - 0x3BD], 0x1
4850 seq D0
4852 andi.w D0, 0x1
4856 muls.w D0, 0x3
485A addi.w D0, 0x82
485E move.w -[A7], D0
4860 syscall GetPicture
4862 movea.l A4, [A7]+
4864 pea.l [A6 - 0x1C]
4868 clr.w -[A7]
486A clr.w -[A7]
486C movea.l A0, [A4]
486E movea.l A1, [A4]
4870 move.w D0, [A0 + 0x8]
4874 sub.w D0, [A1 + 0x4]
4878 move.w -[A7], D0
487A movea.l A0, [A4]
487C movea.l A1, [A4]
487E move.w D0, [A0 + 0x6]
4882 sub.w D0, [A1 + 0x2]
4886 move.w -[A7], D0
4888 syscall SetRect
488A subq.w A7, 4
488C pea.l [A5 - 0x44E]
4890 move.w -[A7], 0x8
4894 pea.l [A6 - 0x1C]
4898 clr.l -[A7]
489A clr.l -[A7]
489C clr.l [A6 - 0x2E]
48A0 move.l -[A7], [A6 - 0x2E]
48A4 move.l D0, 0x160003
48AA syscall QDExtensions
48AC move.l D0, [A7]+
48AE move.l [A6 - 0x32], D0
48B2 pea.l [A6 - 0x32]
48B6 pea.l [A6 - 0x52]
48BA move.w -[A7], 0x4
48BE jsr [PC - 0x4726 /* 0000019A */]
48C2 move.l [A6 - 0x20], [A6 - 0x36]
48C8 move.l -[A7], [A5 - 0x44E]
48CC clr.l -[A7]
48CE move.l D0, 0x80006
48D4 syscall QDExtensions
48D6 move.l -[A7], A4
48D8 pea.l [A6 - 0x1C]
48DC syscall DrawPicture
48DE move.l -[A7], A4
48E0 syscall ReleaseResource
48E2 subq.w A7, 4
48E4 cmpi.b [A5 - 0x3BD], 0x1
48EA seq D0
48EC andi.w D0, 0x1
48F0 muls.w D0, 0x3
48F4 addi.w D0, 0x81
48F8 move.w -[A7], D0
48FA syscall GetPicture
48FC movea.l A4, [A7]+
48FE pea.l [A6 - 0x1C]
4902 clr.w -[A7]
4904 clr.w -[A7]
4906 movea.l A0, [A4]
4908 movea.l A1, [A4]
490A move.w D0, [A0 + 0x8]
490E sub.w D0, [A1 + 0x4]
4912 move.w -[A7], D0
4914 movea.l A0, [A4]
4916 movea.l A1, [A4]
4918 move.w D0, [A0 + 0x6]
491C sub.w D0, [A1 + 0x2]
4920 move.w -[A7], D0
4922 syscall SetRect
4924 subq.w A7, 4
4926 pea.l [A5 - 0x44A]
492A move.w -[A7], 0x1
492E pea.l [A6 - 0x1C]
4932 clr.l -[A7]
4934 clr.l -[A7]
4936 clr.l [A6 - 0x2E]
493A move.l -[A7], [A6 - 0x2E]
493E move.l D0, 0x160003
4944 syscall QDExtensions
4946 move.l D0, [A7]+
4948 move.l [A6 - 0x32], D0
494C pea.l [A6 - 0x32]
4950 pea.l [A6 - 0x52]
4954 move.w -[A7], 0x4
4958 jsr [PC - 0x47C0 /* 0000019A */]
495C move.l [A6 - 0x20], [A6 - 0x36]
4962 move.l -[A7], [A5 - 0x44A]
4966 clr.l -[A7]
4968 move.l D0, 0x80006
496E syscall QDExtensions
4970 move.l -[A7], A4
4972 pea.l [A6 - 0x1C]
4976 syscall DrawPicture
4978 pea.l [A6 - 0x1C]
497C syscall InvertRect
497E subq.w A7, 2
4980 move.l -[A7], [A5 - 0x442]
4984 movea.l A0, [A5 - 0x44A]
4988 pea.l [A0 + 0x2]
498C syscall BitMapToRegion/BitMapRgn
498E move.w [A6 - 0x22], [A7]+
4992 subq.w A7, 4
4994 pea.l [A5 - 0x44A]
4998 move.w -[A7], 0x8
499C pea.l [A6 - 0x1C]
49A0 clr.l -[A7]
49A2 clr.l -[A7]
49A4 clr.l [A6 - 0x2E]
49A8 move.l -[A7], [A6 - 0x2E]
49AC move.l D0, 0x160003
49B2 syscall QDExtensions
49B4 move.l D0, [A7]+
49B6 move.l [A6 - 0x32], D0
49BA pea.l [A6 - 0x32]
49BE pea.l [A6 - 0x52]
49C2 move.w -[A7], 0x4
49C6 jsr [PC - 0x482E /* 0000019A */]
49CA move.l [A6 - 0x20], [A6 - 0x36]
49D0 move.l -[A7], [A5 - 0x44A]
49D4 clr.l -[A7]
49D6 move.l D0, 0x80006
49DC syscall QDExtensions
49DE move.l -[A7], A4
49E0 syscall ReleaseResource
49E2 subq.w A7, 4
49E4 cmpi.b [A5 - 0x3BD], 0x1
49EA seq D0
49EC andi.w D0, 0x1
49F0 muls.w D0, 0x3
49F4 addi.w D0, 0x80
49F8 move.w -[A7], D0
49FA syscall GetPicture
49FC movea.l A4, [A7]+
49FE move.l -[A7], A4
4A00 pea.l [A6 - 0x1C]
4A04 syscall DrawPicture
4A06 move.l -[A7], A4
4A08 syscall ReleaseResource
4A0A move.l -[A7], [A5 - 0x432]
4A0E move.l -[A7], [A5 - 0x42E]
4A12 move.l D0, 0x80006
4A18 syscall QDExtensions
4A1A movea.l A4, [A7]+
4A1C unlink A6
4A1E rts
fn00004A20:
4A20 link A6, -0x0012
4A24 move.l -[A7], D7
4A26 tst.b [A5 - 0x437]
4A2A beq +0x18 /* 00004A42 */
4A2C jsr [PC - 0x4676 /* 000003B8 */]
4A30 move.b D0, [A5 - 0x439]
4A34 subq.b D0, 1
4A36 beq +0xC6 /* 00004AFC */
4A3A jsr [PC - 0x3F30 /* 00000B0C */]
4A3E bra +0xBE /* 00004AFC */
label00004A42:
4A42 jsr [PC - 0x469A /* 000003AA */]
4A46 move.l -[A7], [A5 - 0x432]
4A4A move.l -[A7], [A5 - 0x42E]
4A4E move.l D0, 0x80006
4A54 syscall QDExtensions
4A56 move.b D0, [A5 - 0x206]
4A5A subq.b D0, 1
4A5C beq +0x26 /* 00004A82 */
4A5E movea.l A0, [A5 - 0x456]
4A62 pea.l [A0 + 0x2]
4A66 movea.l A0, [A5 - 0x432]
4A6A pea.l [A0 + 0x2]
4A6E pea.l [A5 - 0x42A]
4A72 pea.l [A5 - 0x42A]
4A76 clr.w -[A7]
4A78 clr.l -[A7]
4A7A syscall CopyBits
4A7C move.b [A5 - 0x206], 0x1
label00004A82:
4A82 jsr [PC - 0x922 /* 00004162 */]
4A86 move.w D0, [A5 - 0x3C6]
4A8A muls.w D0, 0xE
4A8E move.w D1, [A5 - 0x3C4]
4A92 addq.w D1, 1
4A94 add.w D0, D1
4A96 addi.w D0, 0xFC44
4A9A cmpi.b [A5 + D0.w], 0xA /* '\n' */
4AA0 seq D0
4AA2 cmpi.b [A5 - 0x3C2], 0x5
4AA8 sne D1
4AAA and.b D0, D1
4AAC beq +0x6 /* 00004AB2 */
4AAE jsr [PC - 0xA10 /* 000040A0 */]
label00004AB2:
4AB2 moveq.l D7, 0x01
label00004AB4:
4AB4 move.w D0, D7
4AB6 muls.w D0, 0xC
4ABA move.w D1, D7
4ABC muls.w D1, 0xC
4AC0 move.l -[A7], D0
4AC2 move.l -[A7], D1
4AC4 subq.w A7, 4
4AC6 syscall TickCount
4AC8 move.l D2, [A7]+
4ACA move.l D1, [A7]+
4ACC move.l D0, [A7]+
4ACE addi.w D1, 0xFDF8
4AD2 cmp.l D2, [A5 + D1.w]
4AD6 sge D1
4AD8 addi.w D0, 0xFDF0
4ADC and.b D1, [A5 + D0.w]
4AE0 beq +0x14 /* 00004AF4 */
4AE2 move.w D0, D7
4AE4 muls.w D0, 0xC
4AE8 addi.w D0, 0xFDF0
4AEC pea.l [A5 + D0.w]
4AF0 jsr [PC - 0x28FC /* 000021F6 */]
label00004AF4:
4AF4 addq.w D7, 1
4AF6 cmpi.w D7, 0x14
4AFA ble -0x46 /* 00004AB4 */
label00004AFC:
4AFC move.l D7, [A7]+
4AFE unlink A6
4B00 rts
fn00004B02:
4B02 link A6, -0x0014
4B06 move.l -[A7], D7
4B08 moveq.l D7, 0x01
label00004B0A:
4B0A move.w D0, D7
4B0C muls.w D0, 0xC
4B10 addi.w D0, 0xFDF0
4B14 clr.b [A5 + D0.w]
4B18 addq.w D7, 1
4B1A cmpi.w D7, 0x14
4B1E ble -0x14 /* 00004B0A */
4B20 move.w [A5 - 0x3C6], 0x1
4B26 move.w [A5 - 0x3C4], 0x1
4B2C move.b [A5 - 0x3C2], 0x5
4B32 subq.w A7, 2
4B34 syscall Random
4B36 move.w D0, [A7]+
4B38 ext.l D0
4B3A divs.w D0, 0x2
4B3E swap.w D0
4B40 tst.w D0
4B42 bpl +0x4 /* 00004B46 */
4B44 neg.w D0
label00004B46:
4B46 subq.w D0, 1
4B48 seq D0
4B4A neg.b D0
4B4C move.b [A5 - 0x3C1], D0
4B50 move.l D7, [A7]+
4B52 unlink A6
4B54 move.l [A7], [A7]+
4B56 rts
fn00004B58:
4B58 link A6, -0x0050
4B5C movem.l -[A7], D3,D4,D5,D6,D7,A3,A4
4B60 move.w D4, [A6 + 0xC]
4B64 move.l -[A7], [A5 - 0x432]
4B68 move.l -[A7], [A5 - 0x42E]
4B6C move.l D0, 0x80006
4B72 syscall QDExtensions
4B74 tst.b [A6 + 0xA]
4B78 beq +0x6 /* 00004B7E */
4B7A jsr [PC - 0x386 /* 000047F6 */]
label00004B7E:
4B7E move.w [A5 - 0x3CC], D4
4B82 clr.b [A5 - 0x438]
4B86 subq.w A7, 4
4B88 move.w D0, D4
4B8A addi.w D0, 0xC8
4B8E move.w -[A7], D0
4B90 syscall GetPicture
4B92 movea.l A4, [A7]+
4B94 move.w D7, D4
4B96 addi.w D7, 0xC8
4B9A bra +0xC /* 00004BA6 */
label00004B9C:
4B9C subq.w D7, 1
4B9E subq.w A7, 4
4BA0 move.w -[A7], D7
4BA2 syscall GetPicture
4BA4 movea.l A4, [A7]+
label00004BA6:
4BA6 move.l D0, A4
4BA8 beq -0xC /* 00004B9C */
4BAA move.l -[A7], [A5 - 0x446]
4BAE syscall SetEmptyRgn
4BB0 move.l -[A7], [A5 - 0x452]
4BB4 clr.l -[A7]
4BB6 move.l D0, 0x80006
4BBC syscall QDExtensions
4BBE clr.w D6
label00004BC0:
4BC0 clr.w D7
label00004BC2:
4BC2 move.w D0, D6
4BC4 muls.w D0, 0xE
4BC8 add.w D0, D7
4BCA addi.w D0, 0xFC44
4BCE clr.b [A5 + D0.w]
4BD2 tst.w D7
4BD4 seq D0
4BD6 tst.w D6
4BD8 seq D1
4BDA or.b D0, D1
4BDC cmpi.w D6, 0x11
4BE0 seq D1
4BE2 or.b D0, D1
4BE4 beq +0x14 /* 00004BF8 */
4BE6 move.w D0, D6
4BE8 muls.w D0, 0xE
4BEC add.w D0, D7
4BEE addi.w D0, 0xFC44
4BF2 move.b [A5 + D0.w], 0x2
label00004BF8:
4BF8 addq.w D7, 1
4BFA cmpi.w D7, 0xD /* '\r' */
4BFE ble -0x3C /* 00004BC2 */
4C00 addq.w D6, 1
4C02 cmpi.w D6, 0x11
4C06 ble -0x46 /* 00004BC0 */
4C08 move.l -[A7], A4
4C0A syscall ReleaseResource
4C0C subq.w A7, 4
4C0E move.l -[A7], 0x54455854 /* 'TEXT' */
4C14 move.w D0, D4
4C16 addi.w D0, 0xC8
4C1A move.w -[A7], D0
4C1C syscall GetResource
4C1E movea.l A3, [A7]+
4C20 moveq.l D5, 0xFFFFFFFE
4C22 moveq.l D7, 0x01
label00004C24:
4C24 addq.w D5, 1
4C26 moveq.l D6, 0x01
label00004C28:
4C28 addq.w D5, 1
4C2A movea.l A0, [A3]
4C2C moveq.l D3, 0x00
4C2E move.b D3, [A0 + D5.w]
4C32 move.w -[A7], D3
4C34 pea.l [PC + 0xFA /* 00004D30, value 0x10200, cstring "" */]
4C38 pea.l [A6 - 0x50]
4C3C move.w -[A7], 0x8
4C40 jsr [PC - 0x4AA8 /* 0000019A */]
4C44 pea.l [A6 - 0x50]
4C48 jsr [PC - 0x4A64 /* 000001E6 */]
4C4C bne +0x42 /* 00004C8E */
4C4E pea.l [A6 - 0x1C]
4C52 move.w -[A7], D6
4C54 move.w -[A7], D7
4C56 clr.w -[A7]
4C58 jsr [PC - 0x117C /* 00003ADE */]
4C5C move.l -[A7], [A5 - 0x43E]
4C60 pea.l [A6 - 0x1C]
4C64 syscall RectRgn
4C66 move.l -[A7], [A5 - 0x446]
4C6A move.l -[A7], [A5 - 0x43E]
4C6E move.l -[A7], [A5 - 0x446]
4C72 syscall UnionRgn
4C74 move.w -[A7], D3
4C76 move.w D0, D6
4C78 muls.w D0, 0xE
4C7C add.w D0, D7
4C7E addi.w D0, 0xFC44
4C82 pea.l [A5 + D0.w]
4C86 pea.l [A6 - 0x1C]
4C8A jsr [PC - 0xECE /* 00003DBE */]
label00004C8E:
4C8E addq.w D6, 1
4C90 cmpi.w D6, 0x10
4C94 ble -0x6C /* 00004C28 */
4C96 addq.w D7, 1
4C98 cmpi.w D7, 0xC
4C9C ble -0x78 /* 00004C24 */
4C9E move.l -[A7], A3
4CA0 syscall ReleaseResource
4CA2 clr.l [A5 - 0x20A]
4CA6 move.l -[A7], A6
4CA8 jsr [PC - 0x1A8 /* 00004B02 */]
4CAC move.l -[A7], [A5 - 0x456]
4CB0 clr.l -[A7]
4CB2 move.l D0, 0x80006
4CB8 syscall QDExtensions
4CBA pea.l [A5 - 0x42A]
4CBE syscall PaintRect
4CC0 movea.l A0, [A5 - 0x452]
4CC4 pea.l [A0 + 0x2]
4CC8 movea.l A0, [A5 - 0x456]
4CCC pea.l [A0 + 0x2]
4CD0 pea.l [A5 - 0x42A]
4CD4 pea.l [A5 - 0x42A]
4CD8 clr.w -[A7]
4CDA move.l -[A7], [A5 - 0x446]
4CDE syscall CopyBits
4CE0 move.l -[A7], [A5 - 0x432]
4CE4 move.l -[A7], [A5 - 0x42E]
4CE8 move.l D0, 0x80006
4CEE syscall QDExtensions
4CF0 clr.b [A5 - 0x206]
4CF4 move.b [A5 - 0x205], 0x1
4CFA move.w -[A7], [A5 - 0x3CC]
4CFE move.b -[A7], [A6 + 0x8]
4D02 jsr [PC - 0x30EA /* 00001C1A */]
4D06 movea.l A0, [A5 - 0x456]
4D0A pea.l [A0 + 0x2]
4D0E movea.l A0, [A5 - 0x432]
4D12 pea.l [A0 + 0x2]
4D16 pea.l [A5 - 0x42A]
4D1A pea.l [A5 - 0x42A]
4D1E clr.w -[A7]
4D20 clr.l -[A7]
4D22 syscall CopyBits
4D24 movem.l D3,D4,D5,D6,D7,A3,A4, [A7]+
4D28 unlink A6
4D2A movea.l A0, [A7]+
4D2C addq.w A7, 6
4D2E jmp [A0]
4D30 ori.b D1, 0x0
4D34 ori.b D0, 0x0
fn00004D38:
4D38 link A6, -0x0056
4D3C movem.l -[A7], D5,D6,D7,A4
4D40 subq.w A7, 4
4D42 move.w -[A7], 0x82
4D46 syscall GetPicture
4D48 movea.l A4, [A7]+
4D4A pea.l [A6 - 0x1C]
4D4E clr.w -[A7]
4D50 clr.w -[A7]
4D52 movea.l A0, [A4]
4D54 movea.l A1, [A4]
4D56 move.w D0, [A0 + 0x8]
4D5A sub.w D0, [A1 + 0x4]
4D5E move.w -[A7], D0
4D60 movea.l A0, [A4]
4D62 movea.l A1, [A4]
4D64 move.w D0, [A0 + 0x6]
4D68 sub.w D0, [A1 + 0x2]
4D6C move.w -[A7], D0
4D6E syscall SetRect
4D70 subq.w A7, 2
4D72 pea.l [A5 - 0x44E]
4D76 move.w -[A7], 0x8
4D7A pea.l [A6 - 0x1C]
4D7E clr.l -[A7]
4D80 clr.l -[A7]
4D82 clr.l [A6 - 0x32]
4D86 move.l -[A7], [A6 - 0x32]
4D8A move.l D0, 0x160000
4D90 syscall QDExtensions
4D92 move.w D6, [A7]+
4D94 subq.w A7, 2
4D96 subq.w A7, 4
4D98 move.l -[A7], [A5 - 0x44E]
4D9C move.l D0, 0x40017
4DA2 syscall QDExtensions
4DA4 move.l D0, 0x40001
4DAA syscall QDExtensions
4DAC move.b D7, [A7]+
4DAE move.l -[A7], [A5 - 0x44E]
4DB2 clr.l -[A7]
4DB4 move.l D0, 0x80006
4DBA syscall QDExtensions
4DBC move.l -[A7], A4
4DBE pea.l [A6 - 0x1C]
4DC2 syscall DrawPicture
4DC4 move.l -[A7], A4
4DC6 syscall ReleaseResource
4DC8 subq.w A7, 4
4DCA move.w -[A7], 0x81
4DCE syscall GetPicture
4DD0 movea.l A4, [A7]+
4DD2 pea.l [A6 - 0x1C]
4DD6 clr.w -[A7]
4DD8 clr.w -[A7]
4DDA movea.l A0, [A4]
4DDC movea.l A1, [A4]
4DDE move.w D0, [A0 + 0x8]
4DE2 sub.w D0, [A1 + 0x4]
4DE6 move.w -[A7], D0
4DE8 movea.l A0, [A4]
4DEA movea.l A1, [A4]
4DEC move.w D0, [A0 + 0x6]
4DF0 sub.w D0, [A1 + 0x2]
4DF4 move.w -[A7], D0
4DF6 syscall SetRect
4DF8 subq.w A7, 2
4DFA pea.l [A5 - 0x44A]
4DFE move.w -[A7], 0x1
4E02 pea.l [A6 - 0x1C]
4E06 clr.l -[A7]
4E08 clr.l -[A7]
4E0A clr.l [A6 - 0x32]
4E0E move.l -[A7], [A6 - 0x32]
4E12 move.l D0, 0x160000
4E18 syscall QDExtensions
4E1A move.w D6, [A7]+
4E1C subq.w A7, 2
4E1E subq.w A7, 4
4E20 move.l -[A7], [A5 - 0x44A]
4E24 move.l D0, 0x40017
4E2A syscall QDExtensions
4E2C move.l D0, 0x40001
4E32 syscall QDExtensions
4E34 move.b D7, [A7]+
4E36 move.l -[A7], [A5 - 0x44A]
4E3A clr.l -[A7]
4E3C move.l D0, 0x80006
4E42 syscall QDExtensions
4E44 move.l -[A7], A4
4E46 pea.l [A6 - 0x1C]
4E4A syscall DrawPicture
4E4C pea.l [A6 - 0x1C]
4E50 syscall InvertRect
4E52 subq.w A7, 4
4E54 syscall NewRgn
4E56 move.l [A5 - 0x442], [A7]+
4E5A subq.w A7, 2
4E5C move.l -[A7], [A5 - 0x442]
4E60 movea.l A0, [A5 - 0x44A]
4E64 pea.l [A0 + 0x2]
4E68 syscall BitMapToRegion/BitMapRgn
4E6A move.w D5, [A7]+
4E6C move.l -[A7], A4
4E6E syscall ReleaseResource
4E70 subq.w A7, 4
4E72 syscall NewRgn
4E74 move.l [A5 - 0x446], [A7]+
4E78 subq.w A7, 4
4E7A syscall NewRgn
4E7C move.l [A5 - 0x43E], [A7]+
4E80 subq.w A7, 4
4E82 pea.l [A5 - 0x44A]
4E86 move.w -[A7], 0x8
4E8A pea.l [A6 - 0x1C]
4E8E clr.l -[A7]
4E90 clr.l -[A7]
4E92 clr.l [A6 - 0x32]
4E96 move.l -[A7], [A6 - 0x32]
4E9A move.l D0, 0x160003
4EA0 syscall QDExtensions
4EA2 move.l D0, [A7]+
4EA4 move.l [A6 - 0x36], D0
4EA8 pea.l [A6 - 0x36]
4EAC pea.l [A6 - 0x56]
4EB0 move.w -[A7], 0x4
4EB4 jsr [PC - 0x4D1C /* 0000019A */]
4EB8 move.l [A6 - 0x26], [A6 - 0x3A]
4EBE subq.w A7, 4
4EC0 move.w -[A7], 0x80
4EC4 syscall GetPicture
4EC6 movea.l A4, [A7]+
4EC8 move.l -[A7], [A5 - 0x44A]
4ECC clr.l -[A7]
4ECE move.l D0, 0x80006
4ED4 syscall QDExtensions
4ED6 move.l -[A7], A4
4ED8 pea.l [A6 - 0x1C]
4EDC syscall DrawPicture
4EDE move.l -[A7], A4
4EE0 syscall ReleaseResource
4EE2 move.l -[A7], [A5 - 0x432]
4EE6 move.l -[A7], [A5 - 0x42E]
4EEA move.l D0, 0x80006
4EF0 syscall QDExtensions
4EF2 move.b [A5 - 0x3CA], 0x2
4EF8 move.b [A5 - 0x3BE], 0x2
4EFE jsr [PC - 0x3D02 /* 000011FE */]
4F02 clr.l [A5 - 0x108]
4F06 movem.l D5,D6,D7,A4, [A7]+
4F0A unlink A6
4F0C rts
fn00004F0E:
4F0E rts
fn00004F10:
4F10 move.w -[A7], 0x70 /* 'p' */
4F14 jsr [PC - 0x4B44 /* 000003D2 */]
4F18 rts
fn00004F1A:
4F1A link A6, -0x0018
4F1E tst.b [A5 - 0x437]
4F22 beq +0x8 /* 00004F2A */
4F24 jsr [PC + 0x6E2 /* 00005608 */]
4F28 syscall DrawMenuBar
label00004F2A:
4F2A move.b D0, [A5 - 0x439]
4F2E subq.b D0, 1
4F30 beq +0x36 /* 00004F66 */
4F32 pea.l [A6 - 0x18]
4F36 clr.w -[A7]
4F38 move.w -[A7], 0x14
4F3C move.w -[A7], 0x280
4F40 move.w -[A7], 0x1E0
4F44 syscall SetRect
4F46 movea.l A0, [A5 - 0x456]
4F4A pea.l [A0 + 0x2]
4F4E movea.l A0, [A5 - 0x432]
4F52 pea.l [A0 + 0x2]
4F56 pea.l [A6 - 0x18]
4F5A pea.l [A6 - 0x18]
4F5E clr.w -[A7]
4F60 clr.l -[A7]
4F62 syscall CopyBits
4F64 bra +0x6 /* 00004F6A */
label00004F66:
4F66 clr.b [A5 - 0x206]
label00004F6A:
4F6A unlink A6
4F6C rts
fn00004F6E:
4F6E link A6, -0x0018
4F72 pea.l [A6 - 0x18]
4F76 clr.w -[A7]
4F78 move.w -[A7], 0x14
4F7C move.w -[A7], 0x280
4F80 move.w -[A7], 0x1E0
4F84 syscall SetRect
4F86 movea.l A0, [A5 - 0x456]
4F8A pea.l [A0 + 0x2]
4F8E movea.l A0, [A5 - 0x432]
4F92 pea.l [A0 + 0x2]
4F96 pea.l [A6 - 0x18]
4F9A pea.l [A6 - 0x18]
4F9E clr.w -[A7]
4FA0 clr.l -[A7]
4FA2 syscall CopyBits
4FA4 clr.b [A5 - 0x206]
4FA8 tst.b [A5 - 0x437]
4FAC beq +0x4 /* 00004FB0 */
4FAE syscall DrawMenuBar
label00004FB0:
4FB0 unlink A6
4FB2 rts
fn00004FB4:
4FB4 link A6, -0x0022
4FB8 move.l -[A7], D7
4FBA movea.l A0, [A6 + 0x8]
4FBE lea.l A1, [A6 - 0x20]
4FC2 move.l [A1]+, [A0]+
4FC4 move.l [A1]+, [A0]+
4FC6 move.l [A1]+, [A0]+
4FC8 move.l [A1]+, [A0]+
4FCA moveq.l D7, 0x00
4FCC move.w D7, [A6 - 0x12]
4FD0 andi.l D7, 0x400
4FD6 tst.l D7
4FD8 sne D0
4FDA move.b D1, [A5 - 0x439]
4FDE subq.b D1, 1
4FE0 or.b D0, D1
4FE2 neg.b D0
4FE4 move.b D7, D0
4FE6 cmp.b D7, [A5 - 0x437]
4FEA beq +0x14 /* 00004FFE */
4FEC move.b [A5 - 0x437], D7
4FF0 tst.b [A5 - 0x437]
4FF4 beq +0x6 /* 00004FFA */
4FF6 clr.w -[A7]
4FF8 syscall HiliteMenu
label00004FFA:
4FFA jsr [PC - 0xE2 /* 00004F1A */]
label00004FFE:
4FFE tst.b [A5 - 0x438]
5002 beq +0x4E /* 00005050 */
5004 cmpi.b [A5 - 0x3C2], 0x6
500A bne +0x2E /* 00005038 */
500C jsr [PC - 0x308C /* 00001F82 */]
5010 jsr [PC - 0x2F0E /* 00002104 */]
5014 clr.b [A5 - 0x439]
5018 clr.b [A5 - 0x438]
501C move.b [A5 - 0x3C2], 0x1
5022 jsr [PC - 0x116 /* 00004F0E */]
5026 clr.b [A5 - 0x439]
502A clr.b [A5 - 0x438]
502E jsr [PC - 0x4A12 /* 0000061E */]
5032 jsr [PC - 0x11A /* 00004F1A */]
5036 bra +0x1E /* 00005054 */
label00005038:
5038 jsr [PC - 0x31A8 /* 00001E92 */]
503C move.w D0, [A5 - 0x3CC]
5040 addq.w D0, 1
5042 move.w -[A7], D0
5044 move.b -[A7], 0x1
5048 clr.b -[A7]
504A jsr [PC - 0x4F4 /* 00004B58 */]
504E bra +0x6 /* 00005054 */
label00005050:
5050 jsr [PC - 0x632 /* 00004A20 */]
label00005054:
5054 move.l D7, [A7]+
5056 unlink A6
5058 move.l [A7], [A7]+
505A rts
fn0000505C:
505C link A6, 0x0000
5060 unlink A6
5062 movea.l A0, [A7]+
5064 addq.w A7, 6
5066 jmp [A0]
fn00005068:
5068 link A6, -0x0026
506C movea.l A0, [A6 + 0x8]
5070 lea.l A1, [A6 - 0x20]
5074 move.l [A1]+, [A0]+
5076 move.l [A1]+, [A0]+
5078 move.l [A1]+, [A0]+
507A move.l [A1]+, [A0]+
507C tst.w [A6 - 0x1E]
5080 beq +0x22 /* 000050A2 */
5082 pea.l [A6 - 0x26]
5086 move.w -[A7], 0x64 /* 'd' */
508A move.w -[A7], 0x64 /* 'd' */
508E syscall SetPt
5090 subq.w A7, 2
5092 move.l -[A7], [A6 - 0x26]
5096 move.l -[A7], [A6 - 0x1E]
509A jsr [PC - 0x4D92 /* 0000030A */]
509E move.w [A6 - 0x22], [A7]+
label000050A2:
50A2 unlink A6
50A4 move.l [A7], [A7]+
50A6 rts
fn000050A8:
50A8 link A6, -0x0032
50AC move.l -[A7], D7
50AE movea.l A0, [A6 + 0x8]
50B2 lea.l A1, [A6 - 0x20]
50B6 move.l [A1]+, [A0]+
50B8 move.l [A1]+, [A0]+
50BA move.l [A1]+, [A0]+
50BC move.l [A1]+, [A0]+
50BE move.l D7, [A6 - 0x1E]
50C2 andi.l D7, 0xFF
50C8 moveq.l D0, 0x00
50CA move.w D0, [A6 - 0x12]
50CE andi.l D0, 0x100
50D4 tst.l D0
50D6 beq +0x1C /* 000050F2 */
50D8 jsr [PC + 0x52E /* 00005608 */]
50DC subq.w A7, 4
50DE move.w -[A7], D7
50E0 syscall MenuKey
50E2 jsr [PC + 0x748 /* 0000582C */]
50E6 move.b D0, [A5 - 0x43A]
50EA subq.b D0, 1
50EC bne +0x42 /* 0000512E */
50EE jsr [PC - 0x1D6 /* 00004F1A */]
label000050F2:
50F2 move.b D0, [A5 - 0x439]
50F6 subq.b D0, 1
50F8 beq +0x36 /* 0000512E */
50FA pea.l [A6 - 0x32]
50FE syscall GetKeys
5100 moveq.l D0, 0x26
5102 move.w D1, D0
5104 lsr D1.w, 3
5106 btst [A6 + D1.w - 0x32], D0
510A sne D0
510C moveq.l D1, 0x22
510E move.w D2, D1
5110 lsr D2.w, 3
5112 btst [A6 + D2.w - 0x32], D1
5116 sne D1
5118 and.b D0, D1
511A moveq.l D1, 0x2E
511C move.w D2, D1
511E lsr D2.w, 3
5120 btst [A6 + D2.w - 0x32], D1
5124 sne D1
5126 and.b D0, D1
5128 beq +0x6 /* 0000512E */
512A jsr [PC + 0xB8 /* 000051E4 */]
label0000512E:
512E move.l D7, [A7]+
5130 unlink A6
5132 move.l [A7], [A7]+
5134 rts
fn00005136:
5136 link A6, -0x0116
513A move.l -[A7], A4
513C movea.l A4, [A6 + 0x8]
5140 movea.l A0, [A6 + 0xC]
5144 lea.l A1, [A6 - 0x110]
5148 moveq.l D0, 0x3F
label0000514A:
514A move.l [A1]+, [A0]+
514C dbf D0, -0x6 /* 0000514A */
5150 move.w [A6 - 0x116], 0x7FFF
5156 move.w [A6 - 0x112], 0x7FFF
515C move.w [A6 - 0x114], 0x7FFF
5162 pea.l [A6 - 0x116]
5166 syscall RGBForeColor
5168 subq.w A7, 2
516A pea.l [A6 - 0x110]
516E syscall StringWidth
5170 move.w D0, [A7]+
5172 ext.l D0
5174 divs.w D0, 0x2
5178 move.w D1, 0x140
517C sub.w D1, D0
517E addq.w D1, 1
5180 move.w -[A7], D1
5182 move.w D0, [A4 - 0x12A]
5186 addq.w D0, 1
5188 move.w -[A7], D0
518A syscall MoveTo
518C pea.l [A6 - 0x110]
5190 syscall DrawString
5192 move.w [A6 - 0x116], 0xFFFF
5198 move.w [A6 - 0x114], 0xFFFF
519E move.w [A6 - 0x112], 0xFFFF
51A4 pea.l [A6 - 0x116]
51A8 syscall RGBForeColor
51AA subq.w A7, 2
51AC pea.l [A6 - 0x110]
51B0 syscall StringWidth
51B2 move.w D0, [A7]+
51B4 ext.l D0
51B6 divs.w D0, 0x2
51BA move.w D1, 0x140
51BE sub.w D1, D0
51C0 move.w -[A7], D1
51C2 move.w -[A7], [A4 - 0x12A]
51C6 syscall MoveTo
51C8 pea.l [A6 - 0x110]
51CC syscall DrawString
51CE move.w D0, [A4 - 0x12A]
51D2 addi.w D0, 0x15
51D6 move.w [A4 - 0x12A], D0
51DA movea.l A4, [A7]+
51DC unlink A6
51DE movea.l A0, [A7]+
51E0 addq.w A7, 8
51E2 jmp [A0]
fn000051E4:
51E4 link A6, -0x0232
51E8 move.l -[A7], [A5 - 0x432]
51EC move.l -[A7], [A5 - 0x42E]
51F0 move.l D0, 0x80006
51F6 syscall QDExtensions
51F8 pea.l [A6 - 0x28]
51FC clr.w -[A7]
51FE clr.w -[A7]
5200 move.w -[A7], 0x280
5204 move.w -[A7], 0x1E0
5208 syscall SetRect
520A pea.l [A6 - 0x28]
520E syscall PaintRect
5210 moveq.l D0, 0x21
5212 move.l -[A7], D0
5214 syscall BackColor
5216 move.w -[A7], 0x1
521A syscall TextFont
521C clr.b [A6 - 0x134]
5220 moveq.l D0, 0x00
5222 move.b D0, [A6 - 0x134]
5226 move.w -[A7], D0
5228 syscall TextFace
522A move.w -[A7], 0x1
522E syscall TextMode
5230 move.w -[A7], 0x12
5234 syscall TextSize
5236 clr.l -[A7]
5238 syscall SpaceExtra
523A move.w [A6 - 0x12A], 0x67 /* 'g' */
5240 pea.l [PC + 0x380 /* 000055C2, value 0x26576561 '&Wea', pstring "Weary with toil, I haste me to my bed," */]
5244 move.l -[A7], A6
5246 jsr [PC - 0x112 /* 00005136 */]
524A pea.l [PC + 0x348 /* 00005594, value 0x2C546865 ',The', pstring "The dear repose for limbs with travel tired;" */]
524E move.l -[A7], A6
5250 jsr [PC - 0x11C /* 00005136 */]
5254 pea.l [PC + 0x318 /* 0000556E, value 0x25427574 '%But', pstring "But then begins a journey in my head," */]
5258 move.l -[A7], A6
525A jsr [PC - 0x126 /* 00005136 */]
525E pea.l [A6 - 0x232]
5262 pea.l [PC + 0x2EE /* 00005552, value 0x1A546F20, pstring "To work my mind, when body" */]
5266 pea.l [PC + 0x2E8 /* 00005550, value 0x1D51A54 */]
526A pea.l [PC + 0x2DC /* 00005548, value 0x6732077, pstring "s work" */]
526E pea.l [PC + 0x2D6 /* 00005546, value 0x1D50673 */]
5272 pea.l [PC + 0x2C6 /* 0000553A, value 0xA732065 '\ns e', pstring "s expired:" */]
5276 move.w -[A7], 0x5
527A jsr [PC - 0x527C /* 00000000 */]
527E addq.w A7, 4
5280 move.w -[A7], 0xFF
5284 pea.l [A6 - 0x232]
5288 pea.l [A6 - 0x128]
528C jsr [PC - 0x5068 /* 00000226 */]
5290 pea.l [A6 - 0x128]
5294 move.l -[A7], A6
5296 jsr [PC - 0x162 /* 00005136 */]
529A pea.l [PC + 0x270 /* 0000550C, value 0x2D466F72 '-For', pstring "For then my thoughts, far from where I abide," */]
529E move.l -[A7], A6
52A0 jsr [PC - 0x16C /* 00005136 */]
52A4 pea.l [PC + 0x242 /* 000054E8, value 0x23496E74 '#Int', pstring "Intend a zealous pilgrimage to thee" */]
52A8 move.l -[A7], A6
52AA jsr [PC - 0x176 /* 00005136 */]
52AE pea.l [PC + 0x210 /* 000054C0, value 0x27416E64 '\'And', pstring "And keep my drooping eyelids open wide," */]
52B2 move.l -[A7], A6
52B4 jsr [PC - 0x180 /* 00005136 */]
52B8 pea.l [PC + 0x1DA /* 00005494, value 0x2B4C6F6F '+Loo', pstring "Looking on darkness which the blind do see:" */]
52BC move.l -[A7], A6
52BE jsr [PC - 0x18A /* 00005136 */]
52C2 pea.l [A6 - 0x232]
52C6 pea.l [PC + 0x1BA /* 00005482, value 0x11536176, pstring "Save that my soul" */]
52CA pea.l [PC + 0x1B4 /* 00005480, value 0x1D51153 */]
52CE pea.l [PC + 0x19E /* 0000546E, value 0x11732069, pstring "s imaginary sight" */]
52D2 move.w -[A7], 0x3
52D6 jsr [PC - 0x52D8 /* 00000000 */]
52DA addq.w A7, 4
52DC move.w -[A7], 0xFF
52E0 pea.l [A6 - 0x232]
52E4 pea.l [A6 - 0x128]
52E8 jsr [PC - 0x50C4 /* 00000226 */]
52EC pea.l [A6 - 0x128]
52F0 move.l -[A7], A6
52F2 jsr [PC - 0x1BE /* 00005136 */]
52F6 pea.l [PC + 0x14C /* 00005444, value 0x29507265 ')Pre', pstring "Presents thy shadow to my sightless view," */]
52FA move.l -[A7], A6
52FC jsr [PC - 0x1C8 /* 00005136 */]
5300 pea.l [PC + 0x116 /* 00005418, value 0x2A576869 '*Whi', pstring "Which, like a jewel hung in ghastly night," */]
5304 move.l -[A7], A6
5306 jsr [PC - 0x1D2 /* 00005136 */]
530A pea.l [PC + 0xDA /* 000053E6, value 0x314D616B '1Mak', pstring "Makes black night beauteous and her old face new." */]
530E move.l -[A7], A6
5310 jsr [PC - 0x1DC /* 00005136 */]
5314 pea.l [PC + 0xA2 /* 000053B8, value 0x2D4C6F21 '-Lo!', pstring "Lo! thus, by day my limbs, by night my mind," */]
5318 move.l -[A7], A6
531A jsr [PC - 0x1E6 /* 00005136 */]
531E pea.l [PC + 0x70 /* 00005390, value 0x26466F72 '&For', pstring "For thee and for myself no quiet find." */]
5322 move.l -[A7], A6
5324 jsr [PC - 0x1F0 /* 00005136 */]
5328 moveq.l D0, 0x21
532A move.l -[A7], D0
532C syscall ForeColor
532E moveq.l D0, 0x1E
5330 move.l -[A7], D0
5332 syscall BackColor
5334 move.w -[A7], 0x6A /* 'j' */
5338 jsr [PC - 0x4F68 /* 000003D2 */]
533C pea.l [A6 - 0x20]
5340 syscall GetKeys
5342 bra +0x12 /* 00005354 */
label00005344:
5344 pea.l [A6 - 0x20]
5348 syscall GetKeys
534A move.w -[A7], 0xFFFF
534E clr.w -[A7]
5350 move.l D0, [A7]+
5352 syscall FlushEvents
label00005354:
5354 subq.w A7, 2
5356 syscall Button
5358 move.b D0, [A7]+
535A subq.b D0, 1
535C moveq.l D1, 0x31
535E move.w D2, D1
5360 lsr D2.w, 3
5362 btst [A6 + D2.w - 0x20], D1
5366 seq D1
5368 and.b D0, D1
536A moveq.l D1, 0x0C
536C move.w D2, D1
536E lsr D2.w, 3
5370 btst [A6 + D2.w - 0x20], D1
5374 seq D1
5376 and.b D0, D1
5378 moveq.l D1, 0x24
537A move.w D2, D1
537C lsr D2.w, 3
537E btst [A6 + D2.w - 0x20], D1
5382 seq D1
5384 and.b D0, D1
5386 bne -0x42 /* 00005344 */
5388 jsr [PC - 0x41C /* 00004F6E */]
538C unlink A6
538E rts
5390 movea.l A3, D6
5392 ble +0x74 /* 00005406 */
5394 movea.l A0, [A4 + D6 + 0x65]
5398 bcs +0x22 /* 000053BA */
539A bsr +0x70 /* 0000540A */
539C bcc +0x22 /* 000053BE */
539E bne +0x71 /* 0000540F */
53A0 moveq.l D1, 0x20
53A2 blt +0x7B /* 0000541D */
53A4 moveq.l D1, 0x65
53A6 bge +0x68 /* 0000540E */
53A8 movea.l A0, [A6 + 0x6F20]
53AC moveq.l D0, 0x75
53AE bvs +0x67 /* 00005415 */
53B0 moveq.l D2, 0x20
53B2 bne +0x6B /* 0000541D */
53B4 bgt +0x66 /* 0000541A */
53B6 move.l D7, [A6]
53B8 move.l [A6 + 0x6F21], A4
// begin alternate branch 000053BA-000053BC
label000053BA:
53BA ble +0x23 /* 000053DD */
// end alternate branch 000053BA-000053BC
label000053BA: // (misaligned)
53BC move.l D0, -[A0]
label000053BE:
53BE moveq.l D2, 0x68
53C0 moveq.l D2, 0x73
53C2 move.l D6, -[A0]
53C4 bhi +0x7B /* 0000543F */
53C6 movea.l A0, -[A4]
53C8 bsr +0x7B /* 00005443 */
53CA movea.l A0, [A5 + 0x7920]
53CE bge +0x6B /* 00005439 */
53D0 blt +0x64 /* 00005434 */
53D2 moveq.l D1, 0x2C
53D4 movea.l A0, -[A2]
53D6 moveq.l D4, 0x20
53D8 bgt +0x6B /* 00005443 */
53DA beq +0x6A /* 00005444 */
53DC moveq.l D2, 0x20
53DE blt +0x7B /* 00005459 */
53E0 movea.l A0, [A5 + 0x696E]
53E4 bcc +0x2E /* 00005412 */
53E6 move.w [A0 + 0x616B], A5
53EA bcs +0x75 /* 0000545F */
53EC movea.l A0, -[A2]
53EE bge +0x63 /* 00005451 */
53F0 bls +0x6D /* 0000545D */
53F2 movea.l A0, [A6 + 0x6967]
53F6 bvc +0x76 /* 0000546C */
53F8 movea.l A0, -[A2]
53FA bcs +0x63 /* 0000545D */
53FC moveq.l D2, 0x74
53FE bcs +0x71 /* 0000546F */
5400 moveq.l D2, 0x73
5402 movea.l A0, -[A1]
5404 bgt +0x66 /* 0000546A */
label00005406:
5406 movea.l A0, [A0 + 0x6572]
fn0000540A:
540A movea.l A0, [A7 + 0x6C64]
label0000540E:
540E movea.l A0, -[A6]
5410 bsr +0x65 /* 00005475 */
label00005412:
5412 bcs +0x22 /* 00005434 */
5414 bgt +0x67 /* 0000547B */
5416 moveq.l D3, 0x2E
5418 movea.l A5, [A7]
label0000541A:
541A bvc +0x6B /* 00005485 */
541C bls +0x6A /* 00005486 */
541E move.l D6, -[A0]
5420 bge +0x6B /* 0000548B */
5422 bmi +0x67 /* 00005489 */
5424 movea.l A0, -[A1]
5426 movea.l A0, [A2 + 0x6577]
542A bcs +0x6E /* 00005498 */
542C movea.l A0, [A0 + 0x756E]
5430 beq +0x22 /* 00005452 */
5432 bvs +0x70 /* 000054A2 */
label00005434:
5434 movea.l A0, -[A7]
5436 bvc +0x63 /* 00005499 */
5438 moveq.l D1, 0x74
543A bge +0x7B /* 000054B5 */
543C movea.l A0, [A6 + 0x6967]
5440 bvc +0x76 /* 000054B6 */
5442 move.l D6, [A6]
label00005444:
5444 move.l [A4 + 0x7265], [A0]
5448 moveq.l D1, 0x65
544A bgt +0x76 /* 000054C0 */
544C moveq.l D1, 0x20
544E moveq.l D2, 0x68
5450 moveq.l D4, 0x20
label00005452:
5452 moveq.l D1, 0x68
5454 bsr +0x66 /* 000054BA */
5456 ble +0x79 /* 000054CF */
5458 movea.l A0, [A4 + 0x6D79 + D6 * 8]
545E movea.l A0, <<invalid full ext with IS == 1 and I/IS == 7>>
5462 bvc +0x76 /* 000054D8 */
5464 bge +0x67 /* 000054CB */
5466 moveq.l D1, 0x73
5468 movea.l A0, <<invalid full ext with IS == 1 and I/IS == 5>>
// begin alternate branch 0000546A-0000546C
label0000546A:
546A bvs +0x67 /* 000054D1 */
// end alternate branch 0000546A-0000546C
label0000546A: // (misaligned)
label0000546C:
546C moveq.l D3, 0x2C
546E move.b [A0 + 0x6D61], [A3 + D2.w + 0x69]
5474 beq +0x6B /* 000054DF */
5476 bgt +0x63 /* 000054D9 */
5478 moveq.l D1, 0x79
547A movea.l A0, <<invalid full ext with IS == 1 and I/IS == 7>>
547E bvc +0x76 /* 000054F4 */
5480 .incomplete
5482 move.b [A0 + 0x6176], [A3]
label00005486:
5486 bcs +0x22 /* 000054A8 */
5488 moveq.l D2, 0x68
548A bsr +0x76 /* 00005500 */
548C movea.l A0, [A5 + 0x7920]
5490 moveq.l D1, 0x6F
5492 moveq.l D2, 0x6C
5494 move.l [A5 + 0x6F6F], A4
label00005498:
5498 bmi +0x6B /* 00005503 */
549A bgt +0x69 /* 00005503 */
549C movea.l A0, [A7 + 0x6E20]
54A0 bcc +0x63 /* 00005503 */
label000054A2:
54A2 moveq.l D1, 0x6B
54A4 bgt +0x67 /* 0000550B */
54A6 moveq.l D1, 0x73
label000054A8:
54A8 movea.l A0, [A7 + D6 + 0x69]
54AC bls +0x6A /* 00005516 */
54AE movea.l A0, [A4 + D6 + 0x65]
54B2 movea.l A0, -[A2]
54B4 bge +0x6B /* 0000551F */
label000054B6:
54B6 bgt +0x66 /* 0000551C */
54B8 movea.l A0, -[A4]
fn000054BA:
54BA ble +0x22 /* 000054DC */
54BC moveq.l D1, 0x65
54BE bcs +0x3C /* 000054FA */
label000054C0:
54C0 move.l [A3 + 0x6E64], D1
54C4 movea.l A0, [A3 + 0x6565]
54C8 moveq.l D0, 0x20
54CA blt +0x7B /* 00005545 */
54CC movea.l A0, -[A4]
54CE moveq.l D1, 0x6F
54D0 ble +0x72 /* 00005542 */
54D2 bvs +0x70 /* 00005542 */
54D4 beq +0x22 /* 000054F6 */
54D6 bcs +0x7B /* 00005551 */
label000054D8:
54D8 bcs +0x6E /* 00005546 */
54DA bvs +0x66 /* 00005540 */
label000054DC:
54DC moveq.l D1, 0x20
54DE ble +0x72 /* 00005550 */
54E0 bcs +0x70 /* 00005550 */
54E2 movea.l A0, <<invalid full ext with I/IS == 4>>
54E6 bcs +0x2E /* 00005514 */
54E8 move.l [A1 + 0x6E74], A1
54EC bcs +0x70 /* 0000555C */
54EE bcc +0x22 /* 00005510 */
54F0 bsr +0x22 /* 00005512 */
54F2 moveq.l D5, 0x65
label000054F4:
54F4 bsr +0x6E /* 00005562 */
label000054F6:
54F6 ble +0x77 /* 0000556D */
54F8 moveq.l D1, 0x20
label000054FA:
54FA moveq.l D0, 0x69
54FC bge +0x69 /* 00005565 */
54FE moveq.l D1, 0x69
fn00005500:
5500 blt +0x63 /* 00005563 */
5502 beq +0x67 /* 00005569 */
5504 movea.l A0, [A4 + 0x7468 + D6 * 8]
550A bcs +0x67 /* 00005571 */
550C move.l [A6 + 0x6F72], D6
label00005510:
5510 movea.l A0, [A4 + D6 + 0x65]
// begin alternate branch 00005512-00005514
fn00005512:
5512 bvc +0x67 /* 00005579 */
// end alternate branch 00005512-00005514
fn00005512: // (misaligned)
label00005514:
5514 bgt +0x22 /* 00005536 */
label00005516:
5516 blt +0x7B /* 00005591 */
5518 movea.l A0, [A4 + D6 + 0x6F]
label0000551C:
551C moveq.l D2, 0x67
551E bvc +0x76 /* 00005594 */
5520 moveq.l D1, 0x2C
5522 movea.l A0, -[A6]
5524 bsr +0x74 /* 00005598 */
5526 movea.l A0, -[A6]
5528 moveq.l D1, 0x6F
552A blt +0x22 /* 0000554C */
552C moveq.l D3, 0x68
552E bcs +0x74 /* 000055A2 */
5530 bcs +0x22 /* 00005552 */
5532 .invalid 4, -[A0] // invalid opcode 4 with b == 4
5534 bsr +0x64 /* 00005598 */
label00005536:
5536 bvs +0x66 /* 0000559C */
5538 bcs +0x2E /* 00005566 */
553A xori.w [A3 + D7 + 0x70], 0x2065 /* ' e' */
label00005540:
5540 bvs +0x74 /* 000055B4 */
label00005542:
5542 bcs +0x66 /* 000055A8 */
5544 move.w D5, [A6]
label00005546:
5546 .incomplete
5548 0... addi.w [[A3 + 0x6B1201D5] + 0x1A54], 0x2077 /* ' w' */
// begin alternate branch 0000554C-00005554
label0000554C:
554C ble +0x74 /* 000055C0 */
554E bmi +0x14 /* 00005562 */
label00005550:
5550 .incomplete
label00005552:
5552 movea.b A5, [A4]
// end alternate branch 0000554C-00005554
label0000554C: // (misaligned)
label00005550: // (misaligned)
label00005552: // (misaligned)
5554 ble +0x22 /* 00005576 */
5556 moveq.l D3, 0x6F
5558 moveq.l D1, 0x6B
555A movea.l A0, [A5 + 0x7920]
// begin alternate branch 0000555C-0000555E
label0000555C:
555C moveq.l D4, 0x20
// end alternate branch 0000555C-0000555E
label0000555C: // (misaligned)
555E blt +0x6B /* 000055C9 */
5560 bgt +0x66 /* 000055C6 */
fn00005562:
5562 move.l D6, -[A0]
5564 moveq.l D3, 0x68
label00005566:
5566 bcs +0x70 /* 000055D6 */
5568 movea.l A0, -[A2]
556A ble +0x66 /* 000055D0 */
556C moveq.l D4, 0x12
556E move.l [A2 + 0x7574], D2
5572 movea.l A0, [A4 + D6 + 0x65]
label00005576:
5576 bgt +0x22 /* 00005598 */
5578 bhi +0x67 /* 000055DF */
557A beq +0x6B /* 000055E5 */
557C bgt +0x75 /* 000055F1 */
557E movea.l A0, -[A1]
5580 movea.l A0, [A2 + 0x6F75]
5584 moveq.l D1, 0x6E
5586 bcs +0x7B /* 00005601 */
5588 movea.l A0, [A1 + 0x6E20]
558C blt +0x7B /* 00005607 */
558E movea.l A0, [A0 + 0x6561]
5592 bcc +0x2E /* 000055C0 */
label00005594:
5594 movea.l A6, [A4]
5596 bvc +0x67 /* 000055FD */
fn00005598:
5598 movea.l A0, -[A4]
559A bcs +0x63 /* 000055FD */
label0000559C:
559C moveq.l D1, 0x20
559E moveq.l D1, 0x65
55A0 moveq.l D0, 0x6F
label000055A2:
55A2 moveq.l D1, 0x65
55A4 movea.l A0, -[A6]
55A6 ble +0x74 /* 0000561A */
label000055A8:
55A8 movea.l A0, [A4 + 0x696D]
55AC bhi +0x75 /* 00005621 */
55AE movea.l A0, <<invalid full ext with I/IS == 4>>
55B2 bvc +0x22 /* 000055D4 */
label000055B4:
55B4 moveq.l D2, 0x72
55B6 bsr +0x78 /* 0000562E */
55B8 bcs +0x6E /* 00005626 */
55BA movea.l A0, [[A4 + 0x65643B16] + 0x2657]
// begin alternate branch 000055C0-000055C4
label000055C0:
55C0 move.w -[A5], [A6]
55C2 movea.l A3, [A7]
// end alternate branch 000055C0-000055C4
label000055C0: // (misaligned)
55C4 bcs +0x63 /* 00005627 */
label000055C6:
55C6 moveq.l D1, 0x79
55C8 movea.l A0, <<invalid full ext with I/IS == 4>>
55CC bvc +0x22 /* 000055EE */
55CE moveq.l D2, 0x6F
label000055D0:
55D0 bvs +0x6E /* 0000563E */
55D2 move.l D6, -[A0]
label000055D4:
55D4 .invalid 4, -[A0] // invalid opcode 4 with b == 4
label000055D6:
55D6 bvc +0x63 /* 00005639 */
55D8 moveq.l D1, 0x74
55DA bcs +0x22 /* 000055FC */
55DC blt +0x67 /* 00005643 */
55DE movea.l A0, [A4 + 0x6D79 + D6 * 8]
55E4 movea.l A0, -[A2]
55E6 bcs +0x66 /* 0000564C */
55E8 move.l D6, [A6]
fn000055EA:
55EA link A6, 0x0000
label000055EE:
55EE subq.w A7, 4
55F0 move.w -[A7], 0x3
55F4 syscall GetMenuHandle
55F6 move.w -[A7], [A6 + 0xE]
55FA move.b -[A7], [A6 + 0xC]
// begin alternate branch 000055FC-00005600
label000055FC:
55FC ori.b A4, 0x45 /* 'E' */
// end alternate branch 000055FC-00005600
label000055FC: // (misaligned)
55FE syscall CheckItem
5600 unlink A6
5602 movea.l A0, [A7]+
5604 addq.w A7, 8
5606 jmp [A0]
fn00005608:
5608 link A6, 0x0000
560C subq.w A7, 4
560E move.w -[A7], 0x1
5612 syscall GetMenuHandle
5614 clr.w -[A7]
5616 syscall EnableItem
5618 subq.w A7, 4
label0000561A:
561A move.w -[A7], 0x2
561E syscall GetMenuHandle
5620 clr.w -[A7]
5622 syscall EnableItem
5624 tst.b [A5 - 0x439]
// begin alternate branch 00005626-00005628
label00005626:
5626 .invalid <<F/7/5>>
// end alternate branch 00005626-00005628
label00005626: // (misaligned)
5628 beq +0x72 /* 0000569A */
562A subq.w A7, 4
562C move.w -[A7], 0x2
// begin alternate branch 0000562E-00005632
fn0000562E:
562E ori.b D2, 0x49 /* 'I' */
// end alternate branch 0000562E-00005632
fn0000562E: // (misaligned)
5630 syscall GetMenuHandle
5632 move.w -[A7], 0x1
5636 syscall DisableItem
5638 subq.w A7, 4
563A move.w -[A7], 0x2
label0000563E:
563E syscall GetMenuHandle
5640 move.w -[A7], 0x2
5644 syscall EnableItem
5646 subq.w A7, 4
5648 move.w -[A7], 0x2
label0000564C:
564C syscall GetMenuHandle
564E move.w -[A7], 0x5
5652 syscall EnableItem
5654 subq.w A7, 4
5656 move.w -[A7], 0x2
565A syscall GetMenuHandle
565C move.w -[A7], 0x4
5660 syscall DisableItem
5662 subq.w A7, 4
5664 move.w -[A7], 0x4
5668 syscall GetMenuHandle
566A clr.w -[A7]
566C syscall DisableItem
566E subq.w A7, 4
5670 move.w -[A7], 0x4
5674 syscall GetMenuHandle
5676 move.w -[A7], 0x1
567A syscall DisableItem
567C subq.w A7, 4
567E move.w -[A7], 0x4
5682 syscall GetMenuHandle
5684 move.w -[A7], 0x3
5688 syscall DisableItem
568A subq.w A7, 4
568C move.w -[A7], 0x4
5690 syscall GetMenuHandle
5692 move.w -[A7], 0x4
5696 syscall DisableItem
5698 bra +0x70 /* 00005708 */
label0000569A:
569A subq.w A7, 4
569C move.w -[A7], 0x2
56A0 syscall GetMenuHandle
56A2 move.w -[A7], 0x1
56A6 syscall EnableItem
56A8 subq.w A7, 4
56AA move.w -[A7], 0x2
56AE syscall GetMenuHandle
56B0 move.w -[A7], 0x2
56B4 syscall DisableItem
56B6 subq.w A7, 4
56B8 move.w -[A7], 0x2
56BC syscall GetMenuHandle
56BE move.w -[A7], 0x5
56C2 syscall DisableItem
56C4 subq.w A7, 4
56C6 move.w -[A7], 0x2
56CA syscall GetMenuHandle
56CC move.w -[A7], 0x4
56D0 syscall EnableItem
56D2 subq.w A7, 4
56D4 move.w -[A7], 0x4
56D8 syscall GetMenuHandle
56DA clr.w -[A7]
56DC syscall EnableItem
56DE subq.w A7, 4
56E0 move.w -[A7], 0x4
56E4 syscall GetMenuHandle
56E6 move.w -[A7], 0x1
56EA syscall EnableItem
56EC subq.w A7, 4
56EE move.w -[A7], 0x4
56F2 syscall GetMenuHandle
56F4 move.w -[A7], 0x3
56F8 syscall EnableItem
56FA subq.w A7, 4
56FC move.w -[A7], 0x4
5700 syscall GetMenuHandle
5702 move.w -[A7], 0x4
5706 syscall EnableItem
label00005708:
5708 tst.b [A5 - 0x3C7]
570C beq +0x2E /* 0000573A */
570E subq.w A7, 4
5710 move.w -[A7], 0x3
5714 syscall GetMenuHandle
5716 move.w -[A7], 0x1
571A syscall DisableItem
571C subq.w A7, 4
571E move.w -[A7], 0x3
5722 syscall GetMenuHandle
5724 move.w -[A7], 0x2
5728 syscall DisableItem
572A subq.w A7, 4
572C move.w -[A7], 0x3
5730 syscall GetMenuHandle
5732 move.w -[A7], 0x3
5736 syscall DisableItem
5738 bra +0x2C /* 00005764 */
label0000573A:
573A subq.w A7, 4
573C move.w -[A7], 0x3
5740 syscall GetMenuHandle
5742 move.w -[A7], 0x1
5746 syscall EnableItem
5748 subq.w A7, 4
574A move.w -[A7], 0x3
574E syscall GetMenuHandle
5750 move.w -[A7], 0x2
5754 syscall EnableItem
5756 subq.w A7, 4
5758 move.w -[A7], 0x3
575C syscall GetMenuHandle
575E move.w -[A7], 0x3
5762 syscall EnableItem
label00005764:
5764 subq.w A7, 4
5766 move.w -[A7], 0x3
576A syscall GetMenuHandle
576C clr.w -[A7]
576E syscall EnableItem
5770 subq.w A7, 4
5772 move.w -[A7], 0x3
5776 syscall GetMenuHandle
5778 move.w -[A7], 0x5
577C syscall EnableItem
577E subq.w A7, 4
5780 move.w -[A7], 0x3
5784 syscall GetMenuHandle
5786 move.w -[A7], 0x6
578A syscall EnableItem
578C subq.w A7, 4
578E move.w -[A7], 0x3
5792 syscall GetMenuHandle
5794 move.w -[A7], 0x7
5798 syscall EnableItem
579A move.w -[A7], 0x1
579E move.b D0, [A5 - 0x3C8]
57A2 subq.b D0, 1
57A4 and.b D0, [A5 - 0x3C9]
57A8 move.b -[A7], D0
57AA move.l -[A7], A6
57AC jsr [PC - 0x1C4 /* 000055EA */]
57B0 move.w -[A7], 0x2
57B4 move.b D0, [A5 - 0x3C9]
57B8 and.b D0, [A5 - 0x3C8]
57BC move.b -[A7], D0
57BE move.l -[A7], A6
57C0 jsr [PC - 0x1D8 /* 000055EA */]
57C4 move.w -[A7], 0x3
57C8 move.b D0, [A5 - 0x3C9]
57CC subq.b D0, 1
57CE neg.b D0
57D0 move.b -[A7], D0
57D2 move.l -[A7], A6
57D4 jsr [PC - 0x1EC /* 000055EA */]
57D8 move.w -[A7], 0x5
57DC tst.b [A5 - 0x3CA]
57E0 seq D0
57E2 neg.b D0
57E4 move.b -[A7], D0
57E6 move.l -[A7], A6
57E8 jsr [PC - 0x200 /* 000055EA */]
57EC move.w -[A7], 0x6
57F0 cmpi.b [A5 - 0x3CA], 0x2
57F6 seq D0
57F8 neg.b D0
57FA move.b -[A7], D0
57FC move.l -[A7], A6
57FE jsr [PC - 0x216 /* 000055EA */]
5802 move.w -[A7], 0x7
5806 cmpi.b [A5 - 0x3CA], 0x1
580C seq D0
580E neg.b D0
5810 move.b -[A7], D0
5812 move.l -[A7], A6
5814 jsr [PC - 0x22C /* 000055EA */]
5818 subq.w A7, 4
581A move.w -[A7], 0x2
581E syscall GetMenuHandle
5820 move.w -[A7], 0x7
5824 syscall EnableItem
5826 syscall DrawMenuBar
5828 unlink A6
582A rts
fn0000582C:
582C link A6, -0x011E
5830 movem.l -[A7], D4,D5,D6,D7,A4
5834 move.l D4, [A6 + 0x8]
5838 move.l D5, D4
583A swap.w D5
583C move.w D7, D4
583E pea.l [A6 - 0x18]
5842 syscall GetPort
5844 tst.b [A5 - 0x437]
5848 beq +0xC /* 00005854 */
584A jsr [PC - 0x244 /* 00005608 */]
584E syscall DrawMenuBar
5850 clr.w -[A7]
5852 syscall HiliteMenu
label00005854:
5854 move.w D0, D5
5856 bra +0x1B2 /* 00005A08 */
label0000585A:
585A move.w D0, D7
585C bra +0x48 /* 000058A4 */
label0000585E:
585E subq.w A7, 4
5860 move.w -[A7], 0x80
5864 clr.l -[A7]
5866 moveq.l D0, 0xFFFFFFFF
5868 move.l -[A7], D0
586A syscall GetNewDialog
586C movea.l A4, [A7]+
586E move.l -[A7], A4
5870 syscall DrawDialog
5872 move.w -[A7], 0x67 /* 'g' */
5876 jsr [PC - 0x54A6 /* 000003D2 */]
587A bra +0xC /* 00005886 */
label0000587C:
587C move.w -[A7], 0xFFFF
5880 clr.w -[A7]
5882 move.l D0, [A7]+
5884 syscall FlushEvents
label00005886:
5886 subq.w A7, 2
5888 syscall Button
588A move.b D0, [A7]+
588C subq.b D0, 1
588E bne -0x12 /* 0000587C */
5890 move.w -[A7], 0x66 /* 'f' */
5894 jsr [PC - 0x54C4 /* 000003D2 */]
5898 move.l -[A7], A4
589A syscall DisposeDialog
589C jsr [PC - 0x930 /* 00004F6E */]
58A0 bra +0x17C /* 00005A1C */
label000058A4:
58A4 subq.w D0, 1
58A6 beq -0x48 /* 0000585E */
58A8 subq.w A7, 4
58AA move.w -[A7], 0x1
58AE syscall GetMenuHandle
58B0 move.w -[A7], D7
58B2 pea.l [A6 - 0x11C]
58B6 syscall GetMenuItemText/GetItem
58B8 subq.w A7, 2
58BA pea.l [A6 - 0x11C]
58BE syscall OpenDeskAcc
58C0 move.w D6, [A7]+
58C2 bra +0x15A /* 00005A1C */
label000058C6:
58C6 move.w D0, D7
58C8 bra +0xB2 /* 0000597A */
label000058CC:
58CC move.b [A5 - 0x439], 0x1
58D2 move.w -[A7], 0x1
58D6 move.b -[A7], 0x1
58DA move.b -[A7], 0x1
58DE jsr [PC - 0xD88 /* 00004B58 */]
58E2 bra +0x13A /* 00005A1C */
label000058E6:
58E6 subq.w A7, 2
58E8 jsr [PC - 0x4768 /* 00001182 */]
58EC tst.b [A7]+
58EE beq +0x12E /* 00005A1C */
58F2 clr.b [A5 - 0x439]
58F6 jsr [PC - 0x9EA /* 00004F0E */]
58FA jsr [PC - 0x52DE /* 0000061E */]
58FE jsr [PC - 0x9E6 /* 00004F1A */]
5902 bra +0x11A /* 00005A1C */
label00005906:
5906 tst.b [A5 - 0x439]
590A beq +0x112 /* 00005A1C */
590E move.w -[A7], [A5 - 0x3CC]
5912 clr.b -[A7]
5914 clr.b -[A7]
5916 jsr [PC - 0xDC0 /* 00004B58 */]
591A bra +0x102 /* 00005A1C */
label0000591E:
591E subq.w A7, 2
5920 jsr [PC - 0x497E /* 00000FA4 */]
5924 move.w D6, [A7]+
5926 tst.w D6
5928 ble +0x1C /* 00005944 */
592A move.w [A5 - 0x3CC], D6
592E move.b [A5 - 0x439], 0x1
5934 move.w -[A7], [A5 - 0x3CC]
5938 move.b -[A7], 0x1
593C move.b -[A7], 0x1
5940 jsr [PC - 0xDEA /* 00004B58 */]
label00005944:
5944 jsr [PC - 0xA2C /* 00004F1A */]
5948 bra +0xD4 /* 00005A1C */
label0000594C:
594C cmpi.b [A5 - 0x439], 0x1
5952 bne +0x1C /* 0000596E */
5954 subq.w A7, 2
5956 jsr [PC - 0x47D6 /* 00001182 */]
595A move.b D0, [A7]+
595C subq.b D0, 1
595E beq +0xC /* 0000596A */
5960 clr.w -[A7]
5962 syscall HiliteMenu
5964 bra +0xC8 /* 00005A2C */
5968 bra +0x6 /* 0000596E */
label0000596A:
596A jsr [PC - 0xA5E /* 00004F0E */]
label0000596E:
596E clr.b [A5 - 0x439]
5972 jsr [PC + 0x1A0 /* 00005B14 */]
5976 bra +0xA6 /* 00005A1C */
label0000597A:
597A subq.w D0, 1
597C beq -0xB0 /* 000058CC */
5980 subq.w D0, 1
5982 beq -0x9C /* 000058E6 */
5986 subq.w D0, 2
5988 beq -0x6A /* 0000591E */
598A subq.w D0, 1
598C beq -0x86 /* 00005906 */
5990 subq.w D0, 2
5992 beq -0x46 /* 0000594C */
5994 bra +0x88 /* 00005A1C */
label00005998:
5998 move.w D0, D7
599A bra +0x40 /* 000059DA */
599C move.b [A5 - 0x3C9], 0x1
59A2 clr.b [A5 - 0x3C8]
59A6 bra +0x76 /* 00005A1C */
59AA move.b [A5 - 0x3C9], 0x1
59B0 move.b [A5 - 0x3C8], 0x1
59B6 bra +0x66 /* 00005A1C */
59BA clr.b [A5 - 0x3C9]
59BE clr.b [A5 - 0x3C8]
59C2 bra +0x5A /* 00005A1C */
59C4 clr.b [A5 - 0x3CA]
59C8 bra +0x54 /* 00005A1C */
59CA move.b [A5 - 0x3CA], 0x2
59D0 bra +0x4C /* 00005A1C */
59D2 move.b [A5 - 0x3CA], 0x1
59D8 bra +0x44 /* 00005A1C */
label000059DA:
59DA subq.w D0, 1
59DC cmpi.w D0, 0x7
59E0 bcc +0x1A /* 000059FA */
59E2 add.w D0, D0
59E4 move.w D0, [PC + D0.w + 0x6]
59E8 jmp [PC + D0.w + 0x2]
59EC .invalid <<F/6/7>>
59EE .invalid <<F/6/7>>
59F0 .invalid <<F/7/7>>
59F2 ori.b A6, 0xD8
59F6 .invalid <<F/7/7>>
59F8 .invalid <<F/7/7>>
label000059FA:
59FA bra +0x22 /* 00005A1C */
label000059FC:
59FC move.w -[A7], D7
59FE jsr [PC - 0x55A2 /* 0000045E */]
5A02 jsr [PC - 0xA96 /* 00004F6E */]
5A06 bra +0x16 /* 00005A1C */
label00005A08:
5A08 subq.w D0, 1
5A0A beq -0x1B0 /* 0000585A */
5A0E subq.w D0, 1
5A10 beq -0x14A /* 000058C6 */
5A14 subq.w D0, 1
5A16 beq -0x7E /* 00005998 */
5A18 subq.w D0, 1
5A1A beq -0x1E /* 000059FC */
label00005A1C:
5A1C tst.b [A5 - 0x437]
5A20 beq +0xC /* 00005A2C */
5A22 jsr [PC - 0x41C /* 00005608 */]
5A26 syscall DrawMenuBar
5A28 clr.w -[A7]
5A2A syscall HiliteMenu
label00005A2C:
5A2C movem.l D4,D5,D6,D7,A4, [A7]+
5A30 unlink A6
5A32 move.l [A7], [A7]+
5A34 rts
fn00005A36:
5A36 link A6, -0x002E
5A3A move.l -[A7], D7
5A3C movea.l A0, [A6 + 0x8]
5A40 lea.l A1, [A6 - 0x20]
5A44 move.l [A1]+, [A0]+
5A46 move.l [A1]+, [A0]+
5A48 move.l [A1]+, [A0]+
5A4A move.l [A1]+, [A0]+
5A4C subq.w A7, 2
5A4E move.l -[A7], [A6 - 0x16]
5A52 pea.l [A6 - 0x26]
5A56 syscall FindWindow
5A58 move.w D7, [A7]+
5A5A move.w D0, D7
5A5C bra +0x84 /* 00005AE0 */
label00005A60:
5A60 tst.b [A5 - 0x437]
5A64 beq +0x8E /* 00005AF2 */
5A68 jsr [PC - 0x462 /* 00005608 */]
5A6C subq.w A7, 4
5A6E move.l -[A7], [A6 - 0x16]
5A72 syscall MenuSelect
5A74 jsr [PC - 0x24A /* 0000582C */]
5A78 move.b D0, [A5 - 0x43A]
5A7C subq.b D0, 1
5A7E bne +0x74 /* 00005AF2 */
5A82 bra +0x70 /* 00005AF2 */
label00005A86:
5A86 pea.l [A6 - 0x20]
5A8A move.l -[A7], [A6 - 0x26]
5A8E syscall SystemClick
5A90 bra +0x62 /* 00005AF2 */
label00005A92:
5A92 subq.w A7, 4
5A94 move.l [A7], [0x000009EE /* GrayRgn */]
5A98 movea.l A0, [A7]+
5A9A movea.l A0, [A0]
5A9C lea.l A0, [A0 + 0x2]
5AA0 lea.l A1, [A6 - 0x2E]
5AA4 move.l [A1]+, [A0]+
5AA6 move.l [A1]+, [A0]+
5AA8 move.l -[A7], [A6 - 0x26]
5AAC move.l -[A7], [A6 - 0x16]
5AB0 pea.l [A6 - 0x2E]
5AB4 syscall DragWindow
5AB6 bra +0x3C /* 00005AF2 */
label00005AB8:
5AB8 subq.w A7, 4
5ABA syscall FrontWindow
5ABC move.l D0, [A7]+
5ABE cmp.l D0, [A6 - 0x26]
5AC2 beq +0x8 /* 00005ACA */
5AC4 move.l -[A7], [A6 - 0x26]
5AC8 syscall SelectWindow
label00005ACA:
5ACA move.b D0, [A5 - 0x439]
5ACE subq.b D0, 1
5AD0 and.b D0, [A5 - 0x437]
5AD4 beq +0x1E /* 00005AF2 */
5AD6 move.l -[A7], [A6 - 0x16]
5ADA jsr [PC - 0x52FE /* 000007DE */]
5ADE bra +0x14 /* 00005AF2 */
label00005AE0:
5AE0 subq.w D0, 1
5AE2 beq -0x82 /* 00005A60 */
5AE6 subq.w D0, 1
5AE8 beq -0x62 /* 00005A86 */
5AEA subq.w D0, 1
5AEC beq -0x34 /* 00005AB8 */
5AEE subq.w D0, 1
5AF0 beq -0x5E /* 00005A92 */
label00005AF2:
5AF2 move.l D7, [A7]+
5AF4 unlink A6
5AF6 move.l [A7], [A7]+
5AF8 rts
fn00005AFA:
5AFA link A6, -0x0020
5AFE movea.l A0, [A6 + 0x8]
5B02 lea.l A1, [A6 - 0x20]
5B06 move.l [A1]+, [A0]+
5B08 move.l [A1]+, [A0]+
5B0A move.l [A1]+, [A0]+
5B0C move.l [A1]+, [A0]+
5B0E unlink A6
5B10 move.l [A7], [A7]+
5B12 rts
fn00005B14:
5B14 clr.b [A5 - 0x43A]
5B18 rts
fn00005B1A:
5B1A link A6, -0x0014
5B1E pea.l [A6 - 0x14]
5B22 syscall GetPort
5B24 move.l -[A7], [A5 - 0x432]
5B28 syscall SetPort
5B2A move.l -[A7], [A6 + 0x8]
5B2E syscall BeginUpdate
5B30 jsr [PC - 0xBC4 /* 00004F6E */]
5B34 move.l -[A7], [A6 + 0x8]
5B38 syscall EndUpdate
5B3A move.l -[A7], [A6 - 0x14]
5B3E syscall SetPort
5B40 unlink A6
5B42 move.l [A7], [A7]+
5B44 rts
fn00005B46:
5B46 link A6, -0x0018
5B4A movem.l -[A7], D6,D7
5B4E pea.l [A5 - 0x36]
5B52 syscall InitGraf
5B54 syscall InitFonts
5B56 syscall InitWindows
5B58 syscall InitMenus
5B5A syscall TEInit
5B5C syscall InitCursor
5B5E jsr [PC - 0x5796 /* 000003CA */]
5B62 subq.w A7, 4
5B64 syscall TickCount
5B66 move.l [A5 - 0xB4], [A7]+
5B6A cmpi.w [A5 - 0xA4], 0x280
5B70 bne +0x30 /* 00005BA0 */
5B72 subq.w A7, 4
5B74 move.w -[A7], 0x80
5B78 clr.l -[A7]
5B7A moveq.l D0, 0xFFFFFFFF
5B7C move.l -[A7], D0
5B7E syscall GetNewCWindow
5B80 move.l [A5 - 0x422], [A7]+
5B84 subq.w A7, 4
5B86 moveq.l D0, 0x6C
5B88 move.l -[A7], D0
5B8A jsr [PC - 0x58B0 /* 000002DC */]
5B8E move.l [A5 - 0x432], [A7]+
5B92 move.l -[A7], [A5 - 0x432]
5B96 syscall OpenCPort
5B98 move.l -[A7], [A5 - 0x432]
5B9C syscall SetPort
5B9E bra +0x1A /* 00005BB8 */
label00005BA0:
5BA0 subq.w A7, 4
5BA2 move.w -[A7], 0x81
5BA6 clr.l -[A7]
5BA8 moveq.l D0, 0xFFFFFFFF
5BAA move.l -[A7], D0
5BAC syscall GetNewCWindow
5BAE move.l [A5 - 0x422], [A7]+
5BB2 move.l -[A7], [A5 - 0x422]
5BB6 syscall SetPort
label00005BB8:
5BB8 moveq.l D0, 0x21
5BBA move.l -[A7], D0
5BBC syscall ForeColor
5BBE moveq.l D0, 0x1E
5BC0 move.l -[A7], D0
5BC2 syscall BackColor
5BC4 pea.l [A5 - 0x432]
5BC8 pea.l [A5 - 0x42E]
5BCC move.l D0, 0x80005
5BD2 syscall QDExtensions
5BD4 pea.l [A5 - 0x42A]
5BD8 clr.w -[A7]
5BDA clr.w -[A7]
5BDC move.w -[A7], 0x280
5BE0 move.w -[A7], 0x1E0
5BE4 syscall SetRect
5BE6 syscall ClearMenuBar
5BE8 subq.w A7, 4
5BEA move.w -[A7], 0x82
5BEE syscall GetNewMBar
5BF0 move.l [A5 - 0x436], [A7]+
5BF4 move.l -[A7], [A5 - 0x436]
5BF8 syscall SetMenuBar
5BFA subq.w A7, 4
5BFC move.w -[A7], 0x1
5C00 syscall GetMenuHandle
5C02 move.l -[A7], 0x44525652 /* 'DRVR' */
5C08 syscall AppendResMenu/AddResMenu
5C0A move.b [A5 - 0x437], 0x1
5C10 subq.w A7, 2
5C12 pea.l [A5 - 0x456]
5C16 move.w -[A7], 0x8
5C1A pea.l [A5 - 0x42A]
5C1E clr.l -[A7]
5C20 clr.l -[A7]
5C22 clr.l [A6 - 0x18]
5C26 move.l -[A7], [A6 - 0x18]
5C2A move.l D0, 0x160000
5C30 syscall QDExtensions
5C32 move.w D6, [A7]+
5C34 subq.w A7, 2
5C36 subq.w A7, 4
5C38 move.l -[A7], [A5 - 0x456]
5C3C move.l D0, 0x40017
5C42 syscall QDExtensions
5C44 move.l D0, 0x40001
5C4A syscall QDExtensions
5C4C move.b D7, [A7]+
5C4E subq.w A7, 2
5C50 pea.l [A5 - 0x452]
5C54 move.w -[A7], 0x8
5C58 pea.l [A5 - 0x42A]
5C5C clr.l -[A7]
5C5E clr.l -[A7]
5C60 clr.l [A6 - 0x18]
5C64 move.l -[A7], [A6 - 0x18]
5C68 move.l D0, 0x160000
5C6E syscall QDExtensions
5C70 move.w D6, [A7]+
5C72 subq.w A7, 2
5C74 subq.w A7, 4
5C76 move.l -[A7], [A5 - 0x452]
5C7A move.l D0, 0x40017
5C80 syscall QDExtensions
5C82 move.l D0, 0x40001
5C88 syscall QDExtensions
5C8A move.b D7, [A7]+
5C8C move.l -[A7], [A5 - 0x432]
5C90 move.l -[A7], [A5 - 0x42E]
5C94 move.l D0, 0x80006
5C9A syscall QDExtensions
5C9C jsr [PC - 0x5798 /* 00000506 */]
5CA0 jsr [PC - 0xF6A /* 00004D38 */]
5CA4 jsr [PC - 0x5688 /* 0000061E */]
5CA8 jsr [PC - 0xD90 /* 00004F1A */]
5CAC movem.l D6,D7, [A7]+
5CB0 unlink A6
5CB2 rts
fn00005CB4:
5CB4 link A6, -0x0022
5CB8 move.l -[A7], D7
5CBA tst.b [A5 - 0x439]
5CBE beq +0x14 /* 00005CD2 */
5CC0 subq.w A7, 2
5CC2 move.w -[A7], 0xFFFF
5CC6 pea.l [A6 - 0x20]
5CCA jsr [PC - 0x59E6 /* 000002E6 */]
5CCE move.b D7, [A7]+
5CD0 bra +0x10 /* 00005CE0 */
label00005CD2:
5CD2 subq.w A7, 2
5CD4 move.w -[A7], 0xFFFF
5CD8 pea.l [A6 - 0x20]
5CDC syscall GetNextEvent
5CDE move.b D7, [A7]+
label00005CE0:
5CE0 tst.b D7
5CE2 beq +0x80 /* 00005D62 */
5CE6 move.w D0, [A6 - 0x20]
5CEA bra +0x52 /* 00005D3C */
label00005CEC:
5CEC pea.l [A6 - 0x20]
5CF0 jsr [PC - 0x2BC /* 00005A36 */]
5CF4 bra +0x6E /* 00005D62 */
label00005CF8:
5CF8 pea.l [A6 - 0x20]
5CFC jsr [PC - 0xC56 /* 000050A8 */]
5D00 bra +0x62 /* 00005D62 */
label00005D04:
5D04 move.l -[A7], [A6 - 0x1E]
5D08 jsr [PC - 0x1F0 /* 00005B1A */]
5D0C bra +0x56 /* 00005D62 */
label00005D10:
5D10 pea.l [A6 - 0x20]
5D14 jsr [PC - 0xCAE /* 00005068 */]
5D18 bra +0x4A /* 00005D62 */
label00005D1A:
5D1A move.l -[A7], [A6 - 0x1E]
5D1E move.w -[A7], [A6 - 0x12]
5D22 jsr [PC - 0xCC8 /* 0000505C */]
5D26 bra +0x3C /* 00005D62 */
label00005D28:
5D28 pea.l [A6 - 0x20]
5D2C jsr [PC - 0x234 /* 00005AFA */]
5D30 bra +0x32 /* 00005D62 */
label00005D32:
5D32 pea.l [A6 - 0x20]
5D36 jsr [PC - 0xD84 /* 00004FB4 */]
5D3A bra +0x28 /* 00005D62 */
label00005D3C:
5D3C beq -0xA /* 00005D32 */
5D3E subq.w D0, 1
5D40 beq -0x54 /* 00005CEC */
5D42 subq.w D0, 2
5D44 beq -0x4C /* 00005CF8 */
5D46 subq.w D0, 2
5D48 beq -0x50 /* 00005CF8 */
5D4A subq.w D0, 1
5D4C beq -0x48 /* 00005D04 */
5D4E subq.w D0, 1
5D50 beq -0x40 /* 00005D10 */
5D52 subq.w D0, 1
5D54 beq -0x3A /* 00005D1A */
5D56 subq.w D0, 7
5D58 beq -0x30 /* 00005D28 */
5D5A pea.l [A6 - 0x20]
5D5E jsr [PC - 0xDAC /* 00004FB4 */]
label00005D62:
5D62 move.b D0, [A5 - 0x43A]
5D66 subq.b D0, 1
5D68 bne +0xA /* 00005D72 */
5D6A pea.l [A6 - 0x20]
5D6E jsr [PC - 0xDBC /* 00004FB4 */]
label00005D72:
5D72 move.l D7, [A7]+
5D74 unlink A6
5D76 rts
fn00005D78:
5D78 jsr [PC - 0xE6A /* 00004F10 */]
5D7C subq.w A7, 4
5D7E move.w -[A7], 0x1
5D82 syscall GetMenuHandle
5D84 syscall ReleaseResource
5D86 subq.w A7, 4
5D88 move.w -[A7], 0x2
5D8C syscall GetMenuHandle
5D8E syscall ReleaseResource
5D90 subq.w A7, 4
5D92 move.w -[A7], 0x4
5D96 syscall GetMenuHandle
5D98 syscall ReleaseResource
5D9A move.l -[A7], [A5 - 0x422]
5D9E syscall SetPort
5DA0 move.l -[A7], [A5 - 0x422]
5DA4 syscall DisposeWindow
5DA6 rts
export_0:
export_5:
5DA8 jsr [PC - 0x5D4C /* 0000005E */]
5DAC jsr [PC - 0x5AD4 /* 000002DA */]
5DB0 jsr [PC - 0x5C8C /* 00000126 */]
5DB4 link A6, 0x0000
5DB8 syscall MaxApplZone
5DBA syscall MoreMasters
5DBC pea.l [A5 - 0x102]
5DC0 jsr [PC - 0x5ACE /* 000002F4 */]
5DC4 tst.w [A5 - 0x102]
5DC8 bne +0xE /* 00005DD6 */
5DCA move.b [A5 - 0x3C7], 0x1
5DD0 clr.b [A5 - 0x3C9]
5DD4 bra +0xC /* 00005DE0 */
label00005DD6:
5DD6 clr.b [A5 - 0x3C7]
5DDA move.b [A5 - 0x3C9], 0x1
label00005DE0:
5DE0 clr.b [A5 - 0x3C8]
5DE4 move.w [A5 - 0x102], 0x1
label00005DEA:
5DEA move.w D0, [A5 - 0x102]
5DEE asl D0.w, 2
5DF0 addi.w D0, 0xFBDE
5DF4 clr.l [A5 + D0.w]
5DF8 subq.w A7, 2
5DFA move.w D7, [A5 - 0x102]
5DFE asl D7.w, 2
5E00 lea.l A0, [A5 - 0x422]
5E04 pea.l [A0 + D7.w]
5E08 move.w -[A7], 0x5
5E0C move.l -[A7], 0x80
5E12 clr.l -[A7]
5E14 syscall SndNewChannel
5E16 move.w D7, [A7]+
5E18 addq.w [A5 - 0x102], 1
5E1C cmpi.w [A5 - 0x102], 0x5
5E22 ble -0x38 /* 00005DEA */
5E24 move.w [A5 - 0x102], 0xC9
label00005E2A:
5E2A subq.w A7, 4
5E2C move.l -[A7], 0x736E6420 /* 'snd ' */
5E32 move.w -[A7], [A5 - 0x102]
5E36 syscall GetResource
5E38 move.w D0, [A5 - 0x102]
5E3C asl D0.w, 2
5E3E addi.w D0, 0xF8D2
5E42 move.l [A5 + D0.w], [A7]+
5E46 addq.w [A5 - 0x102], 1
5E4A cmpi.w [A5 - 0x102], 0xD7
5E50 ble -0x26 /* 00005E2A */
5E52 clr.b [A5 - 0x3CE]
5E56 jsr [PC - 0x312 /* 00005B46 */]
5E5A move.b [A5 - 0x43A], 0x1
5E60 clr.b [A5 - 0x439]
5E64 bra +0x6 /* 00005E6A */
label00005E66:
5E66 jsr [PC - 0x1B4 /* 00005CB4 */]
label00005E6A:
5E6A tst.b [A5 - 0x43A]
5E6E bne -0x8 /* 00005E66 */
5E70 jsr [PC - 0xFA /* 00005D78 */]
5E74 move.w [A5 - 0x102], 0x1
label00005E7A:
5E7A subq.w A7, 2
5E7C move.w D7, [A5 - 0x102]
5E80 asl D7.w, 2
5E82 lea.l A0, [A5 - 0x422]
5E86 move.l -[A7], [A0 + D7.w]
5E8A move.b -[A7], 0x1
5E8E syscall SndDisposeChannel
5E90 move.w D7, [A7]+
5E92 addq.w [A5 - 0x102], 1
5E96 cmpi.w [A5 - 0x102], 0x5
5E9C ble -0x22 /* 00005E7A */
5E9E move.w [A5 - 0x102], 0xC9
label00005EA4:
5EA4 move.w D0, [A5 - 0x102]
5EA8 asl D0.w, 2
5EAA addi.w D0, 0xF8D2
5EAE move.l -[A7], [A5 + D0.w]
5EB2 syscall ReleaseResource
5EB4 addq.w [A5 - 0x102], 1
5EB8 cmpi.w [A5 - 0x102], 0xD7
5EBE ble -0x1A /* 00005EA4 */
5EC0 unlink A6
5EC2 jsr [PC - 0x5E7C /* 00000048 */]
