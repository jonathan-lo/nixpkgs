{ inputs, ... }:
{
  flake.allowedUnfreePackages = [ "terraform" ];

  flake.modules.homeManager.ops =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        unstable.opentofu
        terraform
        terraform-ls
        tflint
      ];
    };
}
