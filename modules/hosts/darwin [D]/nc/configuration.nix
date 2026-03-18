{ inputs, ... }:
{
  flake.modules.darwin."Jonathans-MacBook-Pro" = {
    imports = with inputs.self.modules.darwin; [
      determinate
      system-minimal
      nix-darwin
      nixpkgsConfig
      logseq
      rectangle
      home-manager
      cli
      homebrew
    ];

    system.stateVersion = 5;
  };
}
