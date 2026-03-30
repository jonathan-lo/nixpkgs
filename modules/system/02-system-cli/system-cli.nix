{
  inputs,
  ...
}:
{
  # import all essential nix-tools which are used in all modules of a specific class

  flake.modules.nixos.system-cli = {
    imports = with inputs.self.modules.nixos; [
      system-minimal
      home-manager
    ];
  };

  flake.modules.darwin.system-cli = {
    imports = with inputs.self.modules.darwin; [
      system-minimal
      determinate
      home-manager
      homebrew
    ];
  };

  # impermanence is not added by default to home-manager, because of missing Darwin implementation
  # for linux home-manager stand-alone configurations it has to be added manualy

  flake.modules.homeManager.system-cli = {
    imports = with inputs.self.modules.homeManager; [
      system-minimal
    ];
  };
}
