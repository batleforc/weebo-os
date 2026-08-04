#!/usr/bin/env bash

# Sign the kernel image (vmlinuz) with the Weebo-OS Machine Owner Key (MOK) so
# that it can boot on machines with UEFI Secure Boot enabled once the user has
# enrolled the matching public key (see `ujust enroll-secure-boot-key`).
#
# Derived from Universal Blue / secureblue `signkernel.sh` (Apache-2.0).

set -oue pipefail

PUBLIC_KEY_CRT_PATH="/tmp/certs/public_key.crt"
PRIVATE_KEY_PATH="/tmp/certs/private_key.priv"

# Gracefully skip signing when no private key is available (local builds, or
# pull requests from forks where the CI secret is not exposed). The image still
# builds and boots — it just is not Secure Boot signed. This keeps the current
# setup working, as required by the issue.
if [[ ! -s "${PRIVATE_KEY_PATH}" ]]; then
  echo "signkernel: no signing key at ${PRIVATE_KEY_PATH}; skipping kernel signing." >&2
  exit 0
fi

if [[ ! -f "${PUBLIC_KEY_DER_PATH}" ]]; then
  echo "signkernel: expected public key at ${PUBLIC_KEY_DER_PATH} but it is missing." >&2
  exit 1
fi

KERNEL_VERSION="$(rpm -q kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')"
VMLINUZ="/usr/lib/modules/${KERNEL_VERSION}/vmlinuz"

echo "signkernel: signing ${VMLINUZ} for kernel ${KERNEL_VERSION}"

# Convert the shipped DER certificate to the PEM form sbsign expects.
openssl x509 -inform DER -in "${PUBLIC_KEY_DER_PATH}" -out "${PUBLIC_KEY_CRT_PATH}"

sbsign --cert "${PUBLIC_KEY_CRT_PATH}" --key "${PRIVATE_KEY_PATH}" \
  "${VMLINUZ}" --output "${VMLINUZ}"

# Fail the build if the signature did not take.
sbverify --cert "${PUBLIC_KEY_CRT_PATH}" "${VMLINUZ}"
sbverify --list "${VMLINUZ}"

echo "signkernel: kernel signed successfully."
