{
  alias,
  pkgs,
  ...
}:
with pkgs;
{
  programs = {
    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting
      '';
      plugins = with fishPlugins; [
        {
          name = "forgit";
          src = forgit;
        }
        {
          name = "git";
          src = plugin-git;
        }
        {
          name = "hydro";
          src = hydro;
        }
        {
          name = "pisces";
          src = pisces;
        }
        {
          name = "sponge";
          src = sponge;
        }
        {
          name = "tide";
          src = tide;
        }
      ];
      preferAbbrs = true;
      shellAbbrs = alias.abbr;
    };
  };
}
