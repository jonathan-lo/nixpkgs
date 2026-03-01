rebuild := if os() == "linux" { 
  "sudo nixos-rebuild" 
} else if os() == "windows" { 
  "home-manager" 
} else { 
  "sudo darwin-rebuild"
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

# setup claude LSP plugins
# declarative approach not currently supported
# https://github.com/anthropics/claude-code/issues/21340
claude-lsp:
  claude plugin marketplace update claude-plugins-official
  claude plugin install gopls-lsp || true
  claude plugin install jdtls-lsp || true
  claude plugin install kotlin-lsp || true

zcomp-regenerate:
  rm ~/.zcompdump* && compinit
