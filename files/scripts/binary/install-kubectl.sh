#!/usr/bin/env bash

set -oue pipefail

# Install kubectl, Krew, K9S from prebuilt binary

KUBECTL_VERSION="v1.25.0"
K9S_VERSION="v0.50.16"

TEMP_DIR=$(mktemp -d)

echo "Installing kubectl ${KUBECTL_VERSION}, Krew latest, K9S ${K9S_VERSION} from prebuilt binaries..."
cd "${TEMP_DIR}"
# Install kubectl

curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
install -m 755 kubectl /usr/bin/kubectl
echo "kubectl installed successfully at /usr/bin/kubectl"

# Install Krew
(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  KREW="krew-${OS}_${ARCH}" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
  tar zxvf "${KREW}.tar.gz" &&
  ./"${KREW}" install krew
)
echo "Krew installed successfully"

# Install K9S
curl -LO "https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_amd64.tar.gz"
tar -xzf k9s_Linux_amd64.tar.gz
install -m 755 k9s /usr/bin/k9s
echo "K9S installed successfully at /usr/bin/k9s"

# Clean up
cd -
rm -rf "${TEMP_DIR}"
echo "Installation of kubectl, Krew, and K9S completed successfully."
