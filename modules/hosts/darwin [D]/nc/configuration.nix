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
    ];

    users.users.jlo.home = "/Users/jlo";
    system.stateVersion = 5;
    system.primaryUser = "jlo";

    home-manager.users.jlo = {
      imports = with inputs.self.modules.homeManager; [
        nix-darwin
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

      home = {
        stateVersion = "22.05";
        username = "jlo";
      };
    };
  };
}
