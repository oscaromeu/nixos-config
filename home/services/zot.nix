#
{
  pkgs,
  config,
  zot-bin,
  ...
}:
let

  port = "5000";

  # A pull-through cache is fully rebuildable, so the blobs are cache, not state.
  dataDir = "${config.xdg.cacheHome}/zot";

  # The release binary is a dynamically linked PIE, so it still needs patching
  # even though nothing is compiled here.
  zot = pkgs.stdenvNoCC.mkDerivation {
    name = "zot";
    src = zot-bin;
    dontUnpack = true;
    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    buildInputs = [ pkgs.stdenv.cc.cc.lib ];
    installPhase = "install -Dm755 $src $out/bin/zot";
    meta.mainProgram = "zot";
  };

  # onDemand sync is what makes this a pull-through cache: nothing is copied
  # until something asks for it, and only these registries are ever proxied.
  upstream = url: {
    urls = [ url ];
    onDemand = true;
    tlsVerify = true;
    maxRetries = 3;
    retryDelay = "5m";
  };

  settings = (pkgs.formats.json { }).generate "zot.json" {
    distSpecVersion = "1.1.0";
    storage.rootDirectory = dataDir;
    http = {
      address = "0.0.0.0";
      inherit port;
    };
    log.level = "info";
    extensions.sync = {
      enable = true;
      registries = [
        (upstream "https://registry-1.docker.io")
        (upstream "https://ghcr.io")
        (upstream "https://quay.io")
        (upstream "https://registry.k8s.io")
      ];
    };
  };

in
{
  systemd.user.services.zot = {
    Unit = {
      Description = "zot OCI registry";
      Wants = [ "network-online.target" ];
      After = [ "network-online.target" ];
    };

    Service = {
      CacheDirectory = "zot";
      ExecStart = "${zot}/bin/zot serve ${settings}";
      Restart = "on-failure";
      RestartSec = 5;
    };

    Install.WantedBy = [ "default.target" ];
  };
}
