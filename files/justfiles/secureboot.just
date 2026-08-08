# vim: set ft=make :

# Enroll the Weebo-OS Secure Boot keys - Reboot and enter "universalblue" in the MOK Manager
enroll-secure-boot-key:
    #!/usr/bin/bash
    set -euo pipefail
    ENROLLMENT_PASSWORD="universalblue"
    # akmods-weebo-os.der signs the kernel (files/scripts/signkernel.sh), akmods-ublue.der
    # signs the akmods kernel modules shipped by the Universal Blue base image. Both are
    # needed for a fully working system with Secure Boot enabled.
    KEYS=()
    for KEY in /etc/pki/akmods/certs/akmods-weebo-os.der /etc/pki/akmods/certs/akmods-ublue.der; do
      if [ -f "$KEY" ]; then
        KEYS+=("$KEY")
      else
        echo "Skipping missing key: $KEY"
      fi
    done
    if [ "${#KEYS[@]}" -eq 0 ]; then
      echo "No Secure Boot key found in /etc/pki/akmods/certs - is this a Weebo-OS image?"
      exit 1
    fi
    sudo mokutil --timeout -1
    echo -e "$ENROLLMENT_PASSWORD\n$ENROLLMENT_PASSWORD" | sudo mokutil --import "${KEYS[@]}"
    echo -e 'At next reboot, the mokutil UEFI menu UI will be displayed (*QWERTY* keyboard input and navigation).\nThen, select "Enroll MOK", and input "universalblue" as the password'
