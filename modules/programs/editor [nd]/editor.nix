{ inputs, ... }:
{
  flake.allowedUnfreePackages = [ "vscode" ];

  flake.modules.homeManager.editor =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        exercism
      ];

      #      programs.zed-editor.enable = true;
    };
}
