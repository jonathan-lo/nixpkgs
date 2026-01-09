# apply nix configuration based on OS
[linux]
apply:
  sudo nixos-rebuild switch --flake

[macos]
apply:
  nix build \
    --extra-experimental-features 'nix-command flakes' \
    .#darwinConfigurations."Jonathans-MacBook-Pro".system
  sudo ./result/sw/bin/darwin-rebuild switch --impure --flake .

[windows]
apply:
  export NIXPKGS_ALLOW_BROKEN=1
  home-manager switch --flake .#$(hostname) \
    --extra-experimental-features 'nix-command flakes'

# print system os 
system-info:
  @echo "{{os()}}
