#!/bin/bash

# Set exit on error
set -o pipefail
set -o errtrace
set -o nounset
set -o errexit

# Check for pkg-config and brew, if needed and possible
if [ 'x' == $(which pkg-config)'x' ]; then
    echo "pkg-config is required in order to compile librdf."
	if [ 'x' == $(which brew)'x' ]; then
		echo "Attempted to install pkg-config via Homebrew, but it is not installed. Please install pkg-config or Homebrew."
		exit 1
	fi
	
	echo "Installing pkg-config"
	brew install pkg-config
fi

# Cross compile
python cross-compile.py

exit 0
