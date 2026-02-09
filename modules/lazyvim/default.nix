{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    lua-language-server
    markdownlint-cli2
    nixd
    statix # nix linting
    tree-sitter

    yaml-language-server
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;

    extraConfig = ''
      let mapleader = "\<Space>"
      nnoremap <C-J> <C-W><C-J>
      nnoremap <C-K> <C-W><C-K>
      nnoremap <C-L> <C-W><C-L>
      nnoremap <C-H> <C-W><C-H>
      nnoremap <C-d> <C-d>zz
      nnoremap <C-u> <C-u>zz

      set autoindent
      set autoread
      set colorcolumn=100
      set cursorline
      set nobackup
      set nohlsearch
      set number relativenumber
      set smartindent
      set splitbelow
      set splitright
      set tabstop=2 shiftwidth=2 expandtab
      set termguicolors
      set wildignore+=**/.git/*
    '';

    plugins = with pkgs.vimPlugins; [
      lazy-nvim
    ];

    viAlias = true;
    vimAlias = true;
  };

  # https://github.com/nvim-treesitter/nvim-treesitter#i-get-query-error-invalid-node-type-at-position
  home.file.".config/lazyvim-new/parser".source =
    let
      parsers = pkgs.symlinkJoin {
        name = "treesitter-parsers";
        paths =
          (pkgs.vimPlugins.nvim-treesitter.withPlugins (
            plugins: with plugins; [
              bash
              c
              cpp
              go
              gomod
              helm
              hcl
              java
              kotlin
              lua
              make
              markdown
              nix
              python
              rust
              terraform
              toml
              typescript
              vim
              vimdoc
              yaml
            ]
          )).dependencies;
      };
    in
    "${parsers}/parser";

  # externally managed lazyvim config
  xdg.configFile."lazyvim-new/".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixpkgs/modules/lazyvim/lazyvim-new";
}
