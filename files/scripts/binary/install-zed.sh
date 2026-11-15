#!/usr/bin/env bash

set -oue pipefail

# Install Zed

TEMP_DIR="$(mktemp -d)"

echo "Installing Zed (latest) from the upstream install script..."
cd "${TEMP_DIR}"

# Download the installation script

curl -fL "https://zed.dev/install.sh" | sh

# Clean up
cd -
rm -rf "${TEMP_DIR}"

echo "Zed installed successfully"