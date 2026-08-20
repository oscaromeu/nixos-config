# GTK apps need it to persist their settings.
{ ... }:
{
  programs = {
    dconf = {
      enable = true;
    };
  };
}
