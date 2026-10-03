#include <gxvk/gxvk.hpp>
#include <vulkan/vulkan.h>

namespace gxvk {

static VkInstance g_instance = VK_NULL_HANDLE;

bool initialize() {
    VkApplicationInfo app{};
    app.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO;
    app.pApplicationName = "re4-switch";
    app.applicationVersion = VK_MAKE_VERSION(0, 1, 0);
    app.pEngineName = "GXVK";
    app.engineVersion = VK_MAKE_VERSION(0, 1, 0);
    app.apiVersion = VK_API_VERSION_1_3;

    VkInstanceCreateInfo create{};
    create.sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO;
    create.pApplicationInfo = &app;

    const VkResult result = vkCreateInstance(&create, nullptr, &g_instance);
    return result == VK_SUCCESS;
}

void shutdown() {
    if (g_instance != VK_NULL_HANDLE) {
        vkDestroyInstance(g_instance, nullptr);
        g_instance = VK_NULL_HANDLE;
    }
}

const char* backend_name() {
    return "GXVK / Vulkan / Mesa NVK";
}

} // namespace gxvk
