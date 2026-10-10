/* Menu and Dialog Manager subsets, used only to run the original 68k code. */
#ifndef MACUI_H
#define MACUI_H

#include "../src/mac.h"

/* ------------------------------------------------------------------ */
/* Menus */

typedef struct MenuItemDef { const char *text; char key; Boolean enabled; Boolean checked; } MenuItemDef;
typedef struct Menu {
    int16_t id;
    const char *title;
    Boolean enabled;
    int nitems;
    MenuItemDef items[8];
} Menu, **MenuHandle;

void InstallMenuBar(void);
MenuHandle GetMenuHandle(int id);
void EnableItem(MenuHandle m, int item);
void DisableItem(MenuHandle m, int item);
void CheckItem(MenuHandle m, int item, Boolean checked);
void DrawMenuBar(void);
void HiliteMenu(int id);
int32_t MenuSelect(Point start);
int32_t MenuKey(char ch);

/* ------------------------------------------------------------------ */
/* Dialogs */

typedef struct Dialog *DialogPtr;
typedef void (*UserItemProc)(DialogPtr d, int item);

DialogPtr GetNewDialog(int id);
void DrawDialog(DialogPtr d);
void DisposeDialog(DialogPtr d);
void ModalDialog(int *itemHit);
void GetDialogItemRect(DialogPtr d, int item, Rect *r);
void SetDialogItemProc(DialogPtr d, int item, UserItemProc proc);
void GetDialogItemText(DialogPtr d, int item, char *out, int outSize);
GWorldPtr DialogPort(DialogPtr d); /* local-coordinate port of the dialog */

#endif
