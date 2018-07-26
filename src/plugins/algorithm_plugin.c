/*************************************************************************************
 * MIT License                                                                       *
 *                                                                                   *
 * Copyright (C) 2018 Charly Lamothe                                                 *
 *                                                                                   *
 * This file is part of KeepItHidden.                                                *
 *                                                                                   *
 *   Permission is hereby granted, free of charge, to any person obtaining a copy    *
 *   of this software and associated documentation files (the "Software"), to deal   *
 *   in the Software without restriction, including without limitation the rights    *
 *   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell       *
 *   copies of the Software, and to permit persons to whom the Software is           *
 *   furnished to do so, subject to the following conditions:                        *
 *                                                                                   *
 *   The above copyright notice and this permission notice shall be included in all  *
 *   copies or substantial portions of the Software.                                 *
 *                                                                                   *
 *   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR      *
 *   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,        *
 *   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE     *
 *   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER          *
 *   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,   *
 *   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE   *
 *   SOFTWARE.                                                                       *
 *************************************************************************************/

#include <ei/ei.h>
#include <uecm/uecm.h>
#include <ueum/ueum.h>

#include <stddef.h>

int constructor() {
    return ei_init() && uecm_init();
}

int destructor() {
    ei_uninit();
    uecm_uninit();
    return 1;
}

#if defined(__unix__)

int __attribute__ ((constructor)) constructor(void);
int __attribute__ ((destructor)) destructor(void);

#elif defined(_WIN32)

#include <Windows.h>

BOOL WINAPI DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved) {
    if (fdwReason == DLL_PROCESS_ATTACH) {
        return constructor();
    }
    else if (fdwReason == DLL_PROCESS_DETACH) {
        return destructor();
    }

    return TRUE;
}

#endif

unsigned char *algorithm(int constant, size_t *result_size) {
    uecm_hasher *hasher;
    unsigned char *data, *digest;
    size_t data_size, digest_len;

    hasher = uecm_hasher_sha256_create();

    ueum_safe_alloc(data, unsigned char, 4);

    ueum_int_to_bytes(constant, data);

    digest = uecm_hasher_digest(hasher, data, data_size, &digest_len);

    *result_size = digest_len;

    ueum_safe_free(data);
    uecm_hasher_destroy(hasher);

    return digest;
}
