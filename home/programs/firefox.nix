# Privacy settings from swayhome; Firefox Sync still works.
{ profile, ... }:
{
  programs = {
    firefox = {
      enable = true;
      profiles = {
        ${profile.name} = {
          isDefault = true;
          search = {
            default = "ddg";
            force = true;
            privateDefault = "ddg";
          };
          settings = {
            "browser.aboutConfig.showWarning" = false;
            "browser.compactmode.show" = true;
            "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
            "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
            "browser.newtabpage.activity-stream.feeds.snippets" = false;
            "browser.newtabpage.activity-stream.feeds.topsites" = false;
            "browser.newtabpage.activity-stream.showSearch" = false;
            "browser.sessionstore.resume_session_once" = true;
            "browser.shell.checkDefaultBrowser" = false;
            "browser.translations.automaticallyPopup" = false;
            "browser.warnOnQuit" = false;
            "devtools.theme" = "dark";
            "gfx.webrender.all" = true;
            "media.ffmpeg.vaapi.enabled" = true;
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          };
        };
      };
      policies = {
        CaptivePortal = false;
        DisableAppUpdate = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        FirefoxHome = {
          Pocket = false;
          Snippets = false;
        };
        UserMessaging = {
          ExtensionRecommendations = false;
          SkipOnboarding = true;
        };
      };
    };
  };
}
