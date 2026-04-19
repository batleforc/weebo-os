#!/usr/bin/env bash

set -oue pipefail

# Install Zed

ZED_VERSION="0.9.0"
TEMP_DIR="$(mktemp -d)"

echo "Installing Zed ${ZED_VERSION} from script ... "
cd "${TEMP_DIR}"

# Download the installation script

curl -L "https://zed.dev/install.sh" | sh

# Clean up
cd -
rm -rf "${TEMP_DIR}"

echo "Zed installed successfully"