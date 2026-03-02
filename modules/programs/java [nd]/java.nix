# modules/programs/java [nd]/java.nix
{ inputs, ... }:
{
  flake.modules.homeManager.java = { config, pkgs, ... }: {
    home.packages = with pkgs; [
      maven

      # language servers
      jdt-language-server
      kotlin-language-server
    ];

    programs.java = {
      enable = true;
      package = pkgs.zulu21;
    };

    home.file.".ideavimrc".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixpkgs/modules/programs/java [nd]/.ideavimrc";
  };
}
