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
#include <ueum/ueum.h>
#include <ei/ei.h>
#include <uecm/uecm.h>

#include <stdlib.h>
#include <time.h>

int main(int argc, char **argv) {
    mp_memory_plugin *plugin;
    mp_entry *entry;
    int plugin_id;
    uecm_crypto_metadata *plugin_crypto_metadata;

    if (argc != 3) {
        fprintf(stderr, "Usage: %s <plugin_source_path> <target_path>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    ei_init_or_die();
    ei_logger_use_symbol_levels();

    ei_logger_info("Initializing LibUnknownEchoCryptoModule...");
    if (!uecm_init()) {
        ei_stacktrace_push_msg("Failed to initialize LibUnknownEchoCryptoModule");
        goto clean_up;
    }
    ei_logger_info("LibUnknownEchoCryptoModule is correctly initialized.");

    plugin = NULL;
    entry = NULL;
    crypto_metadata = NULL;

    if (!ueum_is_file_exists(argv[1])) {
        ei_stacktrace_push_msg("Specified plugin source file '%s' doesn't exist", argv[1]);
        goto clean_up;
    }

    if (!ueum_is_file_exists(argv[2])) {
        ei_stacktrace_push_msg("Specified plugin target file '%s' doesn't exist", argv[2]);
        goto clean_up;
    }

    srand((unsigned int)time(0));

    entry = mp_entry_create();
    mp_entry_add_file(entry, argv[1]);

    if ((plugin_crypto_metadata = uecm_crypto_metadata_create_default()) == NULL) {
        ei_stacktrace_push_msg("Failed to create random crypto metadata");
        goto clean_up;
    }
    if (!uecm_crypto_metadata_write(plugin_crypto_metadata, "metadata", "uid", "password")) {
        ei_stacktrace_push_msg("Failed to write crypto metadata");
        goto clean_up;
    }

    /* Create new plugin from buffer */
    ei_logger_info("Creating new plugin from file...");
    if ((plugin = mp_memory_plugin_create_new(entry)) == NULL) {
        ei_stacktrace_push_msg("Failed to create new plugin");
        goto clean_up;
    }
    ei_logger_info("New plugin created");

    /**
    * Save the plugin into the target path (exec or shared object). It returned the
    * corresponding id of the created plugin.
    */
    ei_logger_info("Saving plugin to target file...");
    if ((plugin_id = mp_memory_plugin_save(plugin, argv[2], crypto_metadata)) == -1) {
        ei_stacktrace_push_msg("Failed to save new plugin to %s", argv[2]);
        goto clean_up;
    }

    ei_logger_info("Succeed to save new plugin with id %d", plugin_id);

clean_up:
    mp_entry_destroy(entry);
    /* Destroy only the object content and not the saved plugin */
    mp_memory_plugin_destroy(plugin);
    uecm_crypto_metadata_destroy(crypto_metadata);
    uecm_uninit();
    if (ei_stacktrace_is_filled()) {
        ei_logger_error("Error(s) occurred with the following stacktrace(s):");
        ei_stacktrace_print_all();
    }
    ei_uninit();
    return EXIT_SUCCESS;
}
