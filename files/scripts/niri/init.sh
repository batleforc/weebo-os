#!/usr/bin/env bash

set -oue pipefail

systemctl --user enable dms
systemctl --user add-wants niri.service dms
