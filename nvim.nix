{ config, pkgs, ... }:

{
  
  home.packages = with pkgs; [ yaml-language-server ];

  programs.neovim = {
    enable = true;

    extraConfig = ''
      nnoremap <C-J> <C-W><C-J>
      nnoremap <C-K> <C-W><C-K>
      nnoremap <C-L> <C-W><C-L>
      nnoremap <C-H> <C-W><C-H>

      colorscheme dracula

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
      dracula-nvim

      {
        config = ''
          require'nvim-treesitter.configs'.setup {
            highlight = {
              enable = true,
            },
          }
        '';
        plugin = (nvim-treesitter.withPlugins (plugins:
          with pkgs.tree-sitter-grammars; [
            tree-sitter-bash
            tree-sitter-go
            tree-sitter-gomod
            tree-sitter-hcl
            tree-sitter-nix
            tree-sitter-yaml
          ]));
        type = "lua";
      }
   ];

    viAlias = true;
    vimAlias = true;
  };
}
