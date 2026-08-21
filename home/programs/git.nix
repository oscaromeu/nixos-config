{ profile, lib, ... }:
{
  programs = {
    git = {
      enable = true;
      settings = {
        user = {
          name = "${profile.fullname}";
        }
        // lib.optionalAttrs (profile.email != null) { email = "${profile.email}"; };

        # A profile with no email keeps that identity out of a public repo:
        # sops-nix decrypts the file into place instead. See home/secrets.nix.
        include = lib.optionalAttrs (profile.email == null) {
          path = "~/.config/git/identity";
        };

        init = {
          defaultBranch = "main";
        };
        pull = {
          rebase = true;
        };
        core = {
          whitespace = "trailing-space,space-before-tab";
        };
      };
      lfs = {
        enable = true;
      };
      ignores = [
        "*~"
        "*.swp"
        ".direnv/"
      ];
    };
  };
}
