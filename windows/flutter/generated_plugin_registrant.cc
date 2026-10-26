//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <camera_usb/camera_usb_plugin_c_api.h>
#include <camera_windows/camera_windows.h>
#include <permission_handler_windows/permission_handler_windows_plugin.h>
#include <simple_camera_windows/simple_camera_windows_plugin_c_api.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  CameraUsbPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("CameraUsbPluginCApi"));
  CameraWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("CameraWindows"));
  PermissionHandlerWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PermissionHandlerWindowsPlugin"));
  SimpleCameraWindowsPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SimpleCameraWindowsPluginCApi"));
}
