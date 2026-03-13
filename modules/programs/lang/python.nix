
{ inputs, ... }:
{
  flake.modules.homeManager.python =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        unstable.uv
      ];
    };
}
