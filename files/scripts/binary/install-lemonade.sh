#!/usr/bin/env bash

set -oue pipefail

# Install Lemonade Server, AMD's local LLM server (OpenAI-compatible API, web
# UI and CLI) from the upstream Fedora RPM.
#
# The RPM lands in /opt (BlueBuild's optfix relocates it to /usr/lib/opt at
# build time) and ships both a system and a user lemond.service. Neither is
# enabled here: starting a model server on boot should stay an explicit choice.
#
# Backends on Linux: llama.cpp (Vulkan / ROCm) and vLLM ROCm, downloaded on
# first use into the user's cache. NPU offload on Linux goes through
# FastFlowLM, which needs an XDNA2 part - see install-fastflowlm.sh.

LEMONADE_VERSION="11.9.0"

FEDORA_VERSION="$(. /usr/lib/os-release && echo "${VERSION_ID}")"
RPM_NAME="lemonade-server-${LEMONADE_VERSION}-fc${FEDORA_VERSION}.x86_64.rpm"

TEMP_DIR=$(mktemp -d)
trap 'rm -rf "${TEMP_DIR}"' EXIT

echo "Installing Lemonade Server ${LEMONADE_VERSION} (${RPM_NAME})..."

curl -L --fail \
  "https://github.com/lemonade-sdk/lemonade/releases/download/v${LEMONADE_VERSION}/${RPM_NAME}" \
  -o "${TEMP_DIR}/${RPM_NAME}"

# Upstream ships the release RPMs unsigned. localpkg_gpgcheck scopes the
# exemption to this one command-line file: dependencies pulled from the Fedora
# repositories are still signature-checked as usual.
DNF="$(command -v dnf5 || command -v dnf)"
"${DNF}" install -y \
  --setopt=localpkg_gpgcheck=0 \
  --setopt=install_weak_deps=False \
  "${TEMP_DIR}/${RPM_NAME}"

# The RPM's %post creates the lemonade user with /opt/var/lib/lemonade as its
# home and mkdir's it. On ostree that path ends up read-only under
# /usr/lib/opt, while lemond.service actually uses StateDirectory=lemonade
# (/var/lib/lemonade). Drop the stray tree and point the account at the real
# state directory so nothing writes to a read-only home.
usermod -d /var/lib/lemonade lemonade
rm -rf /opt/var

echo "Lemonade Server installed successfully. Enable it with:"
echo "  systemctl --user enable --now lemond.service"
