{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.bitwarden;
in
{
  options.modules.bitwarden = {
    enable = mkOption {
      description = "Enable Bitwarden password manager";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bitwarden-desktop
      bitwarden-cli
    ];
  };
}
