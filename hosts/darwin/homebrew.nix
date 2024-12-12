{ pkgs, config, ... }:

{
  environment.systemPath = [ config.homebrew.brewPrefix ];

  homebrew = {
    enable = true;
    brews = [
      "bash"
      "coreutils"
      "findutils"
    ];
    casks = [
      "alacritty"
      "obsidian"
      "rectangle"
    ];

    extraConfig = ''
      cask_args require_sha: true
    '';

    global = {
      brewfile = true;
      lockfiles = true;
    };

    onActivation = {
      autoUpdate = false;
      cleanup = "none"; # move this back to zap once lima situation is sorted.
      upgrade = false;
    };

    taps = [
      "homebrew/cask-fonts"
      "homebrew/services"
    ];
  };
}
