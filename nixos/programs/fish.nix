# Must be enabled system-wide to be a login shell; the prompt is in home/programs/fish.nix.
{ ... }:
{
  programs = {
    fish = {
      enable = true;
      useBabelfish = true; # translates the bash env scripts to fish
    };
  };
}
