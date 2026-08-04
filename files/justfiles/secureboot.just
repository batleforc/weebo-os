# vim: set ft=make :

# Enroll the Weebo-OS Secure Boot signing key so the signed kernel boots with Secure Boot enabled
enroll-secure-boot-key:
    #!/usr/bin/env bash
    set -euo pipefail
    KEY=/etc/pki/akmods/certs/akmods-weebo-os.der
    if [[ ! -f "$KEY" ]]; then
        echo "Secure Boot key not found at $KEY — is this a Weebo-OS image?"
        exit 1
    fi
    if ! mokutil --sb-state 2>/dev/null | grep -qi enabled; then
        echo "Note: Secure Boot appears to be disabled in firmware. Enrolling anyway;"
        echo "the key will be used once you enable Secure Boot in your UEFI settings."
        echo
    fi
    echo "You will now be asked to create a one-time enrollment password."
    echo "Remember it: you must type the SAME password in the blue 'MOK Manager'"
    echo "screen that appears on the NEXT reboot to finish enrolling the key."
    echo
    sudo mokutil --import "$KEY"
    echo
    echo "Key queued for enrollment. Reboot, then in the MOK Manager choose:"
    echo "  Enroll MOK -> Continue -> Yes -> enter the password you just set -> reboot"
