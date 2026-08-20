{ ... }:
let

  browser = [ "firefox.desktop" ];
  images = [ "imv.desktop" ];
  pdf = [ "org.pwmt.zathura.desktop" ];
  video = [ "mpv.desktop" ];

  assoc = {
    "text/html" = browser;
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/about" = browser;
    "x-scheme-handler/unknown" = browser;

    "image/gif" = images;
    "image/jpeg" = images;
    "image/png" = images;
    "image/webp" = images;

    "application/pdf" = pdf;

    "video/mp4" = video;
    "video/webm" = video;
    "video/x-matroska" = video;
  };

in
{
  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = assoc;
      associations = {
        added = assoc;
      };
    };
  };
}
