/*
 * Stardust 1.1 (c) 1995 James Burton, translated from the 68k CODE resource.
 *
 * Every function here corresponds to one routine of the original THINK Pascal
 * program; the comment above each gives its offset in CODE 1 (after the
 * 4-byte header) so it can be checked against re/code1.asm. Globals keep the
 * A5-relative offset they had in the original.
 */
#ifndef STARDUST_H
#define STARDUST_H

#include "mac.h"

/* Grid cell codes (fn3DBE maps level characters to these). */
enum {
    kEmpty = 0,
    kStarWall = 1,  /* '1' erasable multi-colored wall */
    kGrayWall = 2,  /* '2' and the level border */
    kEntrance = 3,  /* '3' */
    kExit = 4,      /* '4' */
    kBlueBlock = 5, /* made by magic */
    kGreenBlock = 6,/* made by magic */
    kWarpPocket = 7,/* '5' */
    kRedBlock = 8,  /* '6' */
    kStars = 9,     /* '7', '/', '&', '^' */
    kFallwall = 10, /* '8' */
    kLeftWall = 11, /* '!' */
    kRightWall = 12,/* '@' */
    kElevator = 13, /* '#' */
    kTunnel = 14,   /* '$' */
    kWarp = 15,     /* '%' */
    kVictory = 16,  /* '(' ; ')' is drawn by the victory animation */
};

/* Hero states (A5-0x3C2). */
enum {
    kStanding = 0,
    kWalked = 1,
    kLookingUp = 2,
    kCrouching = 3,
    kFalling = 4,
    kGone = 5,  /* waiting to reappear at the entrance */
    kWon = 6,
};

/* Hero actions: the cases of fn22CC. */
enum {
    aStand = 0,
    aWalk = 1,
    aLookUp = 2,
    aCrouch = 3,
    aStayCrouched = 4,
    aStandUp = 5,
    aFall = 6,
    aElevator = 7,
    aMagicSide = 8,
    aMagicDown = 9,
    aMagicUp = 10,
    aDissolve = 11,
    aReappear = 12,
    aWarp = 13,
    aExitLevel = 14,
    aVictory = 15,
};

int StardustMain(void);

#endif
