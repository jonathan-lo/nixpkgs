{ self, lib, ... }:
{
  flake.modules = lib.mkMerge [
    (self.factory.user "jlo" true)
    {
      nixos.jlo = {
        users.users.jlo.extraGroups = [
          "docker"
          "networkmanager"
        ];
      };

      darwin.jlo = { };

      homeManager.jlo =
        { ... }:
        {
          imports = with self.modules.homeManager; [
            ai
            aws
            bash
            bat
            browsers
            btop
            cli
            direnv
            docker
            editor
            fzf
            git
            gcp
            ghostty
            go
            java
            kubernetes
            lazyvim
            node
            ops
            platform
            python
            ripgrep
            theming
            tmux
            zoxide
            zsh
          ];
          home.stateVersion = "22.05";
        };
    }
  ];
}
