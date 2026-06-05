#!/usr/bin/env bash

set -oue pipefail

# Install rmux from prebuilt binary

RMUX_VERSION="v0.5.0"
TEMP_DIR=$(mktemp -d)

echo "Installing rmux ${RMUX_VERSION} from prebuilt binary..."

cd "${TEMP_DIR}"

# Download the prebuilt binary for x86_64 Linux
curl -L "https://github.com/Helvesec/rmux/releases/download/${RMUX_VERSION}/rmux-${RMUX_VERSION}-x86_64-unknown-linux-gnu.tar.gz" -o rmux.tar.gz

# Extract the binary
tar -xzf rmux.tar.gz

# Install the binary to /usr/bin
mkdir -p /usr/bin
install -m 755 rmux-${RMUX_VERSION}-x86_64-unknown-linux-gnu/rmux /usr/bin/rmux

# Clean up
cd -
rm -rf "${TEMP_DIR}"

echo "rmux installed successfully at /usr/bin/rmux"