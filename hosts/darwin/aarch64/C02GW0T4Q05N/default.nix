{ pkgs, ... }: {

  nix.settings = rec {
    cores = 1;
    max-jobs = cores;
  };
  system = "aarch64-darwin";
  modules = {
    shell = {
      direnv.enable = true;
    };
  };
}
