{
  inputs,
  lib,
  ...
}:
# When flake-file is available, this module will configure it
# to generate flake.nix from modules using import-tree.
# Until Phase 4, this is a no-op.
if inputs ? flake-file then
{
  imports = [ inputs.flake-file.flakeModules.default ];

  flake-file.inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-file.url = "github:vic/flake-file";
    import-tree.url = "github:vic/import-tree";
  };

  flake-file.outputs = ''
    inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules)
  '';
}
else
{
  # No-op until flake-file is added as input (Phase 4)
}
