{ inputs, ... }:
{
  flake.modules.homeManager.postman =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        unstable.postman
      ];
    };
}
