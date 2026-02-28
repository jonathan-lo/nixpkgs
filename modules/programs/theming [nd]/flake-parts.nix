{
  inputs,
  ...
}:
# Catppuccin theme input declarations for flake-file
if inputs ? flake-file then
{
  flake-file.inputs = {
    catppuccin.url = "github:catppuccin/nix";
  };
}
else
{
  # No-op until flake-file is added (Phase 4)
}
