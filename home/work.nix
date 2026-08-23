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
    # Prod lives outside the everyday KUBECONFIG on purpose, reached only
    # through these. Work machine only: nothing else has ~/.kube/prod.
    fish = {
      shellAbbrs = {
        kp = "kubectl --kubeconfig ~/.kube/prod/flanks-pro.yaml";
        k9sp = "env KUBECONFIG=(string join : $HOME/.kube/prod/*.yaml) k9s";
      };
    };
    mise = {
      enable = true;
    };
  };

  home = {
    packages = cloud ++ iac ++ secrets;
  };
}
