{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    terraform

    # language server / linting
    terraform-ls
    tflint
  ];
}
