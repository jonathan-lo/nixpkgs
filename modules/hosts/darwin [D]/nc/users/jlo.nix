{
  inputs,
  ...
}:
{
  flake.modules.darwin."Jonathans-MacBook-Pro" = {
    imports = with inputs.self.modules.darwin; [
      jlo
    ];

    home-manager.users.jlo =
      { config, ... }:
      {
        imports = with inputs.self.modules.homeManager; [
          #
        ];

        home.sessionPath = [
          "${config.home.homeDirectory}/bin"
        ];
      };
  };
}
