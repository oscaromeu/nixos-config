{ ... }:
{
  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        # TODO: false once I confirm key-only login works (keys in user/default.nix).
        PasswordAuthentication = true;
      };
    };
  };
}
