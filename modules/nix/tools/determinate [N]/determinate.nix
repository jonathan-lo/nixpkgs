# modules/nix/tools/determinate [N]/determinate.nix
{ inputs, ... }:
{
  flake.modules.nixos.determinate =
    { ... }:
    {
      imports = [ inputs.determinate.nixosModules.default ];
    };
}
