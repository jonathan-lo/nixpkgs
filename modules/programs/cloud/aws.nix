# modules/programs/aws [nd]/aws.nix
{ inputs, ... }:
{
  flake.modules.homeManager.aws =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        unstable.awscli2
        amazon-ecr-credential-helper
        ssm-session-manager-plugin
      ];
    };
}
