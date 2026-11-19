#!/usr/bin/env bash

set -oue pipefail

# Install HeadsetControl from the upstream release RPM.
# The birkch/HeadsetControl COPR it replaces stalled at a July 2025 snapshot
# (3.1.0, built for Fedora 43) that only knew sidetone and inactive time on the
# Logitech G PRO X 2 LIGHTSPEED. Upstream 4.x adds its battery and equalizer.
# The RPM ships /usr/lib/udev/rules.d/70-headsets.rules for hidraw access.
HEADSETCONTROL_VERSION="4.3.0"
HEADSETCONTROL_REPO="Sapd/HeadsetControl"
TEMP_DIR="$(mktemp -d)"

echo "Installing HeadsetControl ${HEADSETCONTROL_VERSION}..."

cd "${TEMP_DIR}"

curl -fL "https://github.com/${HEADSETCONTROL_REPO}/releases/download/${HEADSETCONTROL_VERSION}/headsetcontrol-${HEADSETCONTROL_VERSION}-1.x86_64.rpm" -o headsetcontrol.rpm

# dnf resolves the one runtime dependency the RPM declares (hidapi)
dnf install -y ./headsetcontrol.rpm

# Clean up
cd -
rm -rf "${TEMP_DIR}"

echo "HeadsetControl installed successfully at /usr/bin/headsetcontrol"
