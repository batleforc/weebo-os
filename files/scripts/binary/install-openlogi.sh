#!/usr/bin/env bash

set -oue pipefail

# Install OpenLogi
OPENLOGI_VERSION="0.9.0"
OPENLOGI_REPO="AprilNEA/OpenLogi"
TEMP_DIR="$(mktemp -d)"

echo "Installing OpenLogi ${OPENLOGI_VERSION}..."

cd "${TEMP_DIR}"

curl -fL "https://github.com/${OPENLOGI_REPO}/releases/download/v${OPENLOGI_VERSION}/openlogi-v${OPENLOGI_VERSION}-linux-amd64.rpm" -o openlogi.rpm

# The rpm declares no dependencies, so its runtime libraries are pulled explicitly
dnf install -y libxcb libxkbcommon-x11

# The %post scriptlet runs `udevadm control` under `set -e`, which fails during
# an image build because udevd is not running. Udev rules are read at boot anyway.
rpm -i --noscripts openlogi.rpm

# Cache refreshes normally done by the skipped scriptlet
gtk-update-icon-cache -qtf /usr/share/icons/hicolor || true
update-desktop-database -q /usr/share/applications || true

# Clean up
cd -
rm -rf "${TEMP_DIR}"

echo "OpenLogi installed successfully at /usr/bin/openlogi"
