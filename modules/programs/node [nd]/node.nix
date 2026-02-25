{ inputs, ... }:
{
  flake.modules.homeManager.node = { pkgs, ... }: {
    home.packages = with pkgs; [
      bun
    ];
  };
}
