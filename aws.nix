{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    unstable.awscli2
    amazon-ecr-credential-helper
  ];
}
