#include "mac.h"
#include "stardust.h"

int main(int argc, char **argv)
{
    (void)argc, (void)argv;
    if (PlatformInit() != 0)
        return 1;
    StardustMain();
    ExitToShell();
    return 0;
}
