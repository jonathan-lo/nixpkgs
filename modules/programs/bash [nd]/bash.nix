{ inputs, ... }:
{
  flake.modules.homeManager.bash = { pkgs, ... }: {
    programs.bash.enable = true;
  };
}
