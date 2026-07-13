{ ... }:
{
  # https://iwe.md/
  # Installed via homebrew because nixpkgs lags well behind upstream releases.
  flake.modules.darwin.iwe = {
    homebrew = {
      taps = [ "iwe-org/iwe" ];
      brews = [ "iwe-org/iwe/iwe" ];
    };
  };
}
