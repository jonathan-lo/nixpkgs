{
  inputs,
  ...
}:
{
  flake.modules.nixos.budu = {
    imports = with inputs.self.modules.nixos; [
      jlo
    ];

    home-manager.users.jlo = {
      imports = with inputs.self.modules.homeManager; [
        bitwarden
        calibre
      ];
    };
  };
}
