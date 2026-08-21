{
  description = "NixOS config for my machines — Sway desktop based on swayhome";

  inputs = {
    # Stable channel. home-manager below must track the same release.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

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
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      sops-nix,
      ...
    }:
    let
      color = import ./config/color.nix { };
      theme = import ./config/theme.nix { };
      alias = import ./config/abbr.nix { };

      # Shared args: a module gets these by declaring `{ profile, ... }:`.
      # Each machine passes its own profile, everything else is common.
      mkSpecialArgs = profile: {
        inherit
          profile
          color
          theme
          alias
          ;
      };

      # A NixOS machine: one per hosts/<name> directory.
      mkHost =
        hostname:
        let
          profile = import ./user { };
        in
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = mkSpecialArgs profile;
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
                extraSpecialArgs = mkSpecialArgs profile;
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
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          extraSpecialArgs = mkSpecialArgs profile;
          modules = [
            sops-nix.homeManagerModules.sops
            ./home/standalone.nix
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
          profile = import ./user/work.nix { };
          modules = [
            ./home/common.nix # CLI only for now
            ./home/work.nix
          ];
        };

        # user@hostname matches, so a bare `home-manager switch --flake .` works there.
        "oscar@rkw2" = mkHome {
          system = "aarch64-linux";
          profile = import ./user/rkw2.nix { };
          modules = [
            ./home/common.nix # a headless box only gets the CLI half
          ];
        };
      };
    };
}
