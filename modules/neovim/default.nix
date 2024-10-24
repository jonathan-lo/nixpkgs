{ config, pkgs, ... }:

let unstablePlugins = pkgs.unstable.vimPlugins; in
{

  home.packages = with pkgs; [
    unstable.helm-ls
    yaml-language-server
  ];

  programs.neovim = {
    enable = true;

    extraConfig = ''
      let mapleader = "\<Space>"
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

      # github clipboard link
      nvim-osc52
      {
        config = builtins.readFile ./lua/plugins/gitlinker-nvim.lua;
        plugin = gitlinker-nvim;
        type = "lua";
      }
      {
        config = builtins.readFile ./lua/plugins/gitsigns-nvim.lua;
        plugin = gitsigns-nvim;
        type = "lua";
      }
      {
        config = builtins.readFile ./lua/plugins/nvim-treesitter.lua;
        plugin = (nvim-treesitter.withPlugins (plugins:
          with plugins; [
            tree-sitter-go
            tree-sitter-gomod
            tree-sitter-hcl
            tree-sitter-java
            tree-sitter-kotlin
            tree-sitter-lua
            tree-sitter-make
            tree-sitter-nix
            tree-sitter-rust
            tree-sitter-toml
            tree-sitter-vim
            tree-sitter-yaml
          ]));
        type = "lua";
      }

      {
        config = builtins.readFile ./lua/plugins/nvim-treesitter-textobjects.lua;
        plugin = nvim-treesitter-textobjects;
        type = "lua";
      }

      # required by cmp for snippets.
      luasnip

      {
        config = builtins.readFile ./lua/plugins/lualine-nvim.lua;
        plugin = lualine-nvim;
        type = "lua";
      }

      {

        config = builtins.readFile ./lua/plugins/nvim-cmp.lua;
        plugin = nvim-cmp;
        type = "lua";
      }

      # required by lspconfig for completion.
      cmp-nvim-lsp

      {
        config = builtins.readFile ./lua/plugins/nvim-lspconfig.lua;
        plugin = nvim-lspconfig;
        type = "lua";
      }

      {
        config = ''
          local api = require("nvim-tree.api")
          require("nvim-tree").setup()
          vim.keymap.set('n', '<A-1>', api.tree.toggle, opts)
        '';

        plugin = nvim-tree-lua;
        type = "lua";
      }
      nvim-web-devicons

      {
        config = ''
          require('telescope').load_extension('fzy_native')
        '';

        plugin = telescope-fzy-native-nvim;
        type = "lua";
      }

      {

        config = builtins.readFile ./lua/plugins/telescope-nvim.lua; 
        plugin = telescope-nvim;
        type = "lua";
      }

      plenary-nvim


      refactoring-nvim
      vim-commentary
      vim-fugitive
      unstablePlugins.vim-go
      vim-helm
      vim-surround
      vim-tmux-navigator


    ];

    viAlias = true;
    vimAlias = true;
  };

  xdg.configFile."nvim/lua" = {
    recursive = true;
    source = ./lua;
  };
}
