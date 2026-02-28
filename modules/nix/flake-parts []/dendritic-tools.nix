{
  inputs,
  ...
}:
{
  # Setup of tools for dendritic pattern
  #
  # flake-parts: Simplify Nix Flakes with the module system
  # https://github.com/hercules-ci/flake-parts
  #
  # flake-file: Generate flake.nix from module options
  # https://github.com/vic/flake-file
  #
  # import-tree: Import all nix files in a directory tree
  # https://github.com/vic/import-tree

  imports = [
    inputs.flake-parts.flakeModules.modules
    inputs.flake-file.flakeModules.default
  ];

  flake-file.inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-file.url = "github:vic/flake-file";
    import-tree = {
      url = "github:vic/import-tree";
      flake = false;
    };
  };

  flake-file.outputs = ''
    inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } ((import inputs.import-tree) ./modules)
  '';
}
