# Without this the host distro decides: Ubuntu defaults to RGB subpixel, which
# fringes glyph edges with colour. NixOS and GNOME both render grayscale, so
# declaring it here is what makes the two machines look the same.
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
              <edit name="antialias" mode="assign">
                <bool>true</bool>
              </edit>
              <edit name="hintstyle" mode="assign">
                <const>hintslight</const>
              </edit>
              <edit name="rgba" mode="assign">
                <const>none</const>
              </edit>
              <edit name="lcdfilter" mode="assign">
                <const>none</const>
              </edit>
            </match>
          </fontconfig>
        '';
      };
    };
  };
}
