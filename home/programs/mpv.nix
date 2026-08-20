{
  pkgs,
  ...
}:
with pkgs;
{
  programs = {
    mpv = {
      enable = true;
      scripts = with mpvScripts; [
        mpris
      ];
      config = {
        force-window = "yes";
        fullscreen = "no";
        osc = "yes";
        profile = "fast";
        save-position-on-quit = "yes";
        cache = "yes";
        demuxer-max-bytes = "150MiB";
        cache-secs = 120;
        demuxer-readahead-secs = 120;
      };
    };
  };
}
