# Per-repo tool versions from .mise.toml, including the python venv home-ops
# builds its ansible into.
{ ... }:
{
  programs = {
    mise = {
      enable = true;
    };
  };
}
