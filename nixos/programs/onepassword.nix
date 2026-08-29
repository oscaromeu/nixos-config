# System-level, not home-manager: it needs polkit rules and its own setgid group.
{ profile, ... }:
{
  programs = {
    _1password = {
      enable = true;
    };

    # polkitPolicyOwners unlocks with the system auth instead of the master password.
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ profile.name ];
    };
  };

  # The browser integration only trusts binaries it knows, and the nixpkgs librewolf is a
  # wrapper (.librewolf-wrapped) it does not. Mode 0755 is required by 1Password.
  environment.etc."1password/custom_allowed_browsers" = {
    text = ''
      librewolf
      .librewolf-wrapped
    '';
    mode = "0755";
  };
}
