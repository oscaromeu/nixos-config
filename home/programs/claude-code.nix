# Claude Code with its MCP servers declared here instead of in ~/.claude.json.
# Tokens never enter the nix evaluation: each server is a small wrapper that
# reads its secret from the sops-decrypted path at runtime.
{
  config,
  pkgs,
  pkgsUnstable,
  ...
}:
let

  vikunja-mcp = pkgs.writeShellScriptBin "vikunja-mcp" ''
    export VIKUNJA_URL="https://vikunja.oscaromeu.io/api/v1"
    export VIKUNJA_API_TOKEN="$(cat ${config.sops.secrets."vikunja-api-token".path})"
    exec ${pkgs.nodejs}/bin/npx -y @democratize-technology/vikunja-mcp "$@"
  '';

in
{
  sops = {
    secrets = {
      "vikunja-api-token" = {
        path = "${config.home.homeDirectory}/.config/vikunja/token";
        mode = "0600";
      };
    };
  };

  programs = {
    claude-code = {
      enable = true;
      # From unstable: it moves far faster than the release channel.
      package = pkgsUnstable.claude-code;
      mcpServers = {
        vikunja = {
          type = "stdio";
          command = "${vikunja-mcp}/bin/vikunja-mcp";
        };
      };
    };
  };
}
