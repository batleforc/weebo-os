#!/usr/bin/env bash

set -oue pipefail

dnf config-manager setopt google-chrome.enabled=1