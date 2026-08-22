# home-manager's fonts.fontconfig has no rendering options, so the policy goes
# in a fontconfig snippet. Full hinting snaps stems to the pixel grid, which is
# what a 162 dpi panel needs: hintslight keeps the true shapes but renders soft.
{ ... }:
{
  xdg = {
    configFile = {
      "fontconfig-rendering" = {
        target = "fontconfig/conf.d/11-rendering.conf";
        text = ''
          <?xml version="1.0"?>
          <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
          <fontconfig>
            <match target="font">
              <edit name="hintstyle" mode="assign">
                <const>hintfull</const>
              </edit>
            </match>
          </fontconfig>
        '';
      };
    };
  };
}
