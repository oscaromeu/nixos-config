# Tooling for the day job. Only the work profile imports this — the NixOS
# desktop has no business carrying gcloud or terragrunt.
{ config, pkgs, ... }:
with pkgs;
let

  cloud = [
    # The bare sdk cannot talk to GKE; kubectl needs the auth plugin.
    (google-cloud-sdk.withExtraComponents [
      google-cloud-sdk.components.gke-gcloud-auth-plugin
    ])
    kubernetes-helm
  ];

  iac = [
    terraform
    terragrunt
  ];

  secrets = [
    age
    sops
  ];

in
{
  # The tunnel itself is system layer, so only its config comes from here.
  sops = {
    secrets = {
      "wg-casa" = {
        path = "${config.home.homeDirectory}/.config/wireguard/casa.conf";
        mode = "0600";
      };
      "ovpn-casa" = {
        path = "${config.home.homeDirectory}/.config/openvpn/casa.ovpn";
        mode = "0600";
      };
      "ovpn-casa-auth" = {
        path = "${config.home.homeDirectory}/.config/openvpn/casa.auth";
        mode = "0600";
      };
    };
  };

  services = {
    syncthing = {
      enable = true;
    };
  };

  # Version pinning per repo when nixpkgs' version is not the one the team uses.
  programs = {
    mise = {
      enable = true;
    };
  };

  home = {
    packages = cloud ++ iac ++ secrets;
  };
}
