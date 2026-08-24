# Shell history with search and sync, replacing ctrl-r.
{ pkgsUnstable, ... }:
{
  programs = {
    atuin = {
      enable = true;
      # From unstable: the sync record format must match every machine, and the
      # release channel lags behind the server.
      package = pkgsUnstable.atuin;
      settings = {
        sync_address = "https://sh.oscaromeu.io";
        sync_frequency = "0";
        search_mode = "fuzzy";
        enter_accept = true;
        sync = {
          records = true;
        };
      };
    };
  };
}
