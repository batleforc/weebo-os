#!/usr/bin/env bash

set -oue pipefail

# Install JetBrains Toolbox

JETBRAINS_TOOLBOX_VERSION="3.6.1.85592"
TEMP_DIR=$(mktemp -d)

echo "Installing JetBrains Toolbox ${JETBRAINS_TOOLBOX_VERSION} from prebuilt binary..."

cd "${TEMP_DIR}"

# Download the prebuilt binary for x86_64 Linux
curl -L "https://download-cdn.jetbrains.com/toolbox/jetbrains-toolbox-${JETBRAINS_TOOLBOX_VERSION}.tar.gz" -o jetbrains-toolbox.tar.gz

# Extract the binary
tar -xzf jetbrains-toolbox.tar.gz

# Install the binary in a subdirectory of /opt
mkdir -p /opt/jetbrains-toolbox
cp -r jetbrains-toolbox-*/* /opt/jetbrains-toolbox/

# Create a symbolic link to the binary in /usr/bin
ln -s /opt/jetbrains-toolbox/bin/jetbrains-toolbox /usr/bin/

# Clean up
cd -
rm -rf "${TEMP_DIR}"

echo "JetBrains Toolbox installed successfully at /opt/jetbrains-toolbox and symlinked to /usr/bin/jetbrains-toolbox"