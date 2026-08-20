{ ... }:
{
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        # Generations kept in the boot menu; each switch adds one.
        configurationLimit = 15;
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };
    kernelParams = [ "quiet" ];
  };
}
