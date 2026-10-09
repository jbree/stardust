/* Host services used by the Toolbox layer. */
#ifndef PLATFORM_H
#define PLATFORM_H

#include "mac.h"

unsigned char *LoadAssetFile(const char *name, long *size);
void ScreenDirty(void);
/* Pump host events at most every few ms; never blocks. */
void PlatformPoll(void);
/* Called by busy-wait loops when no Mac time has passed. */
void PlatformIdle(void);
/* Test-mode event log (sounds, traps). */
void PlatformLog(const char *fmt, int value);

#endif
