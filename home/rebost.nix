# Machine-specific bits for the NAS.
{ config, ... }:
{
  # Same shared identity as the other gopass clients, delivered by sops.
  sops.secrets."gopass-age-identities" = {
    sopsFile = ../secrets/work-gopass-identities;
    format = "binary";
    path = "${config.home.homeDirectory}/.config/gopass/age/identities";
    mode = "0600";
  };
}
