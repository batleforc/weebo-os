#!/usr/bin/env bash

set -oue pipefail

# Install zmkbtx from prebuilt binary
ZMKBTX_VERSION="1.0.1"
TEMP_DIR=$(mktemp -d)

echo "Installing zmkbtx ${ZMKBTX_VERSION} from prebuilt binary..."

cd "${TEMP_DIR}"

# Download the prebuilt binary for x86_64 Linux
curl -L "https://github.com/mh4x0f/zmkBATx/releases/download/v${ZMKBTX_VERSION}/zmkBATx-${ZMKBTX_VERSION}-linux64.tar.xz" -o zmkbtx.tar.xz

# Extract the binary
tar -xf zmkbtx.tar.xz

# Install the binary to /usr/bin
mkdir -p /usr/bin
install -m 755 zmkBATx/zmkbatx /usr/bin/zmkbtx

# Clean up
cd -
rm -rf "${TEMP_DIR}"

echo "zmkbtx installed successfully at /usr/bin/zmkbtx"