#!/usr/bin/env bash

set -oue pipefail

# Install FastFlowLM (flm), an NPU-native LLM runtime for AMD Ryzen AI.
#
# Hardware note: FastFlowLM only runs on XDNA2 NPUs (Ryzen AI 300/400 series,
# Strix, Strix Halo, Kraken, Gorgon Point). XDNA1 parts (Ryzen 7040/8040
# "Phoenix"/"Hawk Point", PCI 1022:1502) are NOT supported upstream - every
# shipped xclbin is built for NPU2.
#
# The upstream Linux tarball is fully self-contained: it bundles its own XRT
# runtime, including the libxrt_driver_xdna.so shim, under lib/ next to the
# binary. It therefore does not depend on the system XRT packages installed
# alongside it, and the two can differ in version without conflicting.

FASTFLOWLM_VERSION="1.0.5"

TEMP_DIR=$(mktemp -d)
trap 'rm -rf "${TEMP_DIR}"' EXIT

echo "Installing FastFlowLM ${FASTFLOWLM_VERSION} from prebuilt binary..."

curl -L --fail \
  "https://github.com/FastFlowLM/FastFlowLM/releases/download/v${FASTFLOWLM_VERSION}/fastflowlm_${FASTFLOWLM_VERSION}_linux.tar.gz" \
  -o "${TEMP_DIR}/fastflowlm.tar.gz"

# The tarball has no top-level directory, so extract straight into /opt.
# BlueBuild's optfix turns /opt/fastflowlm into a /usr/lib/opt symlink at build
# time, which is what makes it survive on an ostree deployment.
mkdir -p /opt/fastflowlm
tar -xzf "${TEMP_DIR}/fastflowlm.tar.gz" -C /opt/fastflowlm

chmod 0755 /opt/fastflowlm/flm /opt/fastflowlm/flm-real

# The bundled flm wrapper derives its library paths from $BASH_SOURCE without
# resolving symlinks, so a plain /usr/bin/flm -> /opt/fastflowlm/flm symlink
# would make it look for lib/ in /usr/bin. Ship a launcher that execs instead.
cat > /usr/bin/flm <<'LAUNCHER'
#!/usr/bin/env bash
exec /opt/fastflowlm/flm "$@"
LAUNCHER
chmod 0755 /usr/bin/flm

echo "FastFlowLM installed successfully at /opt/fastflowlm and launched via /usr/bin/flm"
