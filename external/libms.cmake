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

if (LIBMS_SYSTEM)
    if (WIN32)
        set(LIBMEMORYSLOT_INCLUDE_DIR "C:\\LibMemorySlot\\$ENV{name}\\include")
        set(LIBMEMORYSLOT_LIBRARIES "C:\\LibMemorySlot\\$ENV{name}\\lib\\ms_static.lib")
    elseif (UNIX)
        find_library(LIBMEMORYSLOT_LIBRARIES
            NAMES ms_static libms_static ms libms
            HINTS ${CMAKE_INSTALL_PREFIX}/lib)
        find_path(LIBMEMORYSLOT_INCLUDE_DIR ms)
    endif ()
else (LIBMS_SYSTEM)
    include (ExternalProject)

    set(LIBMS_URL https://github.com/swasun/LibMemorySlot.git)
    set(LIBMEMORYSLOT_INCLUDE_DIR ${LIBMS_INSTALL}/external/libms_archive)
    set(LIBMS_BUILD ${ROOT_BUILD_DIR}/libms/src/libms)

    if (WIN32)
        set(LIBMEMORYSLOT_LIBRARIES "${LIBMS_INSTALL}\\lib\\ms_static.lib")
    else()
        set(LIBMEMORYSLOT_LIBRARIES ${LIBMS_INSTALL}/lib/libms_static.a)
    endif()

    ExternalProject_Add(libms
        PREFIX libms
        GIT_REPOSITORY ${LIBMS_URL}    
        BUILD_IN_SOURCE 1
        BUILD_BYPRODUCTS ${LIBMEMORYSLOT_LIBRARIES}
        DOWNLOAD_DIR "${DOWNLOAD_LOCATION}"
        CMAKE_CACHE_ARGS
            -DCMAKE_BUILD_TYPE:STRING=Release
            -DCMAKE_INSTALL_PREFIX:STRING=${LIBMS_INSTALL}
            -DROOT_BUILD_DIR:STRING=${ROOT_BUILD_DIR}
            -DCMAKE_C_FLAGS:STRING=-fPIC
    )
endif (LIBMS_SYSTEM)
