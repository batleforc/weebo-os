#!/usr/bin/env bash

set -oue pipefail

# Install eza from prebuilt binary
# Since eza is no longer available in dnf repositories

EZA_VERSION="v0.23.4"
TEMP_DIR=$(mktemp -d)

echo "Installing eza ${EZA_VERSION} from prebuilt binary..."

cd "${TEMP_DIR}"

# Download the prebuilt binary for x86_64 Linux
curl -L "https://github.com/eza-community/eza/releases/download/${EZA_VERSION}/eza_x86_64-unknown-linux-gnu.tar.gz" -o eza.tar.gz

# Extract the binary
tar -xzf eza.tar.gz

# Install the binary to /usr/bin
mkdir -p /usr/bin
install -m 755 eza /usr/bin/eza

# Clean up
cd -
rm -rf "${TEMP_DIR}"

echo "eza installed successfully at /usr/bin/eza"
