local loaded = pcall(require, 'lspconfig')

if not loaded then return end
local root_pattern = require('lspconfig/util').root_pattern
local find_git = require('lspconfig/util').find_git_ancestor
local dirname = require('lspconfig/util').path.dirname
local ma_lsp = require 'ma.lsp'

ma_lsp.setup {
  html = {},
  cssls = {},
  clangd = {
    on_attach = function(client) client.server_capabilities.semanticTokensProvider = nil end,
  },
  pyright = {},
  vimls = {},
  bashls = {},
  svelte = {},
  intelephense = {
    on_init = function(client)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
  },
  phpactor = {
    handlers = {
      ['textDocument/publishDiagnostics'] = function() end,
    },
  },
  graphql = {
    filetypes = {
      'javascript',
      'javascriptreact',
      'typescriptreact',
      'typescript',
      'graphql',
    },
  },
  tailwindcss = {
    settings = {
      tailwindCSS = {
        classAttributes = {
          'class',
          'className',
          'wrapperClassName',
        },
        experimental = {
          classRegex = {
            { 'cva\\(([^)]*)\\)', '["\'`]([^"\'`]*).*?["\'`]' },
            { 'vs\\(([^)]*)\\)', '["\'`]([^"\'`]*).*?["\'`]' },
            { 'clx\\(([^)]*)\\)', '["\'`]([^"\'`]*).*?["\'`]' },
            [[class= "([^"]*)]],
          },
        },
      },
    },
  },
  rust_analyzer = {},
  gopls = {},
  tsserver = {
    init_options = {
      hostInfo = 'neovim',
      preferences = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
    on_init = function(client)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
      client.server_capabilities.codeActionProvider = {
        codeActionKinds = {
          '',
          'quickfix',
          'source',
          'source.organizeImports',
          'refactor',
          'refactor.extract',
          'refactor.inline',
          'refactor.rewrite',
          'source.fixAll',
        },
      }
    end,
    root_dir = function(fname)
      return root_pattern('tsconfig.json', 'package.json', 'jsconfig.json')(fname)
        or find_git(fname)
        or dirname(fname)
        or vim.fn.getcwd()
    end,
  },
  eslint = {},

  jsonls = {
    on_attach = function(client)
      -- disable formatting in favor of using efm w/ prettier
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
    settings = {
      json = {
        schemas = require('schemastore').json.schemas(),
        validate = { enable = true },
      },
    },
  },
  yamlls = {
    settings = {
      yaml = {
        schemaStore = {
          enable = false,
          url = '',
        },
        schemas = require('schemastore').yaml.schemas(),
      },
    },
  },
  lua_ls = {
    on_attach = function(client)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
    settings = {
      Lua = {
        telemetry = {
          enable = false,
        },
      },
    },
  },

  --- @see https://github.com/22mahmoud/dotfiles/blob/main/efm-langserver/.config/efm-langserver/config.yaml
  efm = {
    root_dir = root_pattern { '.git/', '.' },
    init_options = { documentFormatting = true },
  },
}
