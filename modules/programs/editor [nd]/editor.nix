{ inputs, ... }:
{
  flake.modules.homeManager.editor = { pkgs, ... }: {
    home.packages = with pkgs; [
      exercism
      vscode
    ];
  };
}
