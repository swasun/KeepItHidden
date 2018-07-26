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

if (LIBSMO_SYSTEM)
    if (WIN32)
        set(LIBSHAREDMEMORYOBJECT_INCLUDE_DIR "C:\\LibSharedMemoryObject\\$ENV{name}\\include")
        set(LIBSHAREDMEMORYOBJECT_LIBRARIES "C:\\LibSharedMemoryObject\\$ENV{name}\\lib\\smo_static.lib")
    elseif (UNIX)
        find_library(LIBSHAREDMEMORYOBJECT_LIBRARIES
            NAMES smo_static libsmo_static smo libsmo
            HINTS ${CMAKE_INSTALL_PREFIX}/lib)
        find_path(LIBSHAREDMEMORYOBJECT_INCLUDE_DIR smo)
    endif ()
else (LIBSMO_SYSTEM)
    include (ExternalProject)

    set(LIBSMO_URL https://github.com/swasun/LibSharedMemoryObject.git)
    set(LIBSHAREDMEMORYOBJECT_INCLUDE_DIR ${LIBSMO_INSTALL}/external/libsmo_archive)
    set(LIBSMO_BUILD ${ROOT_BUILD_DIR}/libsmo/src/libsmo)

    if (WIN32)
        set(LIBSHAREDMEMORYOBJECT_LIBRARIES "${LIBSMO_INSTALL}\\lib\\smo_static.lib")
    else()
        set(LIBSHAREDMEMORYOBJECT_LIBRARIES ${LIBSMO_INSTALL}/lib/libsmo_static.a)
    endif()

    ExternalProject_Add(libsmo
        PREFIX libsmo
        GIT_REPOSITORY ${LIBSMO_URL}    
        BUILD_IN_SOURCE 1
        BUILD_BYPRODUCTS ${LIBSHAREDMEMORYOBJECT_LIBRARIES}
        DOWNLOAD_DIR "${DOWNLOAD_LOCATION}"
        CMAKE_CACHE_ARGS
            -DCMAKE_BUILD_TYPE:STRING=Release
            -DCMAKE_INSTALL_PREFIX:STRING=${LIBSMO_INSTALL}
            -DROOT_BUILD_DIR:STRING=${ROOT_BUILD_DIR}
            -DCMAKE_C_FLAGS:STRING=-fPIC
    )
endif (LIBSMO_SYSTEM)
