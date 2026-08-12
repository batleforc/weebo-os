#!/usr/bin/env bash

set -oue pipefail

# Install Framework tool

FW_SYSTEM_VERSION="0.6.5"
FW_CONTROL_VERSION="0.5.3"
TEMP_DIR="$(mktemp -d)"

echo "Installing Framework system ${FW_SYSTEM_VERSION} from prebuilt binary..."
curl -L "https://github.com/FrameworkComputer/framework-system/releases/download/v${FW_SYSTEM_VERSION}/framework_tool" -o framework_tool

echo "Installing Framework control ${FW_CONTROL_VERSION} from prebuilt binary..."
curl -L "https://github.com/ozturkkl/framework-control/releases/download/${FW_CONTROL_VERSION}/framework-control-service-x86_64.tar.gz" -o framework_control.tar.gz

# Extract the control binary
tar -xzf framework_control.tar.gz

# Install the binaries to /usr/bin
mkdir -p /usr/bin
install -m 755 framework_tool /usr/bin/framework_tool
install -m 755 framework-control /usr/local/bin/
install -m 644 framework-control.service /etc/systemd/system/

# Clean up
cd -
rm -rf "${TEMP_DIR}"

echo "Framework system installed successfully at /usr/bin/framework_tool"