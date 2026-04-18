cmake_minimum_required(VERSION 3.15)
set(PROJECT_NAME "pdfx")
project(${PROJECT_NAME} LANGUAGES CXX)

set(ARCH "x64")
set(PDFIUM_VERSION "4690" CACHE STRING "Version of pdfium used")

# [MODIFIED] Manual override to bypass CMake download issues on local C drive
set(pdfium_SOURCE_DIR "C:/cosmonet_reader/pdfium_manual")

# This value is used when generating builds using this plugin, so it must
# not be changed
set(PLUGIN_NAME "pdfx_plugin")

include(${pdfium_SOURCE_DIR}/PDFiumConfig.cmake)

add_library(${PLUGIN_NAME} SHARED
  "pdfx.cpp"
  "pdfx.h"
  "pdfx_plugin.cpp"
)

# [MODIFIED] Manually apply standard settings for VS 2026 compatibility
set_target_properties(${PLUGIN_NAME} PROPERTIES
  CXX_STANDARD 17
  CXX_STANDARD_REQUIRED ON
  CXX_VISIBILITY_PRESET hidden
)

target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)
target_include_directories(${PLUGIN_NAME} INTERFACE
  "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_link_libraries(${PLUGIN_NAME} PRIVATE pdfium flutter flutter_wrapper_plugin)

# List of absolute paths to libraries that should be bundled with the plugin
set(pdfx_bundled_libraries
  "${PDFium_LIBRARY}"
  PARENT_SCOPE
)
