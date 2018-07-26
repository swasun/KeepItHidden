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

#include <mp/mp.h>
#include <ei/ei.h>
#include <uecm/uecm.h>
#include <ueum/ueum.h>

#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>

#define ALGORITHM_PLUGIN_ID 100
#define CONSTANT_PLUGIN_ID 101

static void print_usage(const char *program_name) {
    fprintf(stdout, "Usage: %s <crypto_metadata_directory> <crypto_metadata_uid> <crypto_metadata_password>", program_name);
}

int main(int argc, char **argv) {
    mp_memory_plugin *algorithm_plugin, *constant_plugin;
    typedef (unsigned char *)(*algorithm_func)(double, size_t *);
    typedef (double)(*get_constant_func)();
    algorithm_func algorithm;
    get_constant_func get_constant;
    uecm_crypto_metadata *plugin_crypto_metadata;
    unsigned char *result;
    size_t result_size;

    if (argc != 4) {
        fprintf(stderr, "[FATAL] Invalid arguments number");
        print_usage(argv[0]);
        exit(EXIT_FAILURE);
    }

    ei_init_or_die();
    ei_logger_use_symbol_levels();

    algorithm_plugin = NULL;
    constant_plugin = NULL;
    plugin_crypto_metadata = NULL;
    result = NULL;
    result_size = 0;

    ei_logger_info("Initializing LibUnknownEchoCryptoModule...");
    if (!uecm_init()) {
        ei_stacktrace_push_msg("Failed to initialize LibUnknownEchoCryptoModule");
        goto clean_up;
    }
    ei_logger_info("LibUnknownEchoCryptoModule is correctly initialized.");

    if ((plugin_crypto_metadata = uecm_crypto_metadata_create_empty()) == NULL) {
        ei_stacktrace_push_msg("Failed to create empty crypto metadata object");
        goto clean_up;
    }

    if (!uecm_crypto_metadata_read(plugin_crypto_metadata,
        argv[1], argv[2], argv[3])) {

        ei_stacktrace_push_msg("Failed to read crypto metadata");
        goto clean_up;
    }

    /* Load algorithm_plugin from id */
    ei_logger_info("Loading algorithm plugin from id %d...", ALGORITHM_PLUGIN_ID);
    if ((plugin = mp_memory_plugin_load(ALGORITHM_PLUGIN_ID, plugin_crypto_metadata)) == NULL) {
        ei_stacktrace_push_msg("Failed to load plugin with id %d", ALGORITHM_PLUGIN_ID);
        goto clean_up;
    }
    ei_logger_info("Memory plugin loaded");

    ei_logger_info("Getting function algorithm() from loaded memory plugin...");
UEUM_DISABLE_WIN32_PRAGMA_WARN(4152)
    if ((algorithm = mp_memory_plugin_get_function(plugin, "algorithm")) == NULL) {
UEUM_DISABLE_WIN32_PRAGMA_WARN_END()
        ei_stacktrace_push_msg("Failed to get algorithm function from loaded plugin of id", ALGORITHM_PLUGIN_ID);
        goto clean_up;
    }
    ei_logger_info("algorithm function retrieved");

    /* Load constant_plugin from id */
    ei_logger_info("Loading constant plugin from id %d...", CONSTANT_PLUGIN_ID);
    if ((plugin = mp_memory_plugin_load(CONSTANT_PLUGIN_ID, plugin_crypto_metadata)) == NULL) {
        ei_stacktrace_push_msg("Failed to load plugin with id %d", CONSTANT_PLUGIN_ID);
        goto clean_up;
    }
    ei_logger_info("Memory plugin loaded");

    ei_logger_info("Getting function get_constant() from loaded memory plugin...");
UEUM_DISABLE_WIN32_PRAGMA_WARN(4152)
    if ((get_constant = mp_memory_plugin_get_function(plugin, "get_constant")) == NULL) {
UEUM_DISABLE_WIN32_PRAGMA_WARN_END()
        ei_stacktrace_push_msg("Failed to get get_constant function from loaded plugin of id", CONSTANT_PLUGIN_ID);
        goto clean_up;
    }
    ei_logger_info("get_constant function retrieved");

    ei_logger_info("Executing algorithm with constant...");

    if ((result = algorithm(get_constant(), &result_size)) == NULL) {
        ei_stacktrace_push_msg("Failed to get the result of the algorithm");
        goto clean_up;
    }

    ei_logger_info("The execution of the algorithm succeed ! Printing the result in hex string...");

    ueum_hex_print(result, result_size, stdout);

clean_up:
    mp_memory_plugin_unload(algorithm_plugin);
    mp_memory_plugin_unload(constant_plugin);
    uecm_crypto_metadata_destroy(plugin_crypto_metadata);
    ueum_safe_free(result);
    if (ei_stacktrace_is_filled()) {
        ei_logger_error("Error(s) occurred with the following stacktrace(s):");
        ei_stacktrace_print_all();
    }
    uecm_uninit();
    ei_uninit();
    return 0;
}
