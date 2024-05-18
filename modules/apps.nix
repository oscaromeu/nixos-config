{ pkgs, ... }: {

  ##########################################################################
  # 
  #  Install all apps and packages here.
  #
  #  NOTE: Your can find all available options in:
  #    https://daiderd.com/nix-darwin/manual/index.html
  #
  ##########################################################################

  # Install packages from nix's official package repository.
  #
  # The packages installed here are available to all users, and are reproducible across machines, and are rollbackable.
  # But on macOS, it's less stable than homebrew.
  #
  # Related Discussion: https://discourse.nixos.org/t/darwin-again/29331
  environment.systemPackages = with pkgs; [
    alacritty
    neovim
    git
    go-task # use go-task to simplify nix-darwin's commands
    _1password
    _1password-gui
    iterm2
    utm
  ];
  environment.variables.EDITOR = "nvim";

  # TODO To make this work, homebrew need to be installed manually, see https://brew.sh
  # 
  # The apps installed by homebrew are not managed by nix, and not reproducible!
  # But on macOS, homebrew has a much larger selection of apps than nixpkgs, especially for GUI apps!
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      # 'zap': uninstalls all formulae(and related files) not listed here.
      cleanup = "zap";
    };

    # Applications to install from Mac App Store using mas.
    # You need to install all these Apps manually first so that your apple account have records for them.
    # otherwise Apple Store will refuse to install them.
    # For details, see https://github.com/mas-cli/mas 
    masApps = {
      # TODO Feel free to add your favorite apps here.

      Xcode = 497799835;
      # Wechat = 836500024;
      # NeteaseCloudMusic = 944848654;
      # QQ = 451108668;
      # WeCom = 1189898970;  # Wechat for Work
      # TecentMetting = 1484048379;
      # QQMusic = 595615424;
    };

    taps = [
      "homebrew/cask-fonts"
      "homebrew/services"
      "fluxcd/tap"
      "go-task/tap"
      "siderolabs/tap"
    ];

    # `brew install`
    # TODO Feel free to add your favorite apps here.
    brews = [
      "wget" # download tool
      "curl" # no not install curl via nixpkgs, it's not working well on macOS!
      "aria2" # download tool
      "httpie" # http client
      "fontconfig" # List available fonts installed on the system.
      "cirruslabs/cli/tart"
      "go-task"
      "direnv"
      "age"
      "cloudflared"
      "direnv"
      "fluxcd/tap/flux"
      "go-task/tap/go-task"
      "helm"
      "helmfile"
      "jq"
      "kubeconform"
      "kubernetes-cli"
      "kustomize"
      "moreutils"
      "sops"
      "stern"
      "talhelper"
      "talosctl"
      "yq"
    ];

    # `brew install --cask`
    # TODO Feel free to add your favorite apps here.
    casks = [
      "firefox"
      "google-chrome"
      "visual-studio-code"

      # IM & audio & remote desktop & meeting
      "telegram"
      "discord"

      "raycast" # (HotKey: alt/option + space)search, caculate and run scripts(with many plugins)
      "stats" # beautiful system monitor

      # Development
      "wireshark" # network analyzer
    ];
  };
}
