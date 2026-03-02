{ inputs, config, ... }:
let
  inherit (inputs) darwin catppuccin;

  overlay = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = prev.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };

  overlays = [ overlay ];

  nixPkgsConfig = {
    inherit overlays;
    config.allowUnfree = true;
  };
in
{
  flake.darwinConfigurations."Jonathans-MacBook-Pro" = darwin.lib.darwinSystem {
    system = "aarch64-darwin";

    specialArgs = { inherit inputs; };

    modules = [
      config.flake.modules.darwin.nix
      config.flake.modules.darwin.home-manager
      config.flake.modules.darwin.cli
      {
        nixpkgs = nixPkgsConfig;
        home-manager.users.jlo.imports = with config.flake.modules.homeManager; [
          ../../../../hosts/darwin/nc/home.nix
          ai
          aws
          bash
          bat
          btop
          cli
          direnv
          docker
          editor
          firefox
          fzf
          gcp
          go
          java
          kubernetes
          node
          ops
          git
          platform
          ripgrep
          theming
          tmux
          zoxide
          zsh
          ghostty
          lazyvim
        ];
      }
      ../../../../hosts/darwin/homebrew.nix
      ../../../../hosts/darwin/services.nix
      ../../../../hosts/darwin/settings.nix
    ];
  };
}
