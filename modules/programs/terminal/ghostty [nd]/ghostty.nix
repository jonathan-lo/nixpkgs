{ inputs, ... }:
{
  flake.modules.homeManager.ghostty =
    { config, pkgs, ... }:
    {
      # ghostty-bin ships the official signed Ghostty.dmg (byte-identical to the
      # homebrew cask); the source `ghostty` package is linux-only.
      programs.ghostty = {
        enable = true;
        package = if pkgs.stdenv.hostPlatform.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;
        # on macOS ghostty injects shell integration from its own bundle
        enableZshIntegration = pkgs.stdenv.hostPlatform.isLinux;
      };
      xdg.configFile."ghostty".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixpkgs/modules/programs/terminal/ghostty [nd]";
    };
}
