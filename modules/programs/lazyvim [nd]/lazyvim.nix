{ inputs, ... }:
{
  flake.modules.homeManager.lazyvim =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      treesitterParsers = [
        "bash"
        "c"
        "cpp"
        "go"
        "gomod"
        "helm"
        "hcl"
        "java"
        "kotlin"
        "lua"
        "make"
        "markdown"
        "markdown_inline"
        "nix"
        "python"
        "query"
        "rust"
        "terraform"
        "toml"
        "typescript"
        "vim"
        "vimdoc"
        "yaml"
      ];

      grammarsPath = pkgs.symlinkJoin {
        name = "nvim-treesitter-grammars";
        paths =
          (pkgs.vimPlugins.nvim-treesitter.withPlugins (
            plugins: map (name: plugins.${name}) treesitterParsers
          )).dependencies;
      };
    in
    {
      home.sessionVariables = {
        NVIM_APPNAME = "lazyvim";
        NVIM_TREESITTER_PARSERS = "${grammarsPath}";
      };

      home.packages = with pkgs; [
        codesnap
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

      programs.zsh.shellAliases = {
        vi = "nvim";
      };

      # externally managed lazyvim config
      xdg.configFile."lazyvim/".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixpkgs/modules/programs/lazyvim [nd]/lazyvim";
    };
}
