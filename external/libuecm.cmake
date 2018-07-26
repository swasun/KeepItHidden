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

if (LIBUECM_SYSTEM)
    if (WIN32)
        set(LIBUNKNOWNECHOCRYPTOMODULE_INCLUDE_DIR "C:\\LibUnknownEchoCryptoModule\\$ENV{name}\\include")
        set(LIBUNKNOWNECHOCRYPTOMODULE_LIBRARIES "C:\\LibUnknownEchoCryptoModule\\$ENV{name}\\lib\\uecm_static.lib")
    elseif (UNIX)
        find_library(LIBUNKNOWNECHOCRYPTOMODULE_LIBRARIES
            NAMES uecm_static libuecm_static uecm libuecm
            HINTS ${CMAKE_INSTALL_PREFIX}/lib)
        find_path(LIBUNKNOWNECHOCRYPTOMODULE_INCLUDE_DIR uecm)
    endif ()
else (LIBUECM_SYSTEM)
    include (ExternalProject)

    set(LIBUECM_URL https://github.com/swasun/LibUnknownEchoCryptoModule.git)
    set(LIBUNKNOWNECHOCRYPTOMODULE_INCLUDE_DIR ${LIBUECM_INSTALL}/external/libuecm_archive)
    set(LIBUECM_BUILD ${ROOT_BUILD_DIR}/libuecm/src/libuecm)

    if (WIN32)
        set(LIBUNKNOWNECHOCRYPTOMODULE_LIBRARIES "${LIBUECM_INSTALL}\\lib\\uecm_static.lib")
    else()
        set(LIBUNKNOWNECHOCRYPTOMODULE_LIBRARIES ${LIBUECM_INSTALL}/lib/libuecm_static.a)
    endif()

    ExternalProject_Add(libuecm
        PREFIX libuecm
        GIT_REPOSITORY ${LIBUECM_URL}    
        BUILD_IN_SOURCE 1
        BUILD_BYPRODUCTS ${LIBUNKNOWNECHOCRYPTOMODULE_LIBRARIES}
        DOWNLOAD_DIR "${DOWNLOAD_LOCATION}"
        CMAKE_CACHE_ARGS
            -DCMAKE_BUILD_TYPE:STRING=Release
            -DCMAKE_INSTALL_PREFIX:STRING=${LIBUECM_INSTALL}
            -DROOT_BUILD_DIR:STRING=${ROOT_BUILD_DIR}
            -DCMAKE_C_FLAGS:STRING=-fPIC
    )
endif (LIBUECM_SYSTEM)
