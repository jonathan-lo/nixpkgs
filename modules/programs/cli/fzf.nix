{ inputs, ... }:
{
  flake.modules.homeManager.fzf =
    { ... }:
    {
      programs.fzf = {
        enable = true;
        defaultCommand = "rg --files";
        tmux.enableShellIntegration = true;
      };
    };
}
