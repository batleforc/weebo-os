#!/usr/bin/env bash

set -oue pipefail

# Install SSHM
SSHM_VERSION="2.1.2"
SSHM_REPO="Sn0wAlice/sshm"
TEMP_DIR="$(mktemp -d)"

echo "Installing SSHM ${SSHM_VERSION} from prebuilt binary..."

cd "${TEMP_DIR}"

# Download the prebuilt binary for x86_64 Linux
curl -fL "https://github.com/${SSHM_REPO}/releases/download/v${SSHM_VERSION}/sshm-linux-amd64.tar.gz" -o sshm.tar.gz

# Extract the binary
tar -xzf sshm.tar.gz

# Install the binary to /usr/bin
mkdir -p /usr/bin
install -m 755 sshm /usr/bin/sshm

# The GUI package is not always tagged with the release version upstream,
# so resolve the actual x86_64 rpm asset attached to the release
RPM_URL="$(curl -fsSL "https://api.github.com/repos/${SSHM_REPO}/releases/tags/v${SSHM_VERSION}" \
  | grep -o '"browser_download_url"[[:space:]]*:[[:space:]]*"[^"]*x86_64\.rpm"' \
  | head -n1 \
  | cut -d'"' -f4)" || RPM_URL=""

if [ -z "${RPM_URL}" ]; then
  RPM_URL="https://github.com/${SSHM_REPO}/releases/download/v${SSHM_VERSION}/sshm-${SSHM_VERSION}-1.x86_64.rpm"
fi

echo "Downloading SSHM GUI package from ${RPM_URL}"
curl -fL "${RPM_URL}" -o sshm-gui.rpm

# Install the GUI package using dnf
dnf install -y ./sshm-gui.rpm

# Clean up
cd -
rm -rf "${TEMP_DIR}"

echo "SSHM installed successfully at /usr/bin/sshm"
