#!/usr/bin/env bash

set -oue pipefail

# Install resumectl from prebuilt binary

RESUMECTL_VERSION="1.2.0"

TEMP_DIR=$(mktemp -d)

echo "Installing resumectl ${RESUMECTL_VERSION} from prebuilt binary..."
cd "${TEMP_DIR}"
# Install resumectl

curl -LO "https://github.com/juhnny5/resumectl/releases/download/v${RESUMECTL_VERSION}/resumectl_${RESUMECTL_VERSION}_linux_amd64.tar.gz"
tar -xzf resumectl_${RESUMECTL_VERSION}_linux_amd64.tar.gz
install -m 755 resumectl /usr/bin/resumectl
echo "resumectl installed successfully at /usr/bin/resumectl"

# Clean up
cd -
rm -rf "${TEMP_DIR}"