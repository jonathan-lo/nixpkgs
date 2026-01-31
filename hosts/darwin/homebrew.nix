{ pkgs, config, ... }:

{
  environment.systemPath = [ config.homebrew.brewPrefix ];

  homebrew = {
    enable = true;
    brews = [
      "bash"
      "coreutils"
      "findutils"
      "node"
    ];
    casks = [
      "ghostty"
      "google-chrome"
      "logseq"
      "zed"
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
    ];
  };
}
