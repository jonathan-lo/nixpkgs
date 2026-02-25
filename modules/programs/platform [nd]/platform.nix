{ inputs, ... }:
{
  flake.modules.homeManager.platform = { pkgs, ... }: {
    home.packages = with pkgs; [
      unstable.istioctl
      unstable.kubebuilder
      #open-policy-agent
      operator-sdk
      tilt
    ];
  };
}
