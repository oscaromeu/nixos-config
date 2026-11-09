# nixpkgs' skopeo carries no trust policy, and this machine has no
# /etc/containers/policy.json either, so every copy/inspect aborts without one.
{ pkgs, ... }:
let
  acceptAnything = [ { type = "insecureAcceptAnything"; } ];
in
{
  home.packages = [ pkgs.skopeo ];

  xdg.configFile."containers/policy.json".source =
    (pkgs.formats.json { }).generate "containers-policy"
      {
        default = acceptAnything;
        transports = {
          docker-daemon = {
            "" = acceptAnything;
          };
        };
      };
}
