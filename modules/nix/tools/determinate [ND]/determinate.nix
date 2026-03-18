{ inputs, ... }:
{
  flake.modules.nixos.determinate =
    { ... }:
    {
      imports = [ inputs.determinate.nixosModules.default ];
    };

  flake.modules.darwin.determinate =
    { ... }:
    {
      imports = [ inputs.determinate.darwinModules.default ];
      determinateNix.enable = true;
    };
}
