# Secrets that reach the machine encrypted. sops-nix decrypts on activation, so
# these values never take part in the nix evaluation — hence a git include
# instead of programs.git.settings.user.email.
{ config, profile, ... }:
{
  sops = {
    # The private half never lives in the repo. Put it here on the machine.
    age = {
      keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    };

    # One file per machine, so a key only opens its own secrets.
    defaultSopsFile = profile.secrets;

    secrets = {
      # Read by the [include] in home/programs/git.nix.
      "git-identity" = {
        path = "${config.home.homeDirectory}/.config/git/identity";
      };
    };
  };
}
