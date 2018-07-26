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
