# Tooling for the day job. Only the work profile imports this — the NixOS
# desktop has no business carrying gcloud or terragrunt.
{ pkgs, ... }:
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
