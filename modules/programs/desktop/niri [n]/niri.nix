{ ... }:
{
  flake.modules.homeManager.niri =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      configDir = "${config.home.homeDirectory}/.config/nixpkgs/modules/programs/desktop/niri [n]/config";
    in
    lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      home.packages = [ pkgs.noctalia-shell ];

      # GDM exposes Niri as a separate session. These sources stay writable so
      # compositor and shell settings can be adjusted without rebuilding.
      xdg.configFile = {
        "niri/config.kdl".source =
          config.lib.file.mkOutOfStoreSymlink "${configDir}/niri/config.kdl";
        "noctalia/settings.json".source =
          config.lib.file.mkOutOfStoreSymlink "${configDir}/noctalia/settings.json";
      };
    };
}
