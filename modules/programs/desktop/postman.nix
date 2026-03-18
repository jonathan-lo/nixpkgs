{ inputs, ... }:
{
  flake.allowedUnfreePackages = [ "postman" ];

  flake.modules.homeManager.postman =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        unstable.postman
      ];
    };
}
