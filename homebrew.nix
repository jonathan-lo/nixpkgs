# this seems to be only available through nix-darwin and not home-manager.
{ ... }: {

  homebrew = {
    enable = true;

    onActivation = {
      # Keep things deterministic.
      autoUpdate = false;

      # Properly uninstall all things not managed by Nix homebrew.
      cleanup = "zap";

      # Upgrade during activation.
      upgrade = false;
    };

    # Use the Brewfile in the Nix store everywhere.
    global = {
      brewfile = true;
      lockfiles = true;
    };

    extraConfig = ''
      cask_args require_sha: true
    '';

    taps = [
      "homebrew/cask"
      "homebrew/core"
      "homebrew/services"
      "homebrew/cask-fonts"
    ];
  };

  # No thanks.
#  env.HOMEBREW_NO_ANALYTICS = "1";
}
