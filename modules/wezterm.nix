{ config, lib, pkgs, ... }:

with lib;

let cfg = config.settings.wezterm;
in {
  options.settings.wezterm = {
    fontName = mkOption {
      description = "the font family that will be used by wezterm";
      example = "wingdings";
      default = "FiraMono Nerd Font Mono";
      type = types.str;
    };
  };

  config.programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = ''
    local config = {}

    config.color_scheme = "Catppuccin Mocha"
    config.enable_tab_bar = false
    config.font_size = 16.0

    return config
    '';
  };
}
