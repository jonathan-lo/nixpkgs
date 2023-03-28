{ pkgs, config, ... }:

{
  environment.systemPath = [ config.homebrew.brewPrefix ];

  homebrew = {
    enable = true;

    casks = [ "alacritty" ];

    extraConfig = ''
      cask_args require_sha: true
    '';

    global = {
      brewfile = true;
      lockfiles = true;
    };

    onActivation = {
      autoUpdate = false;
      cleanup = "zap";
      upgrade = false;
    };

    taps = [
      "homebrew/cask"
      "homebrew/cask-fonts"
      "homebrew/core"
      "homebrew/services"
    ];
  };
}
