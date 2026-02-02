#!/usr/bin/env bash

set -oue pipefail

# Install CocoGitto

COCOGITTO_VERSION="6.5.0"
TEMP_DIR="$(mktemp -d)"

echo "Installing CocoGitto ${COCOGITTO_VERSION} from prebuilt binary..."

cd "${TEMP_DIR}"

# Download the prebuilt binary for x86_64 Linux
curl -L "https://github.com/cocogitto/cocogitto/releases/download/${COCOGITTO_VERSION}/cocogitto-${COCOGITTO_VERSION}-aarch64-unknown-linux-gnu.tar.gz" -o cocogitto.tar.gz

# Extract the binary
tar -xzf cocogitto.tar.gz

# Install the binary to /usr/bin
mkdir -p /usr/bin
install -m 755 cog /usr/bin/cog

# Clean up
cd -
rm -rf "${TEMP_DIR}"

echo "CocoGitto installed successfully at /usr/bin/cog"