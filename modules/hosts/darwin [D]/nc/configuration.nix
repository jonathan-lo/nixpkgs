{ inputs, ... }:
{
  flake.modules.darwin."Jonathans-MacBook-Pro" = {
    imports = with inputs.self.modules.darwin; [
      nix
      nix-darwin
      nixpkgsConfig
      logseq
      rectangle
      home-manager
      cli
      homebrew
      jlo
    ];

    system.stateVersion = 5;

    home-manager.users.jlo = {
      imports = with inputs.self.modules.homeManager; [
        nix-darwin
      ];
    };
  };
}
