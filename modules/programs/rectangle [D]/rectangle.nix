{ ... }:
{
  flake.modules.darwin.rectangle = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      rectangle
    ];

    launchd.user.agents.rectangle = {
      serviceConfig = {
        ProgramArguments = [ "${pkgs.rectangle}/Applications/Rectangle.app/Contents/MacOS/Rectangle" ];
        RunAtLoad = true;
        KeepAlive = false;
      };
    };
  };
}
