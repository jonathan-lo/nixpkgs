{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.calibre;
in
{
  options.modules.calibre = {
    enable = mkOption {
      description = "Enable Calibre e-book manager";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      calibre
    ];
  };
}
