{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    ktlint
    tflint
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
      nnoremap <C-H> <C-u>zz

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

  # fork for externally managed lazyvim config
  xdg.configFile."lazyvim-new/".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixpkgs/modules/lazyvim/lazyvim-new";
}
