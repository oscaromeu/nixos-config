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

  # Same pinentry dance as the work laptop: without GPG_TTY, pinentry-curses
  # dies with "curses.isatty"; the agent caches the passphrase per session.
  programs.fish.interactiveShellInit = ''
    set -gx GPG_TTY (tty)
    set -gx GOPASS_CONFIG_COUNT 1
    set -gx GOPASS_CONFIG_KEY_0 age.agent-enabled
    set -gx GOPASS_CONFIG_VALUE_0 true
  '';

  home.file.".gnupg/gpg-agent.conf".text = "pinentry-program /usr/bin/pinentry-curses";
}
