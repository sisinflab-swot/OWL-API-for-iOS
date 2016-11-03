#!/bin/bash

# Configuration

PROJECT_NAME='OWLAPI'
OUTPUT_DIR='docs'

# Set exit on error
set -o pipefail
set -o errtrace
set -o nounset
set -o errexit

# Ensure prerequisites are met

XCODE_PROJECT="${PROJECT_NAME}.xcodeproj"

if [ 'x' == "$(which jazzy)x" ]; then
    echo "jazzy is required in order to generate the documentation of ${PROJECT_NAME}."
    exit 1
fi

if [ ! -d "${XCODE_PROJECT}" ]; then
    echo "This script must be run from the directory containing the ${PROJECT_NAME} Xcode project."
    exit 1
fi

# Grab configuration from Xcode project and Info.plist

function getXcodeSetting {
    echo "${XCODE_OUTPUT}" | grep "${1}" | awk -F'( = )' '{print $2}'
}

function getPlistSetting {
    echo "$(/usr/libexec/PlistBuddy -c "Print :${1}" "${INFO_PLIST}")"
}

XCODE_OUTPUT="$( xcodebuild -project "${XCODE_PROJECT}" -showBuildSettings )"
INFO_PLIST=$(getXcodeSetting PRODUCT_SETTINGS_PATH)

AUTHOR="$(getPlistSetting Author)"
AUTHOR_URL="$(getPlistSetting AuthorURL)"
SOURCE_URL="$(getPlistSetting SourceURL)"
UMBRELLA="${PROJECT_NAME}/${PROJECT_NAME}.h"
VERSION="$(getPlistSetting CFBundleShortVersionString)"

# Delete old docs
rm -rf "./${OUTPUT_DIR}"

# Compile docs
jazzy \
    --objc \
    --clean \
    --author "${AUTHOR}" \
    --author_url "${AUTHOR_URL}" \
    --github_url "${SOURCE_URL}" \
    --module-version "${VERSION}" \
    --umbrella-header "${UMBRELLA}" \
    --framework-root "${PROJECT_NAME}" \
    --module "${PROJECT_NAME}" \
    --output "${OUTPUT_DIR}"

exit 0
