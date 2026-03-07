{
  inputs,
  ...
}:
{
  flake.modules.nixos.budu = {
    imports = with inputs.self.modules.nixos; [
      jlo
    ];
  };
}
