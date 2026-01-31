{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.java;
in
{
  options.modules.java = {
    enable = mkOption {
      description = "Enable Java development tools";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      maven
    ];

    programs.java = {
      enable = true;
      package = pkgs.zulu21;
    };

    home.file.".ideavimrc".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixpkgs/modules/java/.ideavimrc";
  };
}
