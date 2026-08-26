{ inputs, ... }:
{
  # Merges into the `ai` module; pi itself is installed in ai.nix.
  flake.modules.homeManager.ai = {
    imports = [ inputs.pi-catppuccin.homeManagerModules.default ];

    # Flavor is not set here: the upstream module reads `catppuccin.flavor` from the
    # catppuccin/nix module (theming.nix) whenever that one is enabled, so pi follows
    # the same flavor as the rest of the system. The module drops the theme into
    # ~/.pi/agent/themes and selects it in pi's settings.json on activation.
    programs.pi.catppuccin.enable = true;
  };
}
