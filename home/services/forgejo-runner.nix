# Forgejo Actions runner, docker executor against the local daemon. The
# registration is declarative: forgejo.nix registers the shared secret on the
# server side, and create-runner-file turns the same secret into .runner here.
{
  pkgs,
  config,
  lib,
  ...
}:
let

  workDir = "${config.xdg.stateHome}/forgejo-runner";

  instance = "http://10.69.1.32:3000";

  settings = (pkgs.formats.yaml { }).generate "forgejo-runner.yaml" {
    runner = {
      file = "${workDir}/.runner";
      capacity = 1;
      timeout = "1h";
      # ubuntu-latest is what stock workflows ask for; the image is multi-arch.
      labels = [ "ubuntu-latest:docker://ghcr.io/catthehacker/ubuntu:act-22.04" ];
    };
    cache.enabled = true;
  };

  runner = lib.getExe pkgs.forgejo-runner;

  setup = pkgs.writeShellScript "forgejo-runner-setup" ''
    mkdir -p ${workDir}
    [ -s ${workDir}/.runner ] || ${runner} create-runner-file \
      --instance ${instance} \
      --secret "$(cat ${config.sops.secrets."forgejo-runner-secret".path})" \
      --name rebost
  '';

in
{
  systemd.user.services.forgejo-runner = {
    Unit = {
      Description = "Forgejo Actions runner";
      Wants = [ "forgejo.service" ];
      After = [ "forgejo.service" ];
    };

    Service = {
      WorkingDirectory = workDir;
      ExecStartPre = "${setup}";
      ExecStart = "${runner} daemon --config ${settings}";
      Restart = "on-failure";
      RestartSec = 5;
    };

    Install.WantedBy = [ "default.target" ];
  };
}
