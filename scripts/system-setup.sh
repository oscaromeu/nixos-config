#!/usr/bin/env bash
# The system layer a standalone home-manager machine needs, in one idempotent
# pass. Run it as yourself, not with sudo — it calls sudo where it has to, and
# the files it writes resolve $HOME at runtime, so nothing here is user-specific.
#
#   ./scripts/system-setup.sh
#
# Out of scope on purpose: the Nix installer and the age key, which are cold
# start, and docker, which is apt package management. All three are in the
# runbook: https://docs.oscaromeu.io/doc/nix-sobre-ubuntu-jKcHCQxsw9
set -euo pipefail

profile="$HOME/.nix-profile"
changed=0

# Only reached when the sops secrets for the tunnel are present. OpenVPN and
# not wireguard: the UDM's wireguard server never instantiates (nothing in
# `wg show` even after recreating it), while its openvpn server is proven.
vpn_conf="$HOME/.config/openvpn/casa.ovpn"
vpn_auth="$HOME/.config/openvpn/casa.auth"
vpn_name="casa"
vpn_dns="10.69.1.32"
vpn_domain="~oscaromeu.io"

# Running before the installer would create a nix.conf holding only the line
# below, without the build-users-group the installer puts there.
if [ ! -d "$profile" ] || [ ! -x /nix/var/nix/profiles/default/bin/nix ]; then
  echo "install nix and run a first home-manager switch before this" >&2
  exit 1
fi

step() { printf '\n== %s\n' "$1"; }

ensure_line() {
  local file=$1 line=$2
  sudo mkdir -p "$(dirname "$file")"
  if sudo grep -qxF "$line" "$file" 2>/dev/null; then
    echo "already there: $line"
  else
    echo "$line" | sudo tee -a "$file" >/dev/null
    echo "added: $line"
    changed=1
  fi
}

# Content on stdin, so each caller reads as the file it writes.
write_file() {
  local path=$1 mode=$2
  sudo mkdir -p "$(dirname "$path")"
  sudo tee "$path" >/dev/null
  sudo chmod "$mode" "$path"
  echo "wrote: $path"
}

step "flakes in /etc/nix/nix.conf"
ensure_line /etc/nix/nix.conf "experimental-features = nix-command flakes"
if [ "$changed" = 1 ]; then
  sudo systemctl restart nix-daemon
fi

if [ -x "$profile/bin/fish" ]; then
  step "fish as a login shell"
  ensure_line /etc/shells "$profile/bin/fish"
  echo "to switch to it: chsh -s $profile/bin/fish"
fi

# home-manager builds this whenever targets.genericLinux.gpu is on.
if [ -x "$profile/bin/non-nixos-gpu-setup" ]; then
  step "GPU drivers for nix packages"
  sudo "$profile/bin/non-nixos-gpu-setup"
fi

if [ ! -x "$profile/bin/sway" ]; then
  step "no sway in the profile, nothing else to do"
  exit 0
fi

step "sway session wrapper"
write_file /usr/local/bin/sway-nix 0755 <<'EOF'
#!/bin/sh
# The display manager starts this with the distro's environment, which knows
# nothing about nix, so load home-manager's session variables first.
. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
exec "$HOME/.nix-profile/bin/sway" "$@" >>"$HOME/.sway-session.log" 2>&1
EOF

# No TryExec, and Exec points at the wrapper: the display manager evaluates
# both as its own user, and a 0750 home makes it hide the session instead.
step "session entry for the display manager"
write_file /usr/share/wayland-sessions/sway-nix.desktop 0644 <<'EOF'
[Desktop Entry]
Name=Sway (Nix)
Comment=sway from home-manager
Exec=/usr/local/bin/sway-nix
Type=Application
DesktopNames=sway
EOF

# nixpkgs patches pam_unix to call /run/wrappers/bin/unix_chkpwd, a NixOS path,
# because the store cannot carry setuid bits. /run is volatile, hence tmpfiles.
step "PAM helper, so swaylock can authenticate"
write_file /etc/tmpfiles.d/nix-pam-wrappers.conf 0644 <<'EOF'
d /run/wrappers/bin 0755 root root -
L+ /run/wrappers/bin/unix_chkpwd - - - - /usr/sbin/unix_chkpwd
EOF
sudo systemd-tmpfiles --create /etc/tmpfiles.d/nix-pam-wrappers.conf

# Minimal on purpose: common-auth pulls modules the store's pam does not have.
step "PAM stack for swaylock"
write_file /etc/pam.d/swaylock 0644 <<'EOF'
#%PAM-1.0
auth required pam_unix.so
EOF

# Changing prefs is checked against the caller, not the socket mode, so the
# waybar exit-node menu needs this once or it fails with an access denial.
if command -v tailscale >/dev/null 2>&1; then
  step "let this user drive tailscale"
  sudo tailscale set --operator="$USER"
fi

if [ -e "$vpn_conf" ]; then
  step "home vpn"
  if [ ! -e /usr/lib/NetworkManager/VPN/nm-openvpn-service.name ] && command -v apt-get >/dev/null 2>&1; then
    sudo apt-get install -y network-manager-openvpn
  fi
  # The dead wireguard attempt may still hold the name.
  if nmcli -t -f NAME,TYPE connection show | grep -qx "$vpn_name:wireguard"; then
    sudo nmcli connection delete "$vpn_name"
  fi
  if nmcli -t -f NAME connection show | grep -qx "$vpn_name"; then
    echo "already imported: $vpn_name"
  else
    sudo nmcli connection import type openvpn file "$vpn_conf"
  fi
  # The UniFi server speaks classic AES-256-CBC; a 2.6 client offers only the
  # GCM family by default and the server answers "no shared cipher".
  sudo nmcli connection modify "$vpn_name" +vpn.data "data-ciphers=AES-256-GCM:AES-128-GCM:CHACHA20-POLY1305:AES-256-CBC"
  if [ -e "$vpn_auth" ]; then
    vpn_user=$(sed -n 1p "$vpn_auth")
    vpn_pass=$(sed -n 2p "$vpn_auth")
    sudo nmcli connection modify "$vpn_name" vpn.user-name "$vpn_user"
    sudo nmcli connection modify "$vpn_name" +vpn.data password-flags=0
    sudo nmcli connection modify "$vpn_name" vpn.secrets "password=$vpn_pass"
  fi
  # Split DNS: the routing domain wins over whatever else claims every name.
  sudo nmcli connection modify "$vpn_name" ipv4.dns "$vpn_dns"
  sudo nmcli connection modify "$vpn_name" ipv4.dns-search "$vpn_domain"
  sudo nmcli connection modify "$vpn_name" ipv4.never-default yes
  sudo nmcli connection modify "$vpn_name" connection.autoconnect no
fi

# At home, tailscale's catch-all routing domain races the wifi's DHCP DNS for
# the internal view; pinning the domain on the wifi profile settles it.
if nmcli -t -f NAME connection show | grep -qx "Wifi Oscar"; then
  step "internal view over the home wifi"
  sudo nmcli connection modify "Wifi Oscar" ipv4.dns-search "$vpn_domain"
fi

# Convention: one kubeconfig per cluster under ~/.kube/configs, named after
# its context. Anything ending in -pro gets the amber k9s skin, so prod is
# unmistakable. k9s owns these state files, hence seeded here and not by nix.
step "k9s wears amber on prod"
for f in "$HOME"/.kube/configs/*-pro.yaml; do
  [ -e "$f" ] || continue
  ctx=$(basename "$f" .yaml)
  cluster=$(grep -m1 '  cluster:' "$f" | awk '{print $2}')
  [ -n "$cluster" ] || continue
  d="$HOME/.local/share/k9s/clusters/$cluster/$ctx"
  mkdir -p "$d"
  if [ -f "$d/config.yaml" ]; then
    grep -q 'skin:' "$d/config.yaml" || sed -i 's/^k9s:/k9s:\n  skin: prod/' "$d/config.yaml"
  else
    printf 'k9s:\n  skin: prod\n  cluster: %s\n' "$cluster" > "$d/config.yaml"
  fi
  echo "amber: $ctx"
done

step "done — log out and pick the Sway session"
