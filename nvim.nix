{ config, pkgs, ... }:

{
  
  home.packages = with pkgs; [ rnix-lsp yaml-language-server ];

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

    {
        config = ''
          require'nvim-treesitter.configs'.setup {
            textobjects = {
              select = {
                enable = true,
                lookahead = true,
                keymaps = {
                  ["af"] = "@function.outer",
                  ["if"] = "@function.inner",
                },
              },
            },
          }
        '';

        plugin = nvim-treesitter-textobjects;
        type = "lua";
      }

      # required by cmp for snippets.
      luasnip

      {
        config = ''
          local cmp = require'cmp'

          cmp.setup({
            mapping = cmp.mapping.preset.insert({
              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<C-e>'] = cmp.mapping.abort(),
              ['<CR>'] = cmp.mapping.confirm({ select = true }),
            }),

            snippet = {
              expand = function(args)
                require'luasnip'.lsp_expand(args.body)
              end,
            },

            sources = cmp.config.sources({
              { name = 'nvim_lsp' },
            })
          })
        '';

        plugin = nvim-cmp;
        type = "lua";
      }

      # required by lspconfig for completion.
      cmp-nvim-lsp

      {
        config = ''
          local cmp_caps = require'cmp_nvim_lsp'.default_capabilities()

          require'lspconfig'.gopls.setup{
            capabilities = cmp_caps,
            settings = {
              gopls = {
                gofumpt = true,
                staticcheck = true,
              },
            },
          }

          require'lspconfig'.rnix.setup{
            capabilities = cmp_caps,
          }

          require'lspconfig'.yamlls.setup{
            capabilities = cmp_caps,
            settings = {
              yaml = {
                schemas = {
                  kubernetes = "/*",
                },
              },
            },
          }

          local opts = {buffer=bufnr, noremap=true, silent=true}
          vim.keymap.set('n', '<C-]>', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, opts)
          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        '';

        plugin = nvim-lspconfig;
        type = "lua";
      }

      {
        config = ''
          require('telescope').load_extension('fzy_native')
        '';

        plugin = telescope-fzy-native-nvim;
        type = "lua";
      }

      {

        config = ''
          local builtin = require('telescope.builtin')
          vim.keymap.set('n', '<C-p>', builtin.find_files, {})
          vim.keymap.set('n', 'rg', builtin.live_grep, opts)
        '';

        plugin = telescope-nvim;
        type = "lua";
      }

      vim-commentary
      vim-go
      vim-fugitive
      vim-surround
   ];

	  viAlias = true;
    vimAlias = true;
  };
}
