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

###############################################################################
 # Copyright (C) 2018 Charly Lamothe                                           #
 #                                                                             #
 # This file is part of KeepItHidden.                                          #
 #                                                                             #
 #   Licensed under the Apache License, Version 2.0 (the "License");           #
 #   you may not use this file except in compliance with the License.          #
 #   You may obtain a copy of the License at                                   #
 #                                                                             #
 #   http://www.apache.org/licenses/LICENSE-2.0                                #
 #                                                                             #
 #   Unless required by applicable law or agreed to in writing, software       #
 #   distributed under the License is distributed on an "AS IS" BASIS,         #
 #   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  #
 #   See the License for the specific language governing permissions and       #
 #   limitations under the License.                                            #
 ###############################################################################

if (ZLIB_SYSTEM)
    if (WIN32)
        set(ZLIB_INCLUDE_DIR "C:\\zlib\\$ENV{name}\\include")
        set(ZLIB_LIBRARIES "C:\\zlib\\$ENV{name}\\lib\\zlibstatic.lib")
    else ()
        find_package(PkgConfig)
        pkg_search_module(ZLIB REQUIRED zlib)
        set(ZLIB_INCLUDE_DIR ${ZLIB_INCLUDE_DIRS})
        set(ADD_LINK_DIRECTORY ${ADD_LINK_DIRECTORY} ${ZLIB_LIBRARY_DIRS})
        set(ADD_CFLAGS ${ADD_CFLAGS} ${ZLIB_CFLAGS_OTHER})
        # To meet DEPENDS zlib from other projects.
        # If we hit this line, zlib is already built and installed to the system.
        add_custom_target(zlib)
    endif ()
else (ZLIB_SYSTEM)
    include (ExternalProject)

    set(ZLIB_INCLUDE_DIR ${ROOT_BUILD_DIR}/zlib/install/include)
    set(ZLIB_URL https://github.com/madler/zlib)
    set(ZLIB_BUILD ${ROOT_BUILD_DIR}/zlib/src/zlib)
    set(ZLIB_INSTALL ${ROOT_BUILD_DIR}/zlib/install)
    set(ZLIB_TAG v1.2.11)

    if (WIN32)
        if (${CMAKE_GENERATOR} MATCHES "Visual Studio.*")
            set(ZLIB_LIBRARIES
                debug ${ROOT_BUILD_DIR}/zlib/install/lib/zlibstaticd.a
                optimized ${ROOT_BUILD_DIR}/zlib/install/lib/libzlibstatic.a)
        else ()
            if (CMAKE_BUILD_TYPE EQUAL Debug)
                set(ZLIB_LIBRARIES
                    ${ROOT_BUILD_DIR}/zlib/install/lib/zlibstaticd.a)
            else ()
                set(ZLIB_LIBRARIES
                    ${ROOT_BUILD_DIR}/zlib/install/lib/libzlibstatic.a)
            endif ()
        endif ()
    else ()
        set(ZLIB_LIBRARIES
        ${ROOT_BUILD_DIR}/zlib/install/lib/libz.a)
    endif ()

    ExternalProject_Add(zlib
        PREFIX zlib
        GIT_REPOSITORY ${ZLIB_URL}
        GIT_TAG ${ZLIB_TAG}
        INSTALL_DIR ${ZLIB_INSTALL}
        BUILD_IN_SOURCE 1
        BUILD_BYPRODUCTS ${ZLIB_LIBRARIES}
        DOWNLOAD_DIR "${DOWNLOAD_LOCATION}"
        CMAKE_CACHE_ARGS
            -DCMAKE_BUILD_TYPE:STRING=Release
            -DCMAKE_INSTALL_PREFIX:STRING=${ZLIB_INSTALL}
            -DCMAKE_C_FLAGS:STRING=-fPIC
    )
endif (ZLIB_SYSTEM)
