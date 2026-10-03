#include <gxvk/gxvk.hpp>

namespace gxvk {

bool initialize() {
    // M0: renderer bootstrap placeholder.
    // M1 will initialize the externally-built Mesa NVK Vulkan stack here.
    return true;
}

void shutdown() {
}

const char* backend_name() {
    return "GXVK / Vulkan-NVK (bootstrap)";
}

} // namespace gxvk
