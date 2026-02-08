rebuild := if os() == "linux" { 
  "sudo nixos-rebuild" 
} else if os() == "windows" { 
  "home-manager" 
} else { 
  "sudo ./result/sw/bin/darwin-rebuild"
}

# apply nix configuration based on OS
[linux]
apply:
    {{ rebuild }} switch --flake

[macos]
apply:
    {{ rebuild }} switch --flake .

[windows]
apply:
    {{ rebuild }} --extra-experimental-features 'nix-command flakes'

[macos]
build:
    nix build .#darwinconfigurations."jonathans-macbook-pro".system

# print system os
system-info:
    @echo "{{ os() }}"


lint:
  nixfmt .
