#!/usr/bin/env bash

set -oue pipefail

# Install SSHM
SSHM_VERSION="2.0.1"
TEMP_DIR="$(mktemp -d)"

echo "Installing SSHM ${SSHM_VERSION} from prebuilt binary..."

cd "${TEMP_DIR}"

# Download the prebuilt binary for x86_64 Linux
curl -L "https://github.com/Sn0wAlice/sshm/releases/download/v${SSHM_VERSION}/sshm-linux-amd64.tar.gz" -o sshm.tar.gz

# Extract the binary
tar -xzf sshm.tar.gz

# Install the binary to /usr/bin
mkdir -p /usr/bin
install -m 755 sshm /usr/bin/sshm

# Download the GUI package  for x86_64 Linux
curl -L "https://github.com/Sn0wAlice/sshm/releases/download/v${SSHM_VERSION}/sshm-${SSHM_VERSION}-1.x86_64.rpm" -o sshm-gui.rpm

# Install the GUI package using rpm
dnf install -y sshm-gui.rpm

# Clean up
cd -
rm -rf "${TEMP_DIR}"

echo "SSHM installed successfully at /usr/bin/sshm"