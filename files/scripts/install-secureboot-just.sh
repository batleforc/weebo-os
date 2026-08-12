#!/usr/bin/env bash

# Install the Weebo-OS `enroll-secure-boot-key` recipe so that it actually wins over the
# one shipped by `ublue-os-just` (packages/ublue-os-just/src/recipes/00-default.just),
# which only enrolls akmods-ublue.der and would leave our signed kernel unbootable.
#
# `just` resolves duplicate recipe names by import depth: the shallowest definition wins,
# and at equal depth the recipe from the *first* import wins. The layout in the image is:
#
#   /usr/share/ublue-os/justfile                     <- depth 0, always wins
#     import 00-default.just                         <- depth 1, ublue's recipe
#     ...
#     import? 60-custom.just                         <- depth 1, imported last
#       import /usr/share/bluebuild/justfiles/*.just  <- depth 2, where the `justfiles`
#                                                        module puts our recipes
#
# So the BlueBuild `justfiles` module (depth 2) can never override 00-default.just. The
# only placement that reliably wins without patching around ublue's own recipe text is
# the root justfile itself, so we append our recipe there.

set -oue pipefail

RECIPE="/usr/share/weebo-os/just/secureboot.just"
UBLUE_JUSTFILE="/usr/share/ublue-os/justfile"
MARKER="# >>> weebo-os secureboot >>>"

if [[ ! -f "${RECIPE}" ]]; then
  echo "install-secureboot-just: missing ${RECIPE}; did the files module run first?" >&2
  exit 1
fi

if [[ ! -f "${UBLUE_JUSTFILE}" ]]; then
  echo "install-secureboot-just: ${UBLUE_JUSTFILE} not found; is ublue-os-just installed?" >&2
  exit 1
fi

if grep -qF "${MARKER}" "${UBLUE_JUSTFILE}"; then
  echo "install-secureboot-just: recipe already present in ${UBLUE_JUSTFILE}; nothing to do."
  exit 0
fi

{
  printf '\n%s\n' "${MARKER}"
  cat "${RECIPE}"
  printf '%s\n' "# <<< weebo-os secureboot <<<"
} >> "${UBLUE_JUSTFILE}"

# Fail the build if the result is not a valid justfile, or if ublue's recipe still wins.
# `just --show` parses the whole justfile, so it catches syntax errors too.
if ! JUST_JUSTFILE="${UBLUE_JUSTFILE}" just --show enroll-secure-boot-key | grep -q 'akmods-weebo-os.der'; then
  echo "install-secureboot-just: enroll-secure-boot-key still resolves to another definition." >&2
  JUST_JUSTFILE="${UBLUE_JUSTFILE}" just --show enroll-secure-boot-key >&2
  exit 1
fi

echo "install-secureboot-just: enroll-secure-boot-key now resolves to the Weebo-OS recipe."
