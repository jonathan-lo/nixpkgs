{ config, pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home = {
    packages = with pkgs; [
        fira-code
        jq
        tcpdump
        yq-go
    ];

    stateVersion = "22.05";
    username = "jlo";
    homeDirectory  = "/home/jlo";
  };

#
#  settings = {
#    git.email = "jchl027@gmail.com";
#  };
}