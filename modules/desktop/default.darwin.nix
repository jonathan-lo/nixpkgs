{ config, lib, pkgs, inputs, ... }:
with lib;
let
  cfg = config.modules.desktop;
  inherit (inputs.home-manager.lib.hm) dag;
  inherit (pkgs.stdenv.targetPlatform) isDarwin;
in
{
  options.modules.desktop = {
    sudoTouchID = mkOption {
      type = types.bool;
      description = ''
        Enable sudo touch ID (Darwin).
      '';
      default = false;
    };
  };

  config = mkIf cfg.enable (optionalAttrs isDarwin
    {
      # macOS Apps that aren't in nixpkgs.
      homebrew.casks = [
      ];

      # Fonts.
      fonts = {
        fontDir.enable = true;
      };

      # My default desktop system settings across all macOS/Darwin installs.
      system = {
        keyboard = {
          enableKeyMapping = true;
        };
      };
    }
  );
}
