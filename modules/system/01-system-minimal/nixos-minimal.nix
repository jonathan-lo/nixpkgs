{
  inputs,
  ...
}:
{
  # default settings needed for all nixosConfigurations
  flake.modules.nixos.system-minimal =
    {
      pkgs,
      ...
    }:
    {
      nix.settings = {
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

        experimental-features = [
          "nix-command"
          "flakes"
          # "allow-import-from-derivation"
        ];

        download-buffer-size = 1024 * 1024 * 1024;

        # Collect unreachable paths during builds once free space runs low; the
        # weekly nix.gc below is what expires old generations.
        min-free = 10 * 1024 * 1024 * 1024;
        max-free = 50 * 1024 * 1024 * 1024;

        # Hardlink identical files as they land in the store
        auto-optimise-store = true;

        trusted-users = [
          "root"
        ];
      };

      nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };

      nix.extraOptions = ''
        warn-dirty = false
        keep-outputs = true
      '';
    };
}
