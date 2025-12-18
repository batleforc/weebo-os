#!/usr/bin/env bash

set -oue pipefail

systemctl --user add-wants niri.service dms