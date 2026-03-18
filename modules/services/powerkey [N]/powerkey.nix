{ ... }:
{
  flake.modules.nixos.powerkey =
    { ... }:
    {
      # Disable power button
      services.logind.settings = {
        Login = {
          HandlePowerKey = "ignore";
        };
      };
    };
}
