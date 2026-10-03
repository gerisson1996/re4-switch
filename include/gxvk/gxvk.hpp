#pragma once

namespace gxvk {

// GXVK is the compatibility boundary between RE4's GameCube GX calls
// and the Vulkan/NVK renderer used by the Switch port.
bool initialize();
void shutdown();
const char* backend_name();

} // namespace gxvk
