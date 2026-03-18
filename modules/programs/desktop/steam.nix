{ ... }:
{
  flake.allowedUnfreePackages = [
    "steam"
    "steam-original"
    "steam-unwrapped"
    "steam-run"
  ];

  flake.modules.nixos.steam =
    { ... }:
    {
      programs.steam.enable = true;
    };
}
