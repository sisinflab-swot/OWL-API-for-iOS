#!/usr/bin/env bash

# Configuration

CMAKE_DIR="$(dirname "${0}")/../lib/cowl"
CMAKE_TARGET="cowl-static"
LIB_NAME="libcowl.a"

MACOS_ARCHS="x86_64;arm64;arm64e"
MACOS_BUILD_DIR="cmake-build-macos"
MACOS_DEPLOYMENT_TARGET="10.11"

IOS_ARCHS="armv7;armv7s;arm64;arm64e"
IOS_SIM_ARCHS="x86_64"
IOS_BUILD_DIR="cmake-build-ios"
IOS_SIM_BUILD_DIR="cmake-build-ios-sim"
IOS_DEPLOYMENT_TARGET="9.0"

ACTION="${1:-build}"
CONFIG="${CONFIGURATION:-Release}"
OUT_DIR="cmake-build-all"
IOS_OUT_DIR="${OUT_DIR}/ios"
MACOS_OUT_DIR="${OUT_DIR}/macos"
HEADERS_OUT_DIR="${OUT_DIR}/include"

# Build steps

function cmake {
    # Running CMake in a separate environment avoids issues due to env vars set by Xcode.
    command env -i PATH="/usr/local/opt/flex/bin:/usr/local/opt/bison/bin:${PATH}" cmake "${@}"
}

function clean_temp {
    rm -rf "${MACOS_BUILD_DIR}" "${IOS_BUILD_DIR}" "${IOS_SIM_BUILD_DIR}"
}

function clean {
    clean_temp
    rm -rf "${OUT_DIR}"
}

function copy_headers {
    mv "${IOS_BUILD_DIR}/include" "${HEADERS_OUT_DIR}"
}

function build_macos {
    cmake -B "${MACOS_BUILD_DIR}" \
        -DCMAKE_OSX_ARCHITECTURES="${MACOS_ARCHS}" \
        -DCMAKE_OSX_DEPLOYMENT_TARGET="${MACOS_DEPLOYMENT_TARGET}"

    cmake --build "${MACOS_BUILD_DIR}" --target "${CMAKE_TARGET}" --config "${CONFIG}" --parallel

    mkdir -p "${MACOS_OUT_DIR}"
    mv "${MACOS_BUILD_DIR}/${LIB_NAME}" "${MACOS_OUT_DIR}"
}

function build_ios {
    # Native library
    cmake -B "${IOS_BUILD_DIR}" \
        -DCMAKE_SYSTEM_NAME=iOS \
        -DCMAKE_OSX_SYSROOT=iphoneos \
        -DCMAKE_OSX_DEPLOYMENT_TARGET="${IOS_DEPLOYMENT_TARGET}" \
        -DCMAKE_OSX_ARCHITECTURES="${IOS_ARCHS}" \
        -DCMAKE_C_FLAGS='-fembed-bitcode'

    cmake --build "${IOS_BUILD_DIR}" --target "${CMAKE_TARGET}" --config "${CONFIG}" --parallel

    # Simulator library
    cmake -B "${IOS_SIM_BUILD_DIR}" \
        -DCMAKE_SYSTEM_NAME=iOS \
        -DCMAKE_OSX_SYSROOT=iphonesimulator \
        -DCMAKE_OSX_DEPLOYMENT_TARGET="${IOS_DEPLOYMENT_TARGET}" \
        -DCMAKE_OSX_ARCHITECTURES="${IOS_SIM_ARCHS}" \
        -DCMAKE_C_FLAGS='-fembed-bitcode'

    cmake --build "${IOS_SIM_BUILD_DIR}" --target "${CMAKE_TARGET}" --config "${CONFIG}" --parallel

    # Merge native and simulator libraries.
    mkdir -p "${IOS_OUT_DIR}"
    lipo -create "${IOS_BUILD_DIR}/${LIB_NAME}" "${IOS_SIM_BUILD_DIR}/${LIB_NAME}" \
         -output "${IOS_OUT_DIR}/${LIB_NAME}"
}

# Safeguards

set -o pipefail
set -o errtrace
set -o nounset
set -o errexit

# Start build

cd "${CMAKE_DIR}"

if [ "${ACTION}" = "clean" ]; then
    clean
    exit 0
fi

COMMIT_SHA="$(git rev-parse --short HEAD)"
CONFIG_FLAG="${OUT_DIR}/${COMMIT_SHA}_${CONFIG}"

if [ ! -f  "${CONFIG_FLAG}" ]; then
    clean
    build_macos
    build_ios
    copy_headers
    clean_temp
    touch "${CONFIG_FLAG}"
fi

exit 0
