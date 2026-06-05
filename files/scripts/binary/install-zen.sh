#!/usr/bin/env bash

set -oue pipefail

# Install Zen

ZEN_VERSION="1.20.2b"
TEMP_DIR="$(mktemp -d)"

echo "Installing Zen ${ZEN_VERSION} from prebuilt binary..."

cd "${TEMP_DIR}"

# Download the prebuilt binary for x86_64 Linux
curl -L "https://github.com/zen-browser/desktop/releases/download/${ZEN_VERSION}/zen.linux-x86_64.tar.xz" -o zen.tar.xz

# Extract the binary
tar -xf zen.tar.xz

# Copy the zen folder to /opt
cp -r zen /opt/zen

# Create a symbolic link to the zen binary in /usr/bin
ln -s /opt/zen/zen /usr/bin/zen

# Clean up
cd -
rm -rf "${TEMP_DIR}"