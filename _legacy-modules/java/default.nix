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

      # language servers
      jdt-language-server
      kotlin-language-server
    ];

    programs.java = {
      enable = true;
      package = pkgs.zulu21;
    };

    home.file.".ideavimrc".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixpkgs/_legacy-modules/java/.ideavimrc";
  };
}
