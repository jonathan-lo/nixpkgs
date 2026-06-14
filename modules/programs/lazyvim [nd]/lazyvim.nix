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

      # Pin the helm tree-sitter grammar to a revision whose anonymous tokens
      # still match the queries shipped by our pinned nvim-treesitter plugin
      # (lazyvim plugin commit 42fc28ba, lockfile gotmpl rev 5f19a36). Upstream
      # ngalaiko/tree-sitter-go-template later split "else if" into separate
      # "else" and "if" tokens, which breaks queries/helm/highlights.scm
      # (inherits gotmpl).
      helmGrammar = pkgs.vimPlugins.nvim-treesitter.passthru.builtGrammars.helm.overrideAttrs (_: {
        src = pkgs.fetchFromGitHub {
          owner = "ngalaiko";
          repo = "tree-sitter-go-template";
          rev = "5f19a36bb1eebb30454e277b222b278ceafed0dd";
          hash = "sha256-apZ5yhWzLxaJFxMcuugNTuCxdDUxhKTZecZFsvjyqdo=";
        };
      });
      helmGrammarPlugin = pkgs.vimPlugins.nvim-treesitter.passthru.grammarToPlugin helmGrammar;

      grammarsPath = pkgs.symlinkJoin {
        name = "nvim-treesitter-grammars";
        paths =
          (pkgs.vimPlugins.nvim-treesitter.withPlugins (
            plugins: map (name: plugins.${name}) treesitterParsers
          )).dependencies
          ++ [ helmGrammarPlugin ];
      };
    in
    {
      home.sessionVariables = {
        NVIM_APPNAME = "lazyvim";
        NVIM_TREESITTER_PARSERS = "${grammarsPath}";
      }
      // (
        if pkgs.stdenv.isDarwin then
          {
            DYLD_FALLBACK_LIBRARY_PATH = "${pkgs.pcre2.out}/lib";
          }
        else
          {
            LD_LIBRARY_PATH = "${pkgs.pcre2.out}/lib";
          }
      );

      home.packages = with pkgs; [
        codesnap
        helm-ls
        lua-language-server
        pcre2
        markdownlint-cli2
        nixd
        statix # nix linting
        tree-sitter

        yaml-language-server
      ];

      programs.neovim = {
        enable = true;
        defaultEditor = true;
        withRuby = false;
        withPython3 = false;

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
