# Shell abbreviations. fish expands them as you type.
{ ... }:
let

  abbr = {
    # utils
    e = "eza";
    ll = "eza -l";
    la = "eza -la";
    f = "fastfetch";
    g = "git";
    h = "hx";
    m = "btm";
    da = "lsblk -o name,fstype,fsavail,fsused,size,mountpoint";

    # systemd
    ust = "systemctl --user start";
    usp = "systemctl --user stop";
    usr = "systemctl --user restart";
    uss = "systemctl --user status";

    sst = "sudo systemctl start";
    ssp = "sudo systemctl stop";
    ssr = "sudo systemctl restart";
    sss = "sudo systemctl status";

    # rebuilds; assumes the repo is cloned at ~/nixos-config
    nrs = "sudo nixos-rebuild switch --flake ~/nixos-config";
    nrb = "nixos-rebuild build --flake ~/nixos-config";
    nrd = "sudo nixos-rebuild dry-activate --flake ~/nixos-config";
    nfu = "nix flake update --flake ~/nixos-config";

    # generations and garbage collection
    slg = "sudo nix-env --list-generations -p /nix/var/nix/profiles/system";
    ngc = "sudo nix-collect-garbage --delete-older-than 14d";

    # git
    gst = "git status -sbu";
    gdf = "git diff";
    gdc = "git diff --cached";
    glo = "git log --decorate --oneline";
    glg = "git log --graph";
    gur = "git pull --rebase";
    gcb = "git checkout -b";
    gfa = "git fetch --all --prune";
  };

in
{

  inherit abbr;

}
