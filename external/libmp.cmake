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

if (LIBMP_SYSTEM)
    if (WIN32)
        set(LIBMEMORYPLUGIN_INCLUDE_DIR "C:\\LibMemoryPlugin\\$ENV{name}\\include")
        set(LIBMEMORYPLUGIN_LIBRARIES "C:\\LibMemoryPlugin\\$ENV{name}\\lib\\mp_static.lib")
    elseif (UNIX)
        find_library(LIBMEMORYPLUGIN_LIBRARIES
            NAMES mp_static libmp_static mp libmp
            HINTS ${CMAKE_INSTALL_PREFIX}/lib)
        find_path(LIBMEMORYPLUGIN_INCLUDE_DIR mp)
    endif ()
else (LIBMP_SYSTEM)
    include (ExternalProject)

    set(LIBMP_URL https://github.com/swasun/LibMemoryPlugin.git)
    set(LIBMEMORYPLUGIN_INCLUDE_DIR ${LIBMP_INSTALL}/external/libmp_archive)
    set(LIBMP_BUILD ${ROOT_BUILD_DIR}/libmp/src/libmp)

    if (WIN32)
        set(LIBMEMORYPLUGIN_LIBRARIES "${LIBMP_INSTALL}\\lib\\mp_static.lib")
    else()
        set(LIBMEMORYPLUGIN_LIBRARIES ${LIBMP_INSTALL}/lib/libmp_static.a)
    endif()

    ExternalProject_Add(libmp
        PREFIX libmp
        GIT_REPOSITORY ${LIBMP_URL}    
        BUILD_IN_SOURCE 1
        BUILD_BYPRODUCTS ${LIBMEMORYPLUGIN_LIBRARIES}
        DOWNLOAD_DIR "${DOWNLOAD_LOCATION}"
        CMAKE_CACHE_ARGS
            -DCMAKE_BUILD_TYPE:STRING=Release
            -DCMAKE_INSTALL_PREFIX:STRING=${LIBMP_INSTALL}
            -DROOT_BUILD_DIR:STRING=${ROOT_BUILD_DIR}
            -DCMAKE_C_FLAGS:STRING=-fPIC
            -DCMAKE_WITH_CRYPTO:BOOL=TRUE
    )
endif (LIBMP_SYSTEM)
