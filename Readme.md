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

This queues **two** keys for enrollment with the enrollment password
`universalblue`:

- `/etc/pki/akmods/certs/akmods-weebo-os.der` — signs the kernel (Weebo-OS).
- `/etc/pki/akmods/certs/akmods-ublue.der` — signs the akmods kernel modules
  (nvidia, etc.) shipped by the Universal Blue base image.

On the **next reboot** the blue *MOK Manager* screen appears — choose
`Enroll MOK → Continue → Yes`, enter `universalblue` (*QWERTY* layout), then
reboot. Secure Boot can then stay enabled in your firmware.

Prefer to do it manually?

```
sudo mokutil --import /etc/pki/akmods/certs/akmods-weebo-os.der /etc/pki/akmods/certs/akmods-ublue.der
# reboot, then complete enrollment in the MOK Manager
```

> [!NOTE]
> `ublue-os-just` ships its own `enroll-secure-boot-key` recipe that only enrolls
> `akmods-ublue.der`. Because `just` resolves duplicate recipe names to the
> *shallowest* import, a recipe added through the BlueBuild `justfiles` module
> (import depth 2) is silently ignored. `files/scripts/install-secureboot-just.sh`
> therefore appends our recipe to the root `/usr/share/ublue-os/justfile`, which is
> the only placement that takes precedence, and hard-fails the build if it does not.

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

## The `niri-13` recipe

`recipes/niri-13.yml` builds `weebo-os-niri-13` for the second laptop. It shares
the base and the niri compositor with `niri.yml`, then differs in two ways: it
runs Noctalia instead of DankMaterialShell, and it carries the AMD XDNA NPU
stack. Both live in their own module files so the other images are untouched.

### Desktop shell: Noctalia

`recipes/niri/niri-modules.yml` now installs only niri and Mesa, and the shell
is chosen by the recipe that includes it:

| Recipe | Shell module |
| --- | --- |
| `niri.yml`, `niri-vm.yml` | `niri/dms-modules.yml` (DankMaterialShell, unchanged) |
| `niri-13.yml` | `niri-13/noctalia-modules.yml` ([Noctalia](https://noctalia.dev/)) |

Fedora 44 packages Noctalia itself, so there is no COPR to enable and no version
to pin. `ddcutil` comes along with it because the shell shells out to it to set
the brightness of external monitors over DDC/CI.

The two shells start differently, each following its own upstream advice. DMS
ships `dms.service` and the image enables it. Noctalia ships no unit and is
started by the compositor, so `spawn-at-startup "noctalia"` lives in the niri
config instead. Nothing in the image enables Noctalia: an image-level unit on
top of the autostart line would run a second instance.

### Picking the shell in the dotfiles

The [dotfiles](https://github.com/batleforc/dotfiles) carry one niri config for
both machines. `~/.config/niri/config.kdl` ends with a single `include
"shell.kdl"`, and chezmoi generates that file from `shell.kdl.tmpl`:

```
{{ if lookPath "noctalia" }}include "shell-noctalia.kdl"{{ else }}include "shell-dms.kdl"{{ end }}
```

The presence of the binary is the discriminator, so the image decides and there
is no host list to keep in sync. `shell-dms.kdl` holds the `dms/*.kdl` includes
DMS regenerates at runtime; `shell-noctalia.kdl` holds the autostart line, the
IPC keybinds, the floating settings window rule and the backdrop layer rule.
A templated `.chezmoiignore` skips `.config/niri/dms` on a Noctalia host.

Noctalia v5 is a native Wayland/OpenGL ES shell and no longer builds on
Quickshell, so a v4 configuration does not carry over.

### Ryzen AI NPU

| Piece | Where it comes from |
| --- | --- |
| `amdxdna` kernel driver | already in-tree in Fedora's kernel (Linux >= 7.0), nothing is layered |
| XRT runtime + `xrt-plugin-amdxdna` shim | COPR `darrencocco/ryzen-ai-npu`, a Fedora repack of [`amd/xdna-driver`](https://github.com/amd/xdna-driver/) |
| [FastFlowLM](https://fastflowlm.com/) (`flm`) | upstream portable tarball, pinned in `files/scripts/binary/install-fastflowlm.sh` |
| [Lemonade Server](https://lemonade-server.ai/) | upstream Fedora RPM, pinned in `files/scripts/binary/install-lemonade.sh` |

The `amd/xdna-driver` repository builds both a kernel module and the userspace
runtime. Only the userspace half is installed here: Fedora already ships the
driver, and `xrt-smi examine` reports it as `amdxdna Version: <kernel>`. Both
version pins are bumped automatically by updatecli, like every other pinned
binary in this repo.

#### Hardware support

FastFlowLM needs an **XDNA2** NPU: Ryzen AI 300 series (Strix Point, Krackan),
Ryzen AI Max 300 (Strix Halo), Ryzen AI 400 (Gorgon Point), Z2 Extreme. Every
xclbin it ships is built for NPU2. On **XDNA1** parts (Ryzen 7040/8040
"Phoenix"/"Hawk Point", PCI ID `1022:1502`) `flm` installs and runs but
`flm validate` fails, because there is no NPU1 kernel for it to load. XRT and
Lemonade Server are fine on both: XRT's `xrt_smi_phx.a` covers Phoenix, and
Lemonade's Linux backends are llama.cpp (Vulkan / ROCm) and vLLM ROCm, which
run on the GPU.

#### OpenCL loader swap

`xrt-base` requires `ocl-icd`, and the ublue base image ships the other Fedora
OpenCL loader, `OpenCL-ICD-Loader`. The two conflict, so the NPU module sets
`allow-erasing: true` and dnf swaps them. Nothing in the base image requires
`OpenCL-ICD-Loader` by name, and `ocl-icd` provides the same `libOpenCL.so.1`,
so ROCm OpenCL and the ffmpeg libraries keep working across the swap.

#### Using it

Neither server is enabled at boot; starting a model server is left as an
explicit choice:

```
systemctl --user enable --now lemond.service   # http://localhost:8000
flm serve qwen3:4b                             # XDNA2 only
```

`flm validate` checks the whole NPU stack, and `xrt-smi examine` reports the
runtime and driver versions. Both `xrt-plugin-amdxdna` (via
`/etc/security/limits.d/90-amdxdna-memlock.conf`) and the image (via
`/usr/lib/systemd/system/user@.service.d/10-amdxdna-memlock.conf`) raise
`RLIMIT_MEMLOCK`, which the NPU needs to map its buffers. The second file is
there because `pam_limits` does not apply to services started by the per-user
systemd manager.

## Troubleshooting

- In case of chrome app breaking chrome's font on startup:
  - Remove the `~/.cache/chrome*` / `~/.cache/fontconfig` directory and restart chrome, it should be recreated with the proper font configuration.