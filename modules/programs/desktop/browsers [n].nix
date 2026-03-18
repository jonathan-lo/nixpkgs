{ ... }:
{
  flake.modules.homeManager.browsers =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        google-chrome
      ];

      programs.firefox = {
        enable = true;
        package = pkgs.firefox-devedition;
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
