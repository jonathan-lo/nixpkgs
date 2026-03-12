{ inputs, ... }:
{
  flake.modules.homeManager.ops =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        terraform
        terraform-ls
        tflint
      ];
    };
}
