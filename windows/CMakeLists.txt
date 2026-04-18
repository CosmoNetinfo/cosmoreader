# Project-level configuration.
cmake_minimum_required(VERSION 3.14)
set(CMAKE_POLICY_VERSION_MINIMUM 3.5)
project(cosmonet_reader LANGUAGES CXX)

# [FIX] Manually define Flutter standard macros for VS 2026 compatibility
macro(apply_standard_settings TARGET_ID)
  target_compile_features(${TARGET_ID} PRIVATE cxx_std_17)
  if(MSVC)
    target_compile_options(${TARGET_ID} PRIVATE /W4 /WX /wd"4100")
    target_compile_definitions(${TARGET_ID} PRIVATE "_UNICODE" "UNICODE")
  endif()
endmacro()

macro(apply_standard_executable_settings TARGET_ID)
  apply_standard_settings(${TARGET_ID})
endmacro()

# The name of the executable created for the application. Change this to change
# the on-disk name of your application.
set(BINARY_NAME "cosmonet_reader")

# Explicitly opt in to modern CMake behaviors to avoid warnings with recent
# versions of CMake.
set(CMAKE_POLICY_DEFAULT_CMP0048 NEW)

# Include the flutter configuration.
add_subdirectory(flutter)

# Define the executable and its dependencies.
add_executable(${BINARY_NAME} WIN32
  "runner/main.cpp"
  "runner/resource.h"
  "runner/runner.rc"
  "runner/utils.cpp"
  "runner/win32_window.cpp"
  "runner/flutter_window.cpp"
  "flutter/generated_plugin_registrant.cc"
  "${FLUTTER_MANAGED_SOURCES}"
)
apply_standard_executable_settings(${BINARY_NAME})
target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app dwmapi)
target_include_directories(${BINARY_NAME} PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}")

# Include the plugins AFTER the executable is defined
include(flutter/generated_plugins.cmake)

# Add any additional libraries or flags here.
foreach(plugin_name ${FLUTTER_PLUGIN_LIST})
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin_name}_plugin)
endforeach()
