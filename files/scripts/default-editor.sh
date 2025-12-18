#!/usr/bin/env bash

set -oue pipefail

# Remove nano as default editor if installed

if [ -f "/etc/profile.d/nano-default-editor.sh" ]; then
    rm -f /etc/profile.d/nano-default-editor.sh
fi

if [ -f "/etc/profile.d/nano-default-editor.csh" ]; then
    rm -f /etc/profile.d/nano-default-editor.csh
fi