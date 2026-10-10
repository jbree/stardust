/* Overlay panels that replace the original's menu bar and dialogs. */
#ifndef PANEL_H
#define PANEL_H

#include "mac.h"

enum { kPanelAction, kPanelChoice, kPanelHeading };

typedef struct {
    const char *label;
    int kind;
    Boolean checked; /* kPanelChoice: the selected option of its group */
    Boolean disabled;
} PanelItem;

/* Returns the chosen item's index, or -1 for Escape or a click outside.
 * *sel is the highlighted item, kept so a re-opened panel stays in place. */
int PanelChoose(const char *title, const char *hint, const PanelItem *items, int n, int *sel);

/* A text field; letters are upper-cased as typed. Returns false if cancelled. */
Boolean PanelAskText(const char *title, const char *prompt, char *buf, int size);

/* A notice: open it, play its sound, then wait for a click or key. */
void PanelMessageOpen(const char *text);
void PanelMessageWait(void);

#endif
