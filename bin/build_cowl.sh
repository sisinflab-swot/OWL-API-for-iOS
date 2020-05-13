#!/usr/bin/env bash

# Configuration

MACOS_ARCHS="x86_64"
MACOS_BUILD_DIR="cmake-build-macos"

IOS_ARCHS="armv7;armv7s;arm64;arm64e;x86_64;i386"
IOS_BUILD_DIR="cmake-build-ios"

ACTION="${1:-build}"
CONFIG="${CONFIGURATION:-Release}"
OUT_DIR="cmake-build-all"
IOS_OUT_DIR="${OUT_DIR}/ios"
MACOS_OUT_DIR="${OUT_DIR}/macos"
HEADERS_OUT_DIR="${OUT_DIR}/include"

# Safeguards

set -o pipefail
set -o errtrace
set -o nounset
set -o errexit

function cmake {
    # Running CMake in a separate environment avoids issues due to env vars set by Xcode.
    command env -i PATH="/usr/local/opt/flex/bin:/usr/local/opt/bison/bin:${PATH}" cmake "${@}"
}

# Start build

cd "$(dirname "${0}")/../lib/cowl"

COMMIT_SHA="$(git rev-parse --short HEAD)"
CONFIG_FLAG="${OUT_DIR}/${COMMIT_SHA}_${CONFIG}"

if [ "${ACTION}" = "clean" ]; then
    rm -rf "${MACOS_BUILD_DIR}" "${IOS_BUILD_DIR}" "${OUT_DIR}"
    exit 0
fi

if [ ! -f  "${CONFIG_FLAG}" ]; then
    rm -rf "${MACOS_BUILD_DIR}" "${IOS_BUILD_DIR}" "${OUT_DIR}"

    # macOS library
    cmake -S . -B "${MACOS_BUILD_DIR}" -DCMAKE_OSX_ARCHITECTURES="${MACOS_ARCHS}"
    cmake --build "${MACOS_BUILD_DIR}" --target cowl-static --config "${CONFIG}" --parallel

    mkdir -p "${MACOS_OUT_DIR}"
    mv "${MACOS_BUILD_DIR}/libcowl.a" "${MACOS_OUT_DIR}"

    # iOS library
    cmake -S . -B "${IOS_BUILD_DIR}" \
        -DCMAKE_SYSTEM_NAME=iOS \
        -DCMAKE_OSX_ARCHITECTURES="${IOS_ARCHS}" \
        -DCMAKE_C_FLAGS='-fembed-bitcode'

    cmake --build "${IOS_BUILD_DIR}" --target cowl-static --config "${CONFIG}" --parallel

    mkdir -p "${IOS_OUT_DIR}"
    mv "${IOS_BUILD_DIR}/libcowl.a" "${IOS_OUT_DIR}"

    # Headers
    mv "${IOS_BUILD_DIR}/include" "${HEADERS_OUT_DIR}"

    # Done
    rm -rf "${MACOS_BUILD_DIR}" "${IOS_BUILD_DIR}"
    touch "${CONFIG_FLAG}"
fi

exit 0
