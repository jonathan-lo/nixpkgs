{
  inputs,
  ...
}:
{
  # default settings needed for all darwinConfigurations

  flake.modules.darwin.system-minimal =
    {
      pkgs,
      ...
    }:
    {
      nix.enable = false;
      determinateNix.enable = true;

      # nix-darwin's nix.gc.* lives in the module disabled by nix.enable = false,
      # so scheduled collection is determinate-nixd's job instead
      determinateNix.determinateNixd.garbageCollector.strategy = "automatic";

      # Custom settings written to /etc/nix/nix.custom.conf
      determinateNix.customSettings = {
        # Enables parallel evaluation (remove this setting or set the value to 1 to disable)
        eval-cores = 0;

        # Disable global registry
        flake-registry = "";

        lazy-trees = true;
        warn-dirty = false;

        # Collect unreachable paths during builds once free space runs low, rather
        # than on a timer. Profile generations are never touched by this.
        min-free = 10 * 1024 * 1024 * 1024;
        max-free = 50 * 1024 * 1024 * 1024;

        # Hardlink identical files as they land in the store
        auto-optimise-store = true;

        experimental-features = [
          "nix-command"
          "flakes"
        ];

        extra-experimental-features = [
          "build-time-fetch-tree" # Enables build-time flake inputs
          "parallel-eval" # Enables parallel evaluation
        ];
        substituters = [
          # high priority since it's almost always used
          "https://cache.nixos.org?priority=10"
          "https://install.determinate.systems"
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM"
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };

      environment.systemPackages = with inputs.darwin.packages.${pkgs.stdenv.hostPlatform.system}; [
        darwin-option
        darwin-rebuild
        darwin-version
        darwin-uninstaller
      ];

    };
}
