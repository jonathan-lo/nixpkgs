{ inputs, ... }:
{
  flake.modules.homeManager.ai = { pkgs, ... }: {
    home.packages = with pkgs; [
      unstable.claude-code
      unstable.uv
    ];

    home.file.".claude/settings.json".source = ./claude/settings.json;
  };
}
