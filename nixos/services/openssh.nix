{ ... }:
{
  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        # TODO: false once I confirm key-only login works (keys in hosts/um560/profile.nix).
        PasswordAuthentication = true;
      };
    };
  };
}
