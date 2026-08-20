{ profile, ... }:
{
  programs = {
    git = {
      enable = true;
      settings = {
        user = {
          email = "${profile.email}";
          name = "${profile.fullname}";
        };
        init = {
          defaultBranch = "main";
        };
        pull = {
          rebase = true;
        };
        core = {
          whitespace = "trailing-space,space-before-tab";
        };
      };
      lfs = {
        enable = true;
      };
      ignores = [
        "*~"
        "*.swp"
        ".direnv/"
      ];
    };
  };
}
