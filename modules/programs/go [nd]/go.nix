{ inputs, ... }:
{
  flake.modules.homeManager.go = { config, pkgs, ... }: {
    home.packages = with pkgs; [
      unstable.gofumpt
      unstable.gopls
    ];

    home.sessionPath = [
      "${config.home.homeDirectory}/go/bin"
    ];

    programs.go = {
      enable = true;
      package = pkgs.unstable.go;
    };
  };
}
