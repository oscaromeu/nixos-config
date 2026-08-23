<div align="center">

## nixos-config

_Declarative configuration for my NixOS machines — a Sway desktop built with flakes and home-manager._

</div>

<div align="center">

![NixOS](https://img.shields.io/badge/NixOS-26.05-5277C3?style=for-the-badge&logo=nixos&logoColor=white)
![WM](https://img.shields.io/badge/WM-Sway-4A90D9?style=for-the-badge)
![home-manager](https://img.shields.io/badge/home--manager-release--26.05-7EBAE4?style=for-the-badge)

</div>

> Most of this great work comes from [swayhome](https://git.sr.ht/~hervyqa/swayhome) — go give it a look.

## Overview

One flake, one entry per machine. `hosts/` holds one directory per machine — the profile with my data, plus the NixOS half where the machine runs NixOS — and everything else is shared. The profile reaches every module as the `profile` argument, so it is never spread around.

```
flake.nix    # inputs (nixpkgs, home-manager) and one entry per machine
hosts/       # one directory per machine: profile.nix, plus hardware and
             # stateVersion where the machine runs NixOS
config/      # shared constants: colour palette, theme, shell abbreviations
nixos/       # system config: programs, services, system, virtual
home/        # user config via home-manager: sway, programs, services, themes, xdg
asset/       # wallpapers
```

## Machines

| Host | Hardware | Installed |
| --- | --- | --- |
| `um560` | Minisforum UM560 XT — Ryzen 5 5600H, AMD iGPU, 32 GB RAM | 26.05 |

Machines that are not NixOS get the terminal half through standalone home-manager — the system underneath stays the distro's business:

| Entry | Machine | Runs |
| --- | --- | --- |
| `oscar@work` | Work laptop — Ubuntu 24.04, x86_64 | `home/common.nix` + `home/work.nix` |
| `oscar@rkw2` | NAS — Turing RK1, Ubuntu Rockchip, aarch64 | `home/common.nix` |

## Day to day

Everything runs from the clone on the machine itself (`~/nixos-config`). The abbreviations live in `config/abbr.nix`; fish expands them as you type.

| | Command | Abbr |
| --- | --- | --- |
| Apply my changes | `sudo nixos-rebuild switch --flake ~/nixos-config` | `nrs` |
| Build without activating | `nixos-rebuild build --flake ~/nixos-config` | `nrb` |
| Update packages | `nix flake update --flake ~/nixos-config`, then `nrs` | `nfu` |
| List system generations | `nix-env --list-generations -p /nix/var/nix/profiles/system` | `slg` |
| Roll back | `sudo nixos-rebuild switch --rollback` | |
| Free disk space | `sudo nix-collect-garbage --delete-older-than 14d` | `ngc` |

If a change breaks the boot, reboot and pick an older generation in the systemd-boot menu. Nothing is lost.

## Keybindings

`Mod` is Super.

| Key | Action |
| --- | --- |
| `Mod` + `Enter` | Terminal (kitty) |
| `Mod` + `d` | App launcher (rofi) |
| `Mod` + `e` | File manager (yazi in a terminal) |
| `Mod` + `g` | File browser (rofi) |
| `Mod` + `c` | Clipboard history |
| `Mod` + `y` | Bluetooth |
| `Mod` + `m` | Emoji picker |
| `Mod` + `n` | Colour picker |
| `Mod` + `o` | Screen mirror, for presentations |
| `Mod` + `p` | Monitor layout (wdisplays) |
| `Mod` + `x` | Power menu |
| `Mod` + `Escape` | Lock the screen |
| `Mod` + `1-9` | Go to workspace N |
| `Mod` + `Shift` + `1-9` | Move the window to workspace N |
| `Mod` + `Tab` | Next workspace (`Shift` for the previous one) |
| `Mod` + `h/j/k/l` | Move the focus |
| `Mod` + `Shift` + `h/j/k/l` | Move the window |
| `Mod` + `f` | Fullscreen |
| `Mod` + `Shift` + `q` | Close the window |
| `Mod` + `r` | Resize mode (`h/j/k/l`, `Esc` leaves) |
| `Mod` + `u` | Audio mode: `i` input, `o` output |
| `Print` | Screenshot: `1` screen, `2` region, `3` window |
| `Shift` + `Print` | Record: `1-4` variants, `0` stops |


## Gratitude and thanks

[swayhome](https://git.sr.ht/~hervyqa/swayhome) by Hervy Qurrotul Ainur Rozi is the base of the Sway config, the Breeze palette and the theme, and most of `home/` comes from there almost verbatim. If you want to add more programs (qutebrowser, aerc, helix with LSPs, zellij...), that repo is the first place to look.

## License

See [LICENSE.md](./LICENSE.md) — MIT, same as swayhome.
