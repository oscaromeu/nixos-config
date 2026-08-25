# Shell abbreviations. fish expands them as you type.
{ profile, ... }:
let

  repo = "~/Documents/repos/gh/nixos-config";

  rebuild =
    if profile.hmTarget == null then
      {
        nrs = "sudo nixos-rebuild switch --flake ${repo}";
        nrb = "nixos-rebuild build --flake ${repo}";
        nrd = "sudo nixos-rebuild dry-activate --flake ${repo}";
        slg = "sudo nix-env --list-generations -p /nix/var/nix/profiles/system";
      }
    else
      {
        nrs = "home-manager switch --flake ${repo}#${profile.hmTarget}";
        nrb = "home-manager build --flake ${repo}#${profile.hmTarget}";
        nrd = "home-manager switch --dry-run --flake ${repo}#${profile.hmTarget}";
        slg = "home-manager generations";
      };

  abbr = rebuild // {
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

    # rebuilds; nrs/nrb/nrd/slg come from `rebuild` above, per machine
    nfu = "nix flake update --flake ${repo}";

    # garbage collection
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
