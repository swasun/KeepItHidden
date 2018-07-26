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

if (LIBUEUM_SYSTEM)
    if (WIN32)
        set(LIBUNKNOWNECHOUTILSMODULE_INCLUDE_DIR "C:\\LibUnknownEchoUtilsModule\\$ENV{name}\\include")
        set(LIBUNKNOWNECHOUTILSMODULE_LIBRARIES "C:\\LibUnknownEchoUtilsModule\\$ENV{name}\\lib\\ueum_static.lib")
    elseif (UNIX)
        find_library(LIBUNKNOWNECHOUTILSMODULE_LIBRARIES
            NAMES ueum_static libueum_static ueum libueum
            HINTS ${CMAKE_INSTALL_PREFIX}/lib)
        find_path(LIBUNKNOWNECHOUTILSMODULE_INCLUDE_DIR ueum)
    endif ()
else (LIBUEUM_SYSTEM)
    include (ExternalProject)

    set(LIBUEUM_URL https://github.com/swasun/LibUnknownEchoUtilsModule.git)
    set(LIBUNKNOWNECHOUTILSMODULE_INCLUDE_DIR ${LIBUEUM_INSTALL}/external/libueum_archive)
    set(LIBUEUM_BUILD ${ROOT_BUILD_DIR}/libueum/src/libueum)

    if (WIN32)
        set(LIBUNKNOWNECHOUTILSMODULE_LIBRARIES "${LIBUEUM_INSTALL}\\lib\\ueum_static.lib")
    else()
        set(LIBUNKNOWNECHOUTILSMODULE_LIBRARIES ${LIBUEUM_INSTALL}/lib/libueum_static.a)
    endif()

    ExternalProject_Add(libueum
        PREFIX libueum
        GIT_REPOSITORY ${LIBUEUM_URL}    
        BUILD_IN_SOURCE 1
        BUILD_BYPRODUCTS ${LIBUNKNOWNECHOUTILSMODULE_LIBRARIES}
        DOWNLOAD_DIR "${DOWNLOAD_LOCATION}"
        CMAKE_CACHE_ARGS
            -DCMAKE_BUILD_TYPE:STRING=Release
            -DCMAKE_INSTALL_PREFIX:STRING=${LIBUEUM_INSTALL}
            -DROOT_BUILD_DIR:STRING=${ROOT_BUILD_DIR}
            -DCMAKE_C_FLAGS:STRING=-fPIC
    )
endif (LIBUEUM_SYSTEM)
