{ ... }:
let

  chrome = "/usr/bin/google-chrome-stable";
  flags = "--ozone-platform-hint=auto --force-device-scale-factor=1.75";

in
{
  xdg = {
    desktopEntries = {
      google-chrome = {
        name = "Google Chrome";
        genericName = "Web Browser";
        exec = "${chrome} ${flags} %U";
        icon = "google-chrome";
        terminal = false;
        type = "Application";
        startupNotify = true;
        categories = [
          "Network"
          "WebBrowser"
        ];
        mimeType = [
          "application/pdf"
          "application/rdf+xml"
          "application/rss+xml"
          "application/xhtml+xml"
          "application/xhtml_xml"
          "application/xml"
          "image/gif"
          "image/jpeg"
          "image/png"
          "image/webp"
          "text/html"
          "text/xml"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
          "x-scheme-handler/google-chrome"
        ];
        settings = {
          StartupWMClass = "google-chrome";
        };
        actions = {
          new-window = {
            name = "New Window";
            exec = "${chrome} ${flags}";
          };
          new-private-window = {
            name = "New Incognito Window";
            exec = "${chrome} ${flags} --incognito";
          };
        };
      };
    };
  };
}
