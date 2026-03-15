{ inputs, ... }:
{
  flake.modules.darwin.determinate =
    { ... }:
    {
      imports = [ inputs.determinate.darwinModules.default ];
      determinateNix.enable = true;
    };
}
