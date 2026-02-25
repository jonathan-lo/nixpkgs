{ inputs, ... }:
{
  flake.modules.homeManager.ripgrep = { config, pkgs, ... }:
    let
      configPath = config.home.homeDirectory + "/.config/ripgrep/ripgreprc";
    in
    {
      home = {
        packages = with pkgs; [ ripgrep ];
        sessionVariables = {
          RIPGREP_CONFIG_PATH = configPath;
        };
      };

      xdg.configFile."ripgrep/ripgreprc".text = ''
        --glob
        !*.tfstate
      '';
    };
}
