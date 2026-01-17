rebuild := if os() == "linux" { "sudo nixos-rebuild" } else { "sudo ./result/sw/bin/darwin-rebuild switch" }

# apply nix configuration based on OS
[linux]
apply:
    {{ rebuild }} switch --flake

[macos]
apply:
    nix build \
      .#darwinConfigurations."Jonathans-MacBook-Pro".system
    sudo ./result/sw/bin/darwin-rebuild switch --impure --flake .

[windows]
apply:
    home-manager switch --flake .#$(hostname) \
      --extra-experimental-features 'nix-command flakes'

# print system os
system-info:
    @echo "{{ os() }}"
