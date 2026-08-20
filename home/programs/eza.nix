{ ... }:
{
  programs = {
    eza = {
      enable = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
      git = true;
    };
  };
}
