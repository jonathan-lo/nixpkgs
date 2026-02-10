{ pkgs, config, ... }:

{
  environment.systemPath = [ config.homebrew.brewPrefix ];

  homebrew = {
    enable = true;
    brews = [
      "node" # install via homebrew so can use npm to install mcps
    ];
    casks = [
      "ghostty"
      "google-chrome"
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
      cleanup = "zap"; # move this back to zap once lima situation is sorted.
      upgrade = false;
    };

    taps = [
    ];
  };
}
