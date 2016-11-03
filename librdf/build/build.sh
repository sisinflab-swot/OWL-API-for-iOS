#!/bin/bash

# Set exit on error
set -o pipefail
set -o errtrace
set -o nounset
set -o errexit

# Check for pkg-config and brew, if needed and possible
if [ 'x' == $(which pkg-config)'x' ]; then
    echo "pkg-config is required in order to compile librdf."
	exit 1
fi

# Cross compile
python cross-compile.py

exit 0
