{ config, lib, pkgs, ... }:

with lib;

let cfg = config.settings.alacritty;
in {
  options.settings.alacritty = {
    fontName = mkOption {
      description = "the font family that will be used by alacritty";
      example = "wingdings";
      default = "FiraMono Nerd Font Mono";
      type = types.str;
    };
  };

  config.programs.alacritty = {
    enable = true;
    settings = {
      colors = {
        primary = {
          background = "#282a36";
          foreground = "#f8f8f2";
          bright_foreground = "#ffffff";
        };

        cursor = {
          text = "CellBackground";
          cursor = "CellForeground";
        };

        vi_mode_cursor = {
          text = "CellBackground";
          cursor = "CellForeground";
        };

        search = {
          matches = {
            foreground = "#44475a";
            background = "#50fa7b";
          };

          focused_match = {
            foreground = "#44475a";
            background = "#ffb86c";
          };
        };

        footer_bar = {
          foreground = "#f8f8f2";
          background = "#282a36";
        };

        hints = {
          start = {
            foreground = "#282a36";
            background = "#f1fa8c";
          };
          end = {
            foreground = "#f1fa8c";
            background = "#282a36";
          };
        };

        line_indicator = {
          foreground = "None";
          background = "None";
        };

        selection = {
          text = "CellForeground";
          background = "#44475a";
        };

        normal = {
          black = "#21222c";
          red = "#ff5555";
          green = "#50fa7b";
          yellow = "#f1fa8c";
          blue = "#bd93f9";
          magenta = "#ff79c6";
          cyan = "#8be9fd";
          white = "#f8f8f2";
        };

        bright = {
          black = "#6272a4";
          red = "#ff6e6e";
          green = "#69ff94";
          yellow = "#ffffa5";
          blue = "#d6acff";
          magenta = "#ff92df";
          cyan = "#a4ffff";
          white = "#ffffff";
        };
      };

      font = {
        bold = { family = cfg.fontName; };
        italic = { family = cfg.fontName; };
        normal = {
          family = cfg.fontName;
          style = "Regular";
        };
        offset = {
          x = 0;
          y = 1;
        };
        glyph_offset = {
          x = 0;
          y = 1;
        };
        size = 15;
      };
    };
  };
}
