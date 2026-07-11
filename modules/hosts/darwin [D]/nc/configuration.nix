{ inputs, ... }:
{
  flake.modules.darwin."Jonathans-MacBook-Pro" = {
    imports = with inputs.self.modules.darwin; [
      determinate
      system-minimal
      nix-darwin
      nixpkgsConfig
      rectangle
      home-manager
      cli
      homebrew
      karabiner
      ai
    ];

    system.stateVersion = 5;
  };
}
