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
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      # Shared args: a module gets these by declaring `{ profile, ... }:`.
      profile = import ./user { };
      color = import ./config/color.nix { };
      theme = import ./config/theme.nix { };
      alias = import ./config/abbr.nix { };

      specialArgs = {
        inherit
          profile
          color
          theme
          alias
          ;
      };

      # One machine per hosts/<name> directory.
      mkHost =
        hostname:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          inherit specialArgs;
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
                users.${profile.name} = import ./home;
                extraSpecialArgs = specialArgs;
              };
            }
          ];
        };
    in
    {
      # One entry per machine: sudo nixos-rebuild switch --flake .#um560
      # (if the hostname already matches, --flake . is enough)
      nixosConfigurations = {
        um560 = mkHost "um560";
      };
    };
}
