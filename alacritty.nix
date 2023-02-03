{ config, lib, pkgs, ... }:

with lib;

let cfg = config.settings.alacritty;
in {
  options.settings.alacritty = {
    fontName = mkOption {
      description = "the font family that will be used by alacritty";
      example = "wingdings";
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

        normal = {
          black = "#282828";
          blue = "#458588";
          cyan = "#689d6a";
          green = "#98971a";
          magenta = "#b16286";
          red = "#cc241d";
          white = "#a89984";
          yellow = "#d79921";
        };

        bright = {
          black = "#928374";
          blue = "#83a598";
          cyan = "#8ec07c";
          green = "#b8bb26";
          magenta = "#d3869b";
          red = "#fb4934";
          white = "#ebdbb2";
          yellow = "#fabd2f";
        };
      };

      font = {
        bold = { family = cfg.fontName; };
        italic = { family = cfg.fontName; };
        normal = {
          family = cfg.fontName;
          style = "Regular";
        };
        size = 12;
      };
    };
  };
}
