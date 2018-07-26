 #####################################################################################
 # MIT License                                                                       #
 #                                                                                   #
 # Copyright (C) 2018 Charly Lamothe                                                 #
 #                                                                                   #
 # This file is part of KeepItHidden.                                                #
 #                                                                                   #
 #   Permission is hereby granted, free of charge, to any person obtaining a copy    #
 #   of this software and associated documentation files (the "Software"), to deal   #
 #   in the Software without restriction, including without limitation the rights    #
 #   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell       #
 #   copies of the Software, and to permit persons to whom the Software is           #
 #   furnished to do so, subject to the following conditions:                        #
 #                                                                                   #
 #   The above copyright notice and this permission notice shall be included in all  #
 #   copies or substantial portions of the Software.                                 #
 #                                                                                   #
 #   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR      #
 #   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,        #
 #   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE     #
 #   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER          #
 #   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,   #
 #   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE   #
 #   SOFTWARE.                                                                       #
 #####################################################################################

# --- PROJECT ---

PROJECT(kih C)
cmake_minimum_required(VERSION 3.8)


# --- GLOBAL OPTIONS ---

set(CMAKE_VERBOSE_MAKEFILE on)
SET(ROOT_BUILD_DIR ${CMAKE_CURRENT_BINARY_DIR} CACHE STRING "Default root path of the current build directory")


# --- DEPENDENCIES OPTIONS ---

SET(LIBEI_SYSTEM TRUE CACHE BOOL "Default LIBEI installation type")
set(LIBEI_INSTALL ${ROOT_BUILD_DIR}/libei/install CACHE STRING "Default LIBEI install path")

SET(LIBUEUM_SYSTEM TRUE CACHE BOOL "Default LIBUEUM installation type")
set(LIBUEUM_INSTALL ${ROOT_BUILD_DIR}/libueum/install CACHE STRING "Default LIBUEUM install path")

SET(LIBUECM_SYSTEM TRUE CACHE BOOL "Default LIBUECM installation type")
set(LIBUECM_INSTALL ${ROOT_BUILD_DIR}/libuecm/install CACHE STRING "Default LIBUECM install path")

SET(LIBSMO_SYSTEM TRUE CACHE BOOL "Default LIBSMO installation type")
set(LIBSMO_INSTALL ${ROOT_BUILD_DIR}/libsmo/install CACHE STRING "Default LIBSMO install path")

SET(LIBMS_SYSTEM TRUE CACHE BOOL "Default LIBMS installation type")
set(LIBMS_INSTALL ${ROOT_BUILD_DIR}/libms/install CACHE STRING "Default LIBMS install path")

SET(LIBMP_SYSTEM TRUE CACHE BOOL "Default LIBMP installation type")
set(LIBMP_INSTALL ${ROOT_BUILD_DIR}/libmp/install CACHE STRING "Default LIBMP install path")

SET(OPENSSL_SYSTEM TRUE CACHE BOOL "Default  OPENSSL installation type")

SET(ZLIB_SYSTEM TRUE CACHE BOOL "Default ZLIB installation type")


# --- PATH ---

set(${CMAKE_CURRENT_SOURCE_DIR} ..)
set(CONTROLLER_SRC_PATH "${CMAKE_CURRENT_SOURCE_DIR}/src/controller")
set(INITIALIZER_SRC_PATH "${CMAKE_CURRENT_SOURCE_DIR}/src/initializer")
set(PLUGINS_SRC_PATH "${CMAKE_CURRENT_SOURCE_DIR}/src/plugins")

if (CMAKE_BUILD_TYPE STREQUAL "Release")
    set(OUTPUT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/bin/release")
elseif (CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(OUTPUT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/bin/debug")
endif ()


# --- COMPILE OPTIONS ---

# Compile options for Microsoft Visual Studio
if (MSVC)
    # Add O2 optimization if build type is Release
    if (CMAKE_BUILD_TYPE STREQUAL "Release")
        add_compile_options("$<$<CONFIG:RELEASE>:/O2>")
    endif ()
    add_compile_options("/W4")
    if (MSVC_VERSION GREATER_EQUAL 1900)
        add_compile_options("/permissive-") # Add /permissive- (kind of -pedantic) available since Visual Studio 2017
    endif ()
    add_compile_options("/W4") 
    set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON) # This variable is used to initialize the property on each target as it is created
    set(CMAKE_C_FLAGS "${CMAKE_ENABLE_C11}") # Compile with C11 rules

    # Use secure functions by defaualt and suppress warnings about
    # deprecated" functions
    # TODO: try to remove this flags and fix the issue raised
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /D _CRT_SECURE_CPP_OVERLOAD_STANDARD_NAMES=1")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /D _CRT_SECURE_CPP_OVERLOAD_STANDARD_NAMES_COUNT=1")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /D _CRT_NONSTDC_NO_WARNINGS=1 /D _CRT_SECURE_NO_WARNINGS=1")
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang") # If compiler is Clang
    if (CMAKE_BUILD_TYPE STREQUAL "Release") # Release build mode
        # Set all this flags explicitly, even if some of them may be covered by -Wall, in order to fine-tune the warning flags we want
        # Note that -Weverything isn't available in some version of Mac and iOS
        # Source: https://github.com/macmade/SeriousCode
        add_compile_options("-Wall" "-Wbad-function-cast" "-Wcast-align" "-Wconversion" "-Wdeclaration-after-statement"
            "-Wdeprecated-implementations" "-Wextra" "-Wfloat-equal" "-Wformat=2" "-Wformat-nonliteral" "-Wfour-char-constants"
            "-Wimplicit-atomic-properties" "-Wmissing-braces" "-Wmissing-declarations" "-Wmissing-field-initializers"
            "-Wmissing-format-attribute" "-Wmissing-noreturn" "-Wmissing-prototypes" "-Wnested-externs" "-Wnewline-eof"
            "-Wold-style-definition" "-Woverlength-strings" "-Wparentheses" "-Wpointer-arith" "-Wredundant-decls"
            "-Wreturn-type" "-Wsequence-point" "-Wshadow" "-Wshorten-64-to-32" "-Wsign-compare" "-Wsign-conversion"
            "-Wstrict-prototypes" "-Wstrict-selector-match" "-Wswitch -Wswitch-default" "-Wswitch-enum" "-Wundeclared-selector"
            "-Wuninitialized" "-Wunknown-pragmas" "-Wunreachable-code" "-Wunused-function" "-Wunused-label" "-Wunused-parameter"
            "-Wunused-value" "-Wunused-variable" "-Wwrite-strings")
    else ()
        # Minimum flags for debug mode
        add_compile_options("-Wall" "-Werror" "-Wextra" "-g")
    endif ()
else ()
    # Unix plateform
    if (UNIX)
        add_compile_options("-std=gnu11" "-pthread" "-ldl")
        if (CMAKE_BUILD_TYPE STREQUAL "Release") # Release build mode
            if (CMAKE_COMPILER_IS_GNUCC) # GNU compiler
                add_compile_options("-O2") # O2 optimization
                set(CMAKE_EXE_LINKER_FLAGS "-s") # Strip binary (only in release mode as it prevent debugging)

                # Hardening options
                ## -fstack-protector-strong
                ### Stack smashing protector
                ## -D_FORTIFY_SOURCE=2
                ### Compile-time protection against static sized buffer overflows.
                ### No known regressions or performance loss
                ## -Wl,-z,now
                ### Disable lazy binding
                ## -Wl,-z,relro
                ### Read-only segments after relocation
                add_compile_options("-D_FORTIFY_SOURCE=2" "-Wl,-z,now" "-Wl,-z,relro")
                if (CMAKE_COMPILER_IS_GNUCC VERSION_GREATER 4.9)
                    add_compile_options("-fstack-protector-strong")
                endif ()
            endif ()
        else () # Debug mode
            add_compile_options("-g") # Add debug symbols
        endif ()
    endif ()
    # It should work on any unix platform ?
    if (CMAKE_BUILD_TYPE STREQUAL "Release") # Release mode
        add_compile_options("$<$<CONFIG:RELEASE>:-O2>" "-fno-builtin")
    endif ()
    ## -Werror=format-security
    ### Reject potentially unsafe format string arguments
    ## -Werror=implicit-function-declaration
    ### Reject missing function prototypes
    #add_compile_options("-Wall" "-Wextra" "-Werror" "-pedantic" "-Werror=format-security" "-Werror=implicit-function-declaration")
    add_compile_options("-Wall" "-Wextra" "-pedantic" "-Werror=format-security" "-Werror=implicit-function-declaration")
endif ()

if (WIN32)
    macro(get_WIN32_WINNT version)
    if (WIN32 AND CMAKE_SYSTEM_VERSION)
        set(ver ${CMAKE_SYSTEM_VERSION})
        string(REPLACE "." "" ver ${ver})
        string(REGEX REPLACE "([0-9])" "0\\1" ver ${ver})
        set(${version} "0x${ver}")
    endif ()
    endmacro()
    get_WIN32_WINNT(ver)
    add_definitions(-D_WIN32_WINNT=${ver})
endif ()

# CCache

find_program(CCACHE_PROGRAM ccache)
if (CCACHE_PROGRAM)
    set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE "${CCACHE_PROGRAM}")
    set_property(GLOBAL PROPERTY RULE_LAUNCH_LINK "${CCACHE_PROGRAM}")
endif()


# --- SEARCH DEPENDENCIES ---

# External dependencies
set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/external)

# Location where external projects will be downloaded
set (DOWNLOAD_LOCATION "${CMAKE_CURRENT_BINARY_DIR}/downloads"
    CACHE PATH "Location where external projects will be downloaded.")
mark_as_advanced(DOWNLOAD_LOCATION)

# LibErrorInterceptor
include(libei)

# LibUnknownEchoUtilsModule
include(libueum)

include(openssl)

# ZLib
include(zlib)

# LibUnknownEchoCryptoModule
include(libuecm)

# LibSharedMemoryObject
include(libsmo)

# LibMemorySlot
include(libms)

# LibMemoryPlugin
include(libmp)

# Search pthread
if (UNIX)
    find_package (Threads)
endif ()

if (NOT ZLIB_SYSTEM)
    list(APPEND KIH_DEPENDENCIES zlib)
endif ()

if (NOT LIBEI_SYSTEM)
    list(APPEND KIH_DEPENDENCIES libei)
endif ()

if (NOT LIBUEUM_SYSTEM)
    list(APPEND KIH_DEPENDENCIES libueum)
endif ()

if (NOT LIBUECM_SYSTEM)
    list(APPEND KIH_DEPENDENCIES libuecm)
endif ()

if (NOT LIBSMO_SYSTEM)
    list(APPEND KIH_DEPENDENCIES libsmo)
endif ()

if (NOT LIBMS_SYSTEM)
    list(APPEND KIH_DEPENDENCIES libms)
endif ()

if (NOT LIBMP_SYSTEM)
    list(APPEND KIH_DEPENDENCIES libmp)
endif ()

if (NOT OPENSSL_SYSTEM)
    list(APPEND KIH_DEPENDENCIES openssl)
endif ()

set(KIH_LIBRARIES
    ${LIBERRORINTERCEPTOR_LIBRARIES}
    ${LIBUNKNOWNECHOUTILSMODULE_LIBRARIES}
    ${LIBSHAREDOBJECTMEMORY_LIBRARIES}
    ${LIBMEMORYSLOT_LIBRARIES}
    ${LIBUNKNOWNECHOCRYPTOMODULE_LIBRARIES}
    ${OPENSSL_LIBRARIES}
    ${ZLIB_LIBRARIES}
    ${LIBMEMORYPLUGIN_LIBRARIES}
    ${CMAKE_THREAD_LIBS_INIT}
)

set(KIH_INCLUDE_DIR
    ${LIBERRORINTERCEPTOR_INCLUDE_DIR}
    ${LIBUNKNOWNECHOUTILSMODULE_INCLUDE_DIR}
    ${LIBSHAREDOBJECTMEMORY_INCLUDE_DIR}
    ${ZLIB_INCLUDE_DIR}
    ${OPENSSL_INCLUDE_DIR}
    ${LIBUNKNOWNECHOCRYPTOMODULE_INCLUDE_DIR}
    ${LIBMEMORYSLOT_INCLUDE_DIR}
    ${LIBMEMORYPLUGIN_INCLUDE_DIR}
)


# --- BUILD ---

# Build controller
file(GLOB_RECURSE PROGRAM_TARGET_SRC_FILES "${CONTROLLER_SRC_PATH}/*.*")
add_executable(controller ${PROGRAM_TARGET_SRC_FILES})
if (KIH_DEPENDENCIES)
    add_dependencies(controller ${KIH_DEPENDENCIES})
endif ()
target_include_directories(controller PUBLIC ${KIH_INCLUDE_DIR})
target_link_libraries(controller ${KIH_LIBRARIES})
set_target_properties(controller PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${OUTPUT_PATH})

# Build initializer
file(GLOB_RECURSE PROGRAM_TARGET_SRC_FILES "${INITIALIZER_SRC_PATH}/*.*")
add_executable(initializer ${PROGRAM_TARGET_SRC_FILES})
if (KIH_DEPENDENCIES)
    add_dependencies(initializer ${KIH_DEPENDENCIES})
endif ()
target_include_directories(initializer PUBLIC ${KIH_INCLUDE_DIR})
target_link_libraries(initializer ${KIH_LIBRARIES})
set_target_properties(initializer PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${OUTPUT_PATH})

# Build plugins
file(GLOB files "${PLUGINS_SRC_PATH}/*.c")
foreach (filePath ${files} )
    get_filename_component(pluginName ${filePath} NAME_WE)
    message(STATUS "Build plugin : ${pluginName}")
    add_library(${pluginName} SHARED ${filePath})
    set_target_properties(${pluginName} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${OUTPUT_PATH})
endforeach ()