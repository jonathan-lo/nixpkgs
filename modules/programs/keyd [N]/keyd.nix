# modules/programs/keyd [N]/keyd.nix
{ inputs, lib, config, ... }:
{
  # override capslock with control on hold and escape on tap
  flake.modules.nixos.keyd = { config, pkgs, ... }: {
    services.keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = [ "*" ];
          settings = {
            main = {
              capslock = "overload(control, escape)";
            };
            otherlayer = { };
          };
        };
      };
    };
  };
}
