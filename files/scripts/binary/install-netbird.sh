#!/usr/bin/env bash

set -oue pipefail

# Install Netbird from prebuilt binary

NETBIRD_VERSION="0.62.3"

TEMP_DIR=$(mktemp -d)

echo "Installing Netbird ${NETBIRD_VERSION} from prebuilt binary..."
cd "${TEMP_DIR}"

# Install Netbird
curl -LO "https://github.com/netbirdio/netbird/releases/download/v${NETBIRD_VERSION}/netbird_${NETBIRD_VERSION}_linux_amd64.tar.gz"
tar -xzf "netbird_${NETBIRD_VERSION}_linux_amd64.tar.gz"
install -m 755 netbird /usr/bin/netbird
echo "Netbird installed successfully at /usr/bin/netbird"

# Install Netbird UI
curl -LO "https://github.com/netbirdio/netbird/releases/download/v${NETBIRD_VERSION}/netbird-ui-linux_${NETBIRD_VERSION}_linux_amd64.tar.gz"
tar -xzf "netbird-ui-linux_${NETBIRD_VERSION}_linux_amd64.tar.gz"
install -m 755 netbird-ui /usr/bin/netbird-ui
echo "Netbird UI installed successfully at /usr/bin/netbird-ui"

# Clean up
cd -
rm -rf "${TEMP_DIR}"
echo "Installation of Netbird completed successfully."
