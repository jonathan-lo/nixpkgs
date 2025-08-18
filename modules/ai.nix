{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    unstable.claude-code
    lazygit
  ];

  home.file.".claude/settings.json".text = ''{
      "includeCoAuthoredBy": false
    }
  '';
}

