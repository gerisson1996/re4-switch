#include <switch.h>
#include <cstdio>
#include <gxvk/gxvk.hpp>

int main(int argc, char** argv) {
    consoleInit(nullptr);
    padConfigureInput(1, HidNpadStyleSet_NpadStandard);

    PadState pad;
    padInitializeDefault(&pad);

    std::printf("re4-switch - M0 bootstrap\\n");
    std::printf("Renderer: %s\\n", gxvk::backend_name());

    if (!gxvk::initialize()) {
        std::printf("GXVK initialization failed.\\n");
    } else {
        std::printf("GXVK bootstrap initialized.\\n");
    }

    std::printf("\\nPress + to exit.\\n");

    while (appletMainLoop()) {
        padUpdate(&pad);
        const u64 down = padGetButtonsDown(&pad);
        if (down & HidNpadButton_Plus) {
            break;
        }
        consoleUpdate(nullptr);
    }

    gxvk::shutdown();
    consoleExit(nullptr);
    return 0;
}
