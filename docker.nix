{ options, config, lib, pkgs, ... }:
with lib;
{
  config = (mkMerge [
    (if (builtins.hasAttr "homebrew" options) then {
      homebrew = {
        brews = [
          "lima"
        ];

        casks = [ "docker" ];
      };

      # Make the Lima VM Docker (Moby) socket available to the host.
      env.DOCKER_HOST = "unix://$HOME/.docker/docker.sock";
    } else { }
    )
  ]);

}
