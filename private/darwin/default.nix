{ config, pkgs, ... }:

{
  home = {
    sessionVariables = {
      NVIM_APPNAME = "lazyvim-new";
    };
  };
}
