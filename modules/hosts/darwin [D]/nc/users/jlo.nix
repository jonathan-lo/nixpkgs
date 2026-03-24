{
  inputs,
  ...
}:
{
  flake.modules.darwin."Jonathans-MacBook-Pro" = {
    imports = with inputs.self.modules.darwin; [
      jlo
    ];

    home-manager.users.jlo = {
      imports = with inputs.self.modules.homeManager; [
        #
      ];
    };
  };
}
