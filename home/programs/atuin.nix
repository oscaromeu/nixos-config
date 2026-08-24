# Shell history with search and sync, replacing ctrl-r.
{ ... }:
{
  programs = {
    atuin = {
      enable = true;
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
