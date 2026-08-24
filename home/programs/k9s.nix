# One kubeconfig per cluster: home stays in ~/.kube/config, work clusters are
# separate files under ~/.kube/configs/. Fish joins them, so dropping a file
# there is all it takes for the context to show up.
{ color, ... }:
{
  programs = {
    k9s = {
      enable = true;
      settings = {
        k9s = {
          ui = {
            logoless = true;
          };
          # For the node shell: busybox can't debug anything.
          shellPod = {
            image = "ubuntu:22.04";
            namespace = "default";
            limits = {
              cpu = "100m";
              memory = "100Mi";
            };
            hostPID = true;
            hostNetwork = true;
            hostIPC = true;
            securityContext = {
              privileged = true;
              runAsUser = 0;
            };
          };
        };
      };

      aliases = {
        aliases = {
          dp = "deployments";
          sec = "v1/secrets";
          jo = "jobs";
          cr = "clusterroles";
          crb = "clusterrolebindings";
          ro = "roles";
          rb = "rolebindings";
          np = "networkpolicies";
        };
      };

      # Assigned per cluster from inside k9s' own state files, so prod is
      # unmistakable.
      skins = {
        # Everything stock except two amber cues: the borders and the crumb
        # strip. Enough to know where you are without shouting.
        prod = {
          k9s = {
            body = {
              fgColor = "default";
              bgColor = "default";
            };
            frame = {
              border = {
                fgColor = "${color.h_yellow}";
                focusColor = "${color.h_bright_yellow}";
              };
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
        # Through a variable on purpose: an unmatched glob aborts the whole init
        # block, except as an argument to set.
        set -l __kube_extras $HOME/.kube/configs/*.yaml
        set -gx KUBECONFIG (string join : $HOME/.kube/config $__kube_extras)
      '';
    };
  };
}
