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

 if (LIBEI_SYSTEM)
    if (WIN32)
        set(LIBERRORINTERCEPTOR_INCLUDE_DIR "C:\\LibErrorInterceptor\\$ENV{name}\\include")
        set(LIBERRORINTERCEPTOR_LIBRARIES "C:\\LibErrorInterceptor\\$ENV{name}\\lib\\ei_static.lib")
    elseif (UNIX)
        find_library(LIBERRORINTERCEPTOR_LIBRARIES
            NAMES ei_static libei_static ei libei
            HINTS ${CMAKE_INSTALL_PREFIX}/lib)
        find_path(LIBERRORINTERCEPTOR_INCLUDE_DIR ei)
    endif ()
else (LIBEI_SYSTEM)
    include (ExternalProject)

    set(LIBEI_URL https://github.com/swasun/LibErrorInterceptor.git)
    set(LIBERRORINTERCEPTOR_INCLUDE_DIR ${LIBEI_INSTALL}/external/libei_archive)
    set(LIBEI_BUILD ${ROOT_BUILD_DIR}/libei/src/libei)

    if (WIN32)
        set(LIBERRORINTERCEPTOR_LIBRARIES "${LIBEI_INSTALL}\\lib\\ei_static.lib")
    else()
        set(LIBERRORINTERCEPTOR_LIBRARIES ${LIBEI_INSTALL}/lib/libei_static.a)
    endif()

    ExternalProject_Add(libei
        PREFIX libei
        GIT_REPOSITORY ${LIBEI_URL}
        BUILD_IN_SOURCE 1
        BUILD_BYPRODUCTS ${LIBERRORINTERCEPTOR_LIBRARIES}
        DOWNLOAD_DIR "${DOWNLOAD_LOCATION}"
        CMAKE_CACHE_ARGS
            -DCMAKE_BUILD_TYPE:STRING=Release
            -DCMAKE_INSTALL_PREFIX:STRING=${LIBEI_INSTALL}
            -DCMAKE_C_FLAGS:STRING=-fPIC
    )
endif (LIBEI_SYSTEM)
