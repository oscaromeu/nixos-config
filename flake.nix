{
  description = "NixOS config for my machines — Sway desktop based on swayhome";

  inputs = {
    # Stable channel. home-manager below must track the same release.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # Only for the odd package that must be newer than the release, like atuin,
    # whose sync format has to match every machine.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # follows keeps home-manager on the same nixpkgs — one version of everything.
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets decrypted at activation time, never at evaluation time.
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # zot is not in nixpkgs and the RK1 is not for compiling Go, so this is the
    # release binary. Its hash lives in flake.lock, not here: renovate only
    # bumps the URL and nix relocks it on the next switch.
    # renovate: datasource=github-releases depName=project-zot/zot
    zot-bin = {
      url = "file+https://github.com/project-zot/zot/releases/download/v2.1.20/zot-linux-arm64";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      sops-nix,
      zot-bin,
      ...
    }:
    let
      color = import ./config/color.nix { };
      theme = import ./config/theme.nix { };

      # Shared args: a module gets these by declaring `{ profile, ... }:`.
      # Each machine passes its own profile, everything else is common.
      mkSpecialArgs = profile: system: {
        inherit
          profile
          color
          theme
          ;
        alias = import ./config/abbr.nix { inherit profile; };
        pkgsUnstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };

      # A NixOS machine: one per hosts/<name> directory.
      mkHost =
        hostname:
        let
          profile = import ./hosts/${hostname}/profile.nix { };
        in
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = mkSpecialArgs profile "x86_64-linux";
          modules = [
            ./hosts/${hostname} # hardware, hostname, stateVersion
            ./nixos # shared system config
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true; # the system nixpkgs, not a separate one
                useUserPackages = true; # user packages through the system profile
                # Move files already in $HOME aside instead of failing the activation.
                backupFileExtension = "hm-backup";
                # sops-nix lives in the home-manager layer here too, same as standalone.
                sharedModules = [ sops-nix.homeManagerModules.sops ];
                users.${profile.name} = import ./home;
                extraSpecialArgs = mkSpecialArgs profile "x86_64-linux";
              };
            }
          ];
        };

      # home-manager on its own, for machines that are not NixOS. Only the user
      # half is declarative there; the system stays the distro's business.
      mkHome =
        {
          system,
          profile,
          modules,
          extraArgs ? { }, # host-specific module args, like a binary input
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          extraSpecialArgs = mkSpecialArgs profile system // extraArgs;
          modules = [
            sops-nix.homeManagerModules.sops
          ]
          ++ modules;
        };
    in
    {
      # One entry per machine: sudo nixos-rebuild switch --flake .#um560
      # (if the hostname already matches, --flake . is enough)
      nixosConfigurations = {
        um560 = mkHost "um560";
      };

      # home-manager switch --flake .#oscar@work
      homeConfigurations = {
        "oscar@work" = mkHome {
          system = "x86_64-linux";
          profile = import ./hosts/work/profile.nix { };
          modules = [
            ./home/standalone.nix
            ./home/linux.nix
            ./home/common.nix
            ./home/desktop.nix # sway alongside the distro's GNOME
            ./home/work.nix
          ];
        };

        # The personal MacBook Air: the first darwin machine, terminal layer only.
        "oscar@air" = mkHome {
          system = "aarch64-darwin";
          profile = import ./hosts/air/profile.nix { };
          modules = [
            ./home/darwin.nix
            ./home/common.nix
          ];
        };

        # user@hostname matches, so a bare `home-manager switch --flake .` works there.
        "oscar@rebost" = mkHome {
          system = "aarch64-linux";
          profile = import ./hosts/rebost/profile.nix { };
          modules = [
            ./home/standalone.nix
            ./home/linux.nix
            ./home/common.nix # a headless box only gets the CLI half
            ./home/services/zot.nix # only the NAS serves a registry
            ./home/services/valkey.nix # forgejo's cache and sessions
            ./home/services/postgres.nix # forgejo's database
            ./home/services/pgbackrest.nix # its encrypted backups on /data
            ./home/services/forgejo.nix
          ];
          extraArgs = { inherit zot-bin; };
        };
      };
    };
}
