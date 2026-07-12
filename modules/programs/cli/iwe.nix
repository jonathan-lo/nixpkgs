
{ inputs, ... }:
{
  # https://iwe.md/
  flake.modules.homeManager.iwe =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        iwe
      ];
    };
}
