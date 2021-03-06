# Bootstrap support for building required dependencies automatically

cmake_minimum_required(VERSION 2.8.11)

if(POLICY CMP0020)
    cmake_policy(SET CMP0020 NEW)
endif()

set(CMAKE_BUILD_TYPE Release)
# Create PORTS_PREFIX variable with spaces escaped
string(REGEX REPLACE " " "\ " PORTS_PREFIX "${CMAKE_CURRENT_BINARY_DIR}")
set(PORTS_SCRIPTS "${CMAKE_CURRENT_SOURCE_DIR}")
set(ENV{MACOSX_DEPLOYMENT_TARGET} "10.10")

set(SCRYPT_LIBDIR "${PORTS_PREFIX}/lib/")

include(ExternalProject)

if(WIN32)
    message("wickr-scrypt.cmake: Building for WINDOWS")
    ExternalProject_add(wickr-scrypt
        PREFIX "${PORTS_PREFIX}"
        GIT_REPOSITORY    https://github.com/technion/libscrypt.git
        GIT_TAG           master
        CONFIGURE_COMMAND ""
        BUILD_COMMAND     make && make check
        INSTALL_COMMAND   make install-static DESTDIR=${PORTS_PREFIX}/ LIBDIR=lib
        BUILD_IN_SOURCE   1
    )

elseif(APPLE)
    message("wickr-scrypt.cmake: Building for APPLE")
    ExternalProject_add(wickr-scrypt
        PREFIX "${PORTS_PREFIX}"
        GIT_REPOSITORY    https://github.com/technion/libscrypt.git
        GIT_TAG           master
        CONFIGURE_COMMAND ""
        BUILD_COMMAND     make CC=${PORTS_SCRIPTS}/mac-clang.sh LDFLAGS= CFLAGS_EXTRA=
        INSTALL_COMMAND   mkdir -p ${SCRYPT_LIBDIR} && make install-static DESTDIR=${PORTS_PREFIX}/ LIBDIR=lib
        BUILD_IN_SOURCE   1
    )

elseif (ANDROID)
    message("wickr-scrypt.cmake: Building for ANDROID")
    ExternalProject_add(wickr-scrypt
        PREFIX "${PORTS_PREFIX}"
        GIT_REPOSITORY    https://github.com/technion/libscrypt.git
        GIT_TAG           master
        CONFIGURE_COMMAND ""
        BUILD_COMMAND     "${PORTS_SCRIPTS}/setenv-android.sh" make LDFLAGS= CFLAGS_EXTRA=
        INSTALL_COMMAND   "${PORTS_SCRIPTS}/setenv-android.sh" mkdir -p ${SCRYPT_LIBDIR} && "${PORTS_SCRIPTS}/setenv-android.sh" make install-static DESTDIR=${PORTS_PREFIX}/ LIBDIR=lib
        BUILD_IN_SOURCE   1
    )

elseif (UNIX)
    message("wickr-scrypt.cmake: Building for UNIX")
    ExternalProject_add(wickr-scrypt
        PREFIX "${PORTS_PREFIX}"
        GIT_REPOSITORY    https://github.com/technion/libscrypt.git
        GIT_TAG           master
        CONFIGURE_COMMAND ""
        BUILD_COMMAND     make && make check
        INSTALL_COMMAND   make install-static DESTDIR=${PORTS_PREFIX}/ LIBDIR=lib
        BUILD_IN_SOURCE   1
    )
else()
    message("wickr-bcrypt.cmake: Do not know OS!")
endif()

INSTALL(FILES "${CMAKE_CURRENT_BINARY_DIR}/lib/libscrypt.a" DESTINATION lib)
INSTALL(FILES "${CMAKE_CURRENT_BINARY_DIR}/src/wickr-scrypt/libscrypt.h" DESTINATION include/scrypt)
INSTALL(FILES "${CMAKE_CURRENT_BINARY_DIR}/src/wickr-scrypt/b64.h" DESTINATION include/scrypt)
INSTALL(FILES "${CMAKE_CURRENT_BINARY_DIR}/src/wickr-scrypt/crypto_scrypt-hexconvert.h" DESTINATION include/scrypt)
