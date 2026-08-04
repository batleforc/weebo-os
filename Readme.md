# Weebo-OS the GitOps way

![Weebo-OS](/assets/logo.png)

## Goal

- Replace Omarchy by Weebo-OS
- Discover and deepdive the handling of dotfile
- Create a tekton pipeline to build/handle this project to make sure that if github goes even more nuts i can switch to my own git
- Try different tiling manager, Hyprland has my love for the past month but i need to check other tiling manager
- Try Distrobox in a no root way !
- Keep the TUI first approach but make sure that all the tools are properly added to the doc
- VsCode and LazyVim are good !
- Look at [ToolBox](https://containertoolbx.org/) from Fedora

## Sources

- [Une Tasse de Cafe - Ostree Bootc](https://une-tasse-de.cafe/blog/ostree-bootc/)
- [Bootcrew - Arch Bootc](https://github.com/bootcrew/arch-bootc)
- [BaseCamp - Omarchy](https://github.com/basecamp/omarchy)
- [BootC Image Builder](https://github.com/osbuild/bootc-image-builder)
- [Fedora Hyprland](https://discussion.fedoraproject.org/t/tutorial-fedora-43-install-hyprland-from-scratch/168386)
- [Blue Bird](https://blue-build.org/)
- [Wayblue](https://github.com/wayblueorg/wayblue)

## Installation

> [!WARNING]  
> [This is an experimental feature](https://www.fedoraproject.org/wiki/Changes/OstreeNativeContainerStable), try at your own discretion.

To rebase an existing atomic Fedora installation to the latest build:

- First rebase to the unsigned image, to get the proper signing keys and policies installed:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/batleforc/weebo-os:latest
  ```
- Reboot to complete the rebase:
  ```
  systemctl reboot
  ```
- Then rebase to the signed image, like so:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/batleforc/weebo-os:latest
  ```
- Reboot again to complete the installation
  ```
  systemctl reboot
  ```


## Secure Boot

The kernel shipped in Weebo-OS images is signed with a project-specific
**Machine Owner Key (MOK)**. To boot with UEFI Secure Boot enabled you need to
enroll the matching public key **once** on each machine:

```
ujust enroll-secure-boot-key
```

This queues the key (`/etc/pki/akmods/certs/akmods-weebo-os.der`) for enrollment
and asks you to set a one-time password. On the **next reboot** the blue *MOK
Manager* screen appears — choose `Enroll MOK → Continue → Yes`, enter that same
password, then reboot. Secure Boot can then stay enabled in your firmware.

Prefer to do it manually?

```
sudo mokutil --import /etc/pki/akmods/certs/akmods-weebo-os.der
# reboot, then complete enrollment in the MOK Manager
```

> [!NOTE]
> Container image signing (cosign, see below) and Secure Boot are independent:
> cosign proves *where the image came from*, Secure Boot lets the *firmware*
> verify the kernel at boot.

### Maintainer note

The signing keypair is a standard MOK pair:

- `files/system/etc/pki/akmods/certs/akmods-weebo-os.der` — public cert, committed
  and shipped in the image.
- `MOK.priv` — PEM private key, **never committed**. Stored as the
  `SB_PRIVATE_KEY` GitHub Actions secret and written to `.secure_files/MOK.priv`
  at build time. For local builds, drop your own `.secure_files/MOK.priv`
  (git-ignored); without it the build still succeeds but the kernel is left
  unsigned.

## Troubleshooting

- In case of chrome app breaking chrome's font on startup:
  - Remove the `~/.cache/chrome*` / `~/.cache/fontconfig` directory and restart chrome, it should be recreated with the proper font configuration.