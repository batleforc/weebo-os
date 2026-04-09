#!/usr/bin/env bash

set -oue pipefail

# Install Ollama using its official installer script

echo "Installing Ollama using the official installer..."

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required to install Ollama"
  exit 1
fi

TEMP_DIR=$(mktemp -d)
trap 'rm -rf "${TEMP_DIR}"' EXIT

curl -fsSL https://ollama.com/install.sh -o "${TEMP_DIR}/install.sh"
bash "${TEMP_DIR}/install.sh"

curl -fsSL https://opencode.ai/install -o "${TEMP_DIR}/installCode.sh"
bash "${TEMP_DIR}/installCode.sh"

# AMD GPU support (ROCm): install official Ollama ROCm build.
echo "Installing Ollama ROCm build for AMD GPUs..."
curl -fsSL https://ollama.com/download/ollama-linux-amd64-rocm.tar.zst | tar --zstd -x -C /usr

# Allow Ollama service user to access GPU devices.
if id ollama >/dev/null 2>&1; then
  usermod -a -G video,render ollama || true
fi

echo "Ollama installed successfully."
