## Description

A simple POC to demonstrate how to retreive a secret inside an executable using several indirections.

## Usage

```bash
cd bin
./initializer algorithm_plugin controller <crypto_metadata_directory> <crypto_metadata_uid> <crypto_metadata_password>
./initializer constant_plugin controller <crypto_metadata_directory> <crypto_metadata_uid> <crypto_metadata_password>
./controller <algorithm_plugin_id> <constant_plugin_id> <crypto_metadata_directory> <crypto_metadata_uid> <crypto_metadata_password>
```

## Dependencies
* [LibErrorInterceptor](https://github.com/swasun/LibErrorInterceptor), a lightweight and cross-plateform library to handle stacktrace and logging in C99.
* [LibUnknownEchoUtilsModule](https://github.com/swasun/LibUnknownEchoUtilsModule) Utils module of [LibUnknownEcho](https://github.com/swasun/LibUnknownEcho). Last version
* [LibUnknownEchoCryptoModule](https://github.com/swasun/LibUnknownEchoCryptoModule) Crypto module of [LibUnknownEcho](https://github.com/swasun/LibUnknownEcho). Last version.
* [Libssl](https://github.com/openssl/openssl) Provides the client and server-side implementations for SSLv3 and TLS. Version 1.1
* [Libcrypto](https://github.com/openssl/openssl) Provides general cryptographic and X.509 support needed by SSL/TLS but not logically part of it. Version 1.1.
* [Zlib](https://github.com/madler/zlib) A massively spiffy yet delicately unobtrusive compression library. Version 1.2.11.
* [LibMemorySlot](https://github.com/swasun/LibMemorySlot), a lightweight library to create, update and load slot (the Windows implementation is the Resource API).
* [LibSharedMemoryObject](https://github.com/swasun/LibSharedMemoryObject), a light and cross-plateform library that provides a simple API to load from memory shared library on both Linux (.so) and Windows (.dll).
* [LibMemoryPlugin](https://github.com/swasun/LibMemoryPlugin), a library that provides a simple API to create, load and update plugin from and to memory of a Windows executable.