local loaded = pcall(require, 'lspconfig')

if not loaded then
  return
end

local root_pattern = require('lspconfig/util').root_pattern
local dirname = require('lspconfig/util').path.dirname

local lsp = require 'ma.lsp'

lsp.setup {
  html = {},
  cssls = {},
  clangd = {
    on_attach = function(client, bufnr)
      lsp.on_attach(client, bufnr)
      client.server_capabilities.semanticTokensProvider = nil
    end,
  },
  pyright = {},
  vimls = {},
  bashls = {},
  svelte = {},
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
    on_attach = function(client, bufnr)
      lsp.on_attach(client, bufnr)

      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
    root_dir = function(fname)
      return root_pattern(
        'tsconfig.json',
        'package.json',
        'jsconfig.json',
        '.git'
      )(fname) or dirname(fname)
    end,
  },
  eslint = {},

  jsonls = {
    on_attach = function(client, bufnr)
      lsp.on_attach(client, bufnr)

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
    on_attach = function(client, bufnr)
      lsp.on_attach(client, bufnr)

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
    settings = ...,
    root_dir = require('lspconfig').util.root_pattern { '.git/', '.' },
    filetypes = {
      'javascript',
      'javascriptreact',
      'typescriptreact',
      'typescript',
      'css',
      'scss',
      'json',
      'jsonc',
      'lua',
      'html',
      'sh',
      'graphql',
      'svg',
    },
    init_options = {
      documentFormatting = true,
    },
  },
}
