{
  inputs,
  ...
}:
# nix-darwin input declarations for flake-file
if inputs ? flake-file then
{
  flake-file.inputs = {
    darwin.url = "github:lnl7/nix-darwin/nix-darwin-25.11";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };
}
else
{
  # No-op until flake-file is added (Phase 4)
}
