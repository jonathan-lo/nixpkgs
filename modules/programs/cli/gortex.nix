{ ... }:
{
  # https://github.com/zzet/gortex
  # Installed via homebrew because nixpkgs lags well behind upstream releases.
  flake.modules.darwin.gortex = {
    homebrew = {
      taps = [ "zzet/tap" ];
      casks = [ "gortex" ];
    };
  };
}
