{ inputs, ... }:
{
  flake.allowedUnfreePackages = [ "google-chrome" ];

  flake.modules.homeManager.browsers =
    { config, pkgs, ... }:
    let
      # firefox-devedition pinned via inputs.nixpkgs-firefox-devedition — see
      # the colocated flake-parts.nix for why.
      firefoxPinned = import inputs.nixpkgs-firefox-devedition {
        inherit (pkgs.stdenv.hostPlatform) system;
      };
    in
    {
      home.packages = with pkgs; [
        google-chrome
      ];

      programs.firefox = {
        enable = true;
        package = firefoxPinned.firefox-devedition;
        configPath = "${config.xdg.configHome}/mozilla/firefox";
        policies = {
          ExtensionSettings = {
            "uBlock0@raymondhill.net" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
              installation_mode = "force_installed";
            };
          };
        };
      };
    };
}
