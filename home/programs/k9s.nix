# One kubeconfig per cluster: home stays in ~/.kube/config, work clusters are
# separate files under ~/.kube/configs/. Fish joins them, so dropping a file
# there is all it takes for the context to show up.
{ color, ... }:
{
  programs = {
    k9s = {
      enable = true;
      # Assigned per cluster from inside k9s' own state files, so prod is
      # unmistakable: red frame, red logo.
      skins = {
        # Everything stock except two amber cues: the logo and the crumb
        # strip. Enough to know where you are without shouting.
        prod = {
          k9s = {
            body = {
              fgColor = "default";
              bgColor = "default";
              logoColor = "${color.h_yellow}";
            };
            frame = {
              crumbs = {
                fgColor = "${color.h_background}";
                bgColor = "${color.h_yellow}";
                activeColor = "${color.h_bright_yellow}";
              };
            };
          };
        };
      };
    };

    fish = {
      interactiveShellInit = ''
        set -gx KUBECONFIG (string join : $HOME/.kube/config $HOME/.kube/configs/*.yaml)
      '';
    };
  };
}
