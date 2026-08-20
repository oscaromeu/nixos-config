# services.openssh opens port 22 on its own.
{ ... }:
{
  networking = {
    firewall = {
      enable = true;
      allowPing = true;
    };
  };
}
