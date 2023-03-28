{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    #unstable.awscli2
    awscli2
    amazon-ecr-credential-helper
#    ssm-session-manager-plugin
  ];
}
