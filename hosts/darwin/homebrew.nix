{ pkgs, config, ... }:

{
  environment.systemPath = [ config.homebrew.brewPrefix ];

  homebrew = {
    enable = true;
    brews = [
      "bash"
      "node"
    ];
    casks = [
      "ghostty"
      "google-chrome"
      "postman"
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
