{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    unstable.claude-code
    unstable.uv # for running mcps
  ];

  home.file.".claude/settings.json".text = ''
    {
          "includeCoAuthoredBy": false
        }
  '';
}
