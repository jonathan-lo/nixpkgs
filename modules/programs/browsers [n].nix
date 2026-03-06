{ ... }:
{
  flake.modules.homeManager.browsers = { pkgs, ... }: {
    home.packages = with pkgs; [
      google-chrome
      ungoogled-chromium
    ];
  };
}
