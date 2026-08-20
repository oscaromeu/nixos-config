{ pkgs, profile, ... }:
{
  users = {
    users = {
      ${profile.name} = {
        isNormalUser = true;
        description = "${profile.fullname}";
        uid = 1000;
        shell = pkgs.fish;
        extraGroups = [
          "audio"
          "docker"
          "input"
          "lp"
          "networkmanager"
          "video"
          "wheel" # sudo
        ];
        openssh = {
          authorizedKeys = {
            keys = profile.sshKeys;
          };
        };
      };
    };
  };
}
