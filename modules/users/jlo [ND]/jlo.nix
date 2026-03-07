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
            btop
            cli
            direnv
            docker
            editor
            firefox
            fzf
            gcp
            ghostty
            go
            java
            kubernetes
            lazyvim
            node
            ops
            git
            platform
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
