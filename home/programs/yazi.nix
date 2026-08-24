{
  pkgs,
  color,
  ...
}:
with pkgs;
{
  programs = {
    yazi = {
      enable = true;
      initLua = ./init.lua;
      # Breeze palette from config/color.nix; anything unset keeps the default
      theme = {
        mgr = {
          cwd = {
            fg = color.h_blue;
            bold = true;
          };
          hovered = {
            fg = color.h_background;
            bg = color.h_blue;
          };
          preview_hovered = {
            underline = true;
          };
          find_keyword = {
            fg = color.h_bright_yellow;
            bold = true;
          };
          find_position = {
            fg = color.h_bright_purple;
          };
          marker_copied = {
            fg = color.h_green;
            bg = color.h_green;
          };
          marker_cut = {
            fg = color.h_red;
            bg = color.h_red;
          };
          marker_marked = {
            fg = color.h_cyan;
            bg = color.h_cyan;
          };
          marker_selected = {
            fg = color.h_bright_yellow;
            bg = color.h_bright_yellow;
          };
          border_symbol = "│";
          border_style = {
            fg = color.h_bright_black;
          };
        };
        status = {
          separator_open = "";
          separator_close = "";
        };
        # By file type; first match wins
        filetype = {
          rules = [
            {
              url = "*/";
              fg = color.h_blue;
              bold = true;
            }
            {
              mime = "image/*";
              fg = color.h_bright_yellow;
            }
            {
              mime = "{audio,video}/*";
              fg = color.h_bright_purple;
            }
            {
              mime = "application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*}";
              fg = color.h_bright_red;
            }
            {
              url = "*";
              is = "orphan";
              fg = color.h_red;
            }
            {
              url = "*";
              is = "exec";
              fg = color.h_green;
            }
            {
              url = "*";
              fg = color.h_foreground;
            }
          ];
        };
      };
      plugins = with pkgs.yaziPlugins; {
        bookmarks = bookmarks;
        git = git;
        mediainfo = mediainfo;
      };
      keymap = {
        input.prepend_keymap = [
          {
            run = "noop";
            on = [ "q" ];
          }
          {
            run = "close";
            on = [ "w" ];
          }
          {
            run = "close --submit";
            on = [ "W" ];
          }
          {
            run = "escape";
            on = [ "<Esc>" ];
          }
          {
            run = "backspace";
            on = [ "<Backspace>" ];
          }
        ];
        mgr.prepend_keymap = [
          {
            run = "noop";
            on = [ "q" ];
          }
          {
            run = "escape";
            on = [ "<Esc>" ];
          }
          {
            run = "quit";
            on = [ "<C-q>" ];
          }
          {
            run = "close";
            on = [ "w" ];
          }
          {
            run = "cd $HOME";
            desc = "Go Home";
            on = [
              "g"
              "h"
            ];
          }
          {
            run = "cd $HOME/.config";
            desc = "Go Config";
            on = [
              "g"
              "c"
            ];
          }
          {
            run = "cd $HOME/.local";
            desc = "Go Local";
            on = [
              "g"
              "l"
            ];
          }
          {
            run = "cd $XDG_DOCUMENTS_DIR";
            desc = "Go Documents";
            on = [
              "g"
              "d"
            ];
          }
          {
            run = "cd $XDG_DOWNLOAD_DIR";
            desc = "Go Download";
            on = [
              "g"
              "o"
            ];
          }
          {
            run = "cd $XDG_MUSIC_DIR";
            desc = "Go Music";
            on = [
              "g"
              "m"
            ];
          }
          {
            run = "cd $XDG_PICTURES_DIR";
            desc = "Go Pictures";
            on = [
              "g"
              "p"
            ];
          }
          {
            run = "cd $XDG_VIDEOS_DIR";
            desc = "Go Videos";
            on = [
              "g"
              "v"
            ];
          }
          {
            on = [ "m" ];
            run = "plugin bookmarks save";
            desc = "Save current position as a bookmark";
          }
          {
            on = [ "'" ];
            run = "plugin bookmarks jump";
            desc = "Jump to a bookmark";
          }
          {
            on = [
              "b"
              "d"
            ];
            run = "plugin bookmarks delete";
            desc = "Delete a bookmark";
          }
          {
            on = [
              "b"
              "D"
            ];
            run = "plugin bookmarks delete_all";
            desc = "Delete all bookmarks";
          }
        ];
      };
      settings = {
        log = {
          enabled = false;
        };
        mgr = {
          ratio = [
            2
            4
            3
          ];
          show_hidden = false;
          sort_by = "alphabetical";
          linemode = "size";
          sort_dir_first = true;
          sort_reverse = false;
        };
        preview = {
          tab_size = 4;
          image_filter = "nearest";
          max_width = 1920;
          max_height = 1080;
          image_quality = 90;
        };
        plugin = {
          prepend_preloaders = [
            {
              mime = "image/svg+xml";
              run = "mediainfo";
            }
            {
              mime = "{audio,video,image}/*";
              run = "mediainfo";
            }
            {
              mime = "application/subrip";
              run = "mediainfo";
            }
            {
              mime = "application/postscript";
              run = "mediainfo";
            }
          ];
          prepend_previewers = [
            {
              mime = "image/svg+xml";
              run = "mediainfo";
            }
            {
              mime = "{audio,video,image}/*";
              run = "mediainfo";
            }
            {
              mime = "application/subrip";
              run = "mediainfo";
            }
            {
              mime = "application/postscript";
              run = "mediainfo";
            }
          ];
        };
        opener = {
          edit = [
            {
              run = ''nvim "$@"''; # by name: Super+E starts yazi with no shell, so no $EDITOR
              block = true;
              desc = "Edit";
              for = "unix";
            }
          ];
          compress-zip = [
            {
              run = ''${ouch}/bin/ouch compress "$@" "$@.zip"'';
              desc = "Compress zip";
              for = "unix";
            }
          ];
          compress-gzip = [
            {
              run = ''${ouch}/bin/ouch compress "$@" "$@.tar.gz"'';
              desc = "Compress tar.gz";
              for = "unix";
            }
          ];
          encrypt = [
            {
              run = ''${gnupg}/bin/gpg -c "$@"'';
              desc = "Encrypt";
              for = "unix";
            }
          ];
          decrypt = [
            {
              run = ''${gnupg}/bin/gpg "$@"'';
              desc = "Decrypt";
              for = "unix";
            }
          ];
          open = [
            {
              run = ''${xdg-utils}/bin/xdg-open "$@"'';
              desc = "Open";
              for = "linux";
            }
          ];
          reveal = [
            {
              run = ''${xdg-utils}/bin/xdg-open $(dirname "$1")'';
              desc = "Reveal";
              for = "linux";
            }
          ];
          extract = [
            {
              run = ''${ouch}/bin/ouch decompress -y "$@"'';
              desc = "Extract";
              for = "unix";
            }
          ];
          play = [
            {
              run = ''${mpv}/bin/mpv "$@"'';
              orphan = true;
              desc = "Play";
              for = "unix";
            }
          ];
          shred = [
            {
              run = ''${coreutils}/bin/shred -zfun 5 "$@"'';
              desc = "Shred";
              for = "unix";
            }
          ];
        };
        open = {
          rules = [
            {
              url = "*/";
              use = [
                "edit"
                "compress-zip"
                "compress-gzip"
              ];
            }
            {
              mime = "text/*";
              use = [
                "edit"
              ];
            }
            {
              mime = "image/*";
              use = [
                "open"
              ];
            }
            {
              mime = "{audio,video}/*";
              use = [
                "play"
              ];
            }
            {
              url = "*.kra";
              use = [
                "open"
              ];
            }
            {
              url = "*.blend";
              use = [
                "open"
              ];
            }
            {
              mime = "application/{json,ndjson}";
              use = [
                "edit"
              ];
            }
            {
              mime = "*/javascript";
              use = [
                "edit"
              ];
            }
            {
              mime = "inode/empty";
              use = [
                "edit"
              ];
            }
            {
              mime = "application/vnd.oasis.opendocument.*";
              use = [
                "open"
              ];
            }
            {
              mime = "application/pdf";
              use = [
                "open"
              ];
            }
            {
              mime = "application/epub+zip";
              use = [
                "open"
              ];
            }
            {
              url = "*.gpg";
              use = [
                "decrypt"
              ];
            }
            {
              mime = "application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}";
              use = [
                "extract"
                "open"
                "encrypt"
                "shred"
              ];
            }
            {
              url = "*";
              use = [
                "edit"
                "play"
                "encrypt"
                "shred"
              ];
            }
          ];
        };
      };
    };
  };
}
