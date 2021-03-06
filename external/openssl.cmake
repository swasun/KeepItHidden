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

if (OPENSSL_SYSTEM)
    if (WIN32)
        set(OPENSSL_INCLUDE_DIR "C:\\OpenSSL-Win64\\include")
        set(OPENSSL_LIBRARIES
            "C:\\OpenSSL-Win64\\lib\\libssl.lib"
            "C:\\OpenSSL-Win64\\lib\\libcrypto.lib"
    )
    elseif (UNIX)
        set(OPENSSL_INCLUDE_DIR "lib/openssl/include")
        set(OPENSSL_LIBRARIES
            "${CMAKE_CURRENT_SOURCE_DIR}/lib/openssl/lib/libssl.a"
            "${CMAKE_CURRENT_SOURCE_DIR}/lib/openssl/lib/libcrypto.a"
        )
    endif ()
else (OPENSSL_SYSTEM)
    include (ExternalProject)

    if (UNIX)
        ExternalProject_Add(openssl
        PREFIX openssl
        URL http://www.openssl.org/source/openssl-1.1.0h.tar.gz
        CONFIGURE_COMMAND ./config no-crypto-mdebug no-shared
            no-crypto-mdebug-backtrace no-unit-test no-weak-ssl-ciphers
            no-zlib no-zlib-dynamic no-idea no-mdc2 no-rc5 --prefix=${ROOT_BUILD_DIR}
        BUILD_COMMAND make depend && make
        INSTALL_COMMAND make install_sw
        BUILD_IN_SOURCE 1
        DOWNLOAD_DIR "${DOWNLOAD_LOCATION}"
    )
    else ()
        ExternalProject_Add(openssl
        PREFIX openssl
        URL http://www.openssl.org/source/openssl-1.1.0h.tar.gz
        CONFIGURE_COMMAND perl Configure VC-WIN64A no-crypto-mdebug no-shared # Fix for x86 with VC-WIN32
            no-crypto-mdebug-backtrace no-unit-test no-weak-ssl-ciphers
            no-zlib no-zlib-dynamic no-idea no-mdc2 no-rc5 "--prefix=${ROOT_BUILD_DIR}"
        #BUILD_COMMAND "ms\\do_win64a.bat"
        #COMMAND nmake -f "ms\\ntdll.mak"
        BUILD_COMMAND nmake
        INSTALL_COMMAND nmake install
        BUILD_IN_SOURCE 1
        #INSTALL_COMMAND nmake -f "ms\\ntdll.mak" install
        DOWNLOAD_DIR "${DOWNLOAD_LOCATION}"
    )
    endif ()

    set(OPENSSL_INCLUDE_DIR ${ROOT_BUILD_DIR}/openssl/src/openssl/)

    if (UNIX)
        set(OPENSSL_LIBRARIES
            ${ROOT_BUILD_DIR}/openssl/src/openssl/libssl.a
            ${ROOT_BUILD_DIR}/openssl/src/openssl/libcrypto.a
    )
    else ()
        set(OPENSSL_LIBRARIES
            ${ROOT_BUILD_DIR}/openssl/src/openssl/libssl.lib
            ${ROOT_BUILD_DIR}/openssl/src/openssl/libcrypto.lib
    )
    endif ()
endif (OPENSSL_SYSTEM)
