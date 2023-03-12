{ pkgs, ... }: {
  nix.settings = rec {
    cores = 1;
    max-jobs = cores;
  };

  modules = {
    shell = {
      direnv.enable = true;
    };
  };
}
