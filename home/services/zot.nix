#
{
  pkgs,
  config,
  zot-bin,
  ...
}:
let

  port = "5000";

  # Nothing here expires, so none of it is cache: both stores are state and
  # both live on the array. Siblings and not nested, because the root store
  # walks its own directory to build the catalog.
  mirrorDir = "/data/zot/mirror";
  pushDir = "/data/zot/rebost";

  # zot picks a storage subpath by the first element of the repo name, so the
  # prefix that keeps our images out of the proxied namespace is the same
  # thing that keeps their blobs in their own store.
  namespace = "rebost";

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

  # Retention is per storage root, so both stores carry the same one: tags
  # never expire, only the manifests a re-push or a re-sync leaves untagged.
  collect = {
    gc = true;
    gcDelay = "1h";
    gcInterval = "24h";
    retention = {
      delay = "24h";
      policies = [
        {
          repositories = [ "**" ];
          deleteUntagged = true;
        }
      ];
    };
  };

  settings = (pkgs.formats.json { }).generate "zot.json" {
    distSpecVersion = "1.1.0";

    storage = collect // {
      rootDirectory = mirrorDir;
      subPaths."/${namespace}" = collect // {
        rootDirectory = pushDir;
      };
    };

    http = {
      address = "0.0.0.0";
      inherit port;
    };
    log.level = "info";
    extensions.search.enable = true;
    extensions.ui.enable = true;
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

  mergeConfig = pkgs.writeShellScript "zot-merge-config" ''
    frag=${config.xdg.configHome}/zot/http-fragment.json
    if [ -s "$frag" ]; then
      ${pkgs.jq}/bin/jq -s '.[0] * .[1]' ${settings} "$frag" > "$RUNTIME_DIRECTORY/config.json"
    else
      cp ${settings} "$RUNTIME_DIRECTORY/config.json"
    fi
  '';

in
{
  systemd.user.services.zot = {
    Unit = {
      Description = "zot OCI registry";
      Wants = [
        "network-online.target"
        "sops-nix.service"
      ];
      After = [
        "network-online.target"
        "sops-nix.service"
      ];
    };

    Service = {
      RuntimeDirectory = "zot";
      RuntimeDirectoryMode = "0700";
      # Both stores sit outside the directories systemd creates for the unit,
      # so nothing else is going to make them.
      ExecStartPre = [
        "${pkgs.coreutils}/bin/mkdir -p ${mirrorDir} ${pushDir}"
        "${mergeConfig}"
      ];
      ExecStart = "${zot}/bin/zot serve %t/zot/config.json";
      Restart = "on-failure";
      RestartSec = 5;
    };

    Install.WantedBy = [ "default.target" ];
  };
}
