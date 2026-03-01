# modules/hosts/budu [N]/budu.nix
{ inputs, config, ... }:
let
  determinate = inputs.determinate;
  nixpkgs = inputs.nixpkgs;

  overlay = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = prev.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };

  nixPkgsConfig = {
    overlays = [ overlay ];
    config.allowUnfree = true;
  };
in
{
  flake.nixosConfigurations.budu = nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    modules = [
      determinate.nixosModules.default
      config.flake.modules.nixos.home-manager
      config.flake.modules.nixos.cli
      {
        nixpkgs = nixPkgsConfig;
        home-manager.users.jlo.imports = with config.flake.modules.homeManager; [
          ../../../hosts/linux/budu/home.nix
          ai
          aws
          bash
          bat
          bitwarden
          btop
          calibre
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
      ../../../hosts/linux/budu/configuration.nix
    ];
  };
}
