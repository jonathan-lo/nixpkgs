{ inputs, ... }:
{
  flake.modules.nixos.budu =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        ./_hardware-configuration.nix
      ];
    };
}
