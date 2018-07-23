 ##########################################################################################
 # Copyright (C) 2018 by Charly Lamothe                                                   #
 #                                                                                        #
 # This file is part of KeepItHidden.                                                     #
 #                                                                                        #
 #   KeepItHidden is free software: you can redistribute it and/or modify                 #
 #   it under the termp of the GNU General Public License as published by                 #
 #   the Free Software Foundation, either version 3 of the License, or                    #
 #   (at your option) any later version.                                                  #
 #                                                                                        #
 #   KeepItHidden is distributed in the hope that it will be useful,                      #
 #   but WITHOUT ANY WARRANTY; without even the implied warranty of                       #
 #   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                        #
 #   GNU General Public License for more details.                                         #
 #                                                                                        #
 #   You should have received a copy of the GNU General Public License                    #
 #   along with KeepItHidden.  If not, see <http://www.gnu.org/licenses/>.                #
 ##########################################################################################

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
