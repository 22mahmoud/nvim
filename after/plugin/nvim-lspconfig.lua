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
  clangd = {},
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
    settings = {
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = 'literal',
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = false,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
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
    commands = {
      OrganizeImports = {
        function()
          vim.lsp.buf_request(0, 'workspace/executeCommand', {
            command = '_typescript.organizeImports',
            arguments = { vim.api.nvim_buf_get_name(0) },
          })
        end,

        description = 'Organize imports',
      },
    },
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
        schemas = {
          {
            description = 'TypeScript compiler configuration file',
            fileMatch = {
              'tsconfig.json',
              'tsconfig.*.json',
            },
            url = 'https://json.schemastore.org/tsconfig.json',
          },
          {
            description = 'Babel configuration',
            fileMatch = {
              '.babelrc.json',
              '.babelrc',
              'babel.config.json',
            },
            url = 'https://json.schemastore.org/babelrc.json',
          },
          {
            description = 'ESLint config',
            fileMatch = {
              '.eslintrc.json',
              '.eslintrc',
            },
            url = 'https://json.schemastore.org/eslintrc.json',
          },
          {
            description = 'Prettier config',
            fileMatch = {
              '.prettierrc',
              '.prettierrc.json',
              'prettier.config.json',
            },
            url = 'https://json.schemastore.org/prettierrc',
          },
          {
            description = 'Stylelint config',
            fileMatch = {
              '.stylelintrc',
              '.stylelintrc.json',
              'stylelint.config.json',
            },
            url = 'https://json.schemastore.org/stylelintrc',
          },
          {
            description = 'Json schema for properties json file for a GitHub Workflow template',
            fileMatch = {
              '.github/workflow-templates/**.properties.json',
            },
            url = 'https://json.schemastore.org/github-workflow-template-properties.json',
          },
          {
            description = 'NPM configuration file',
            fileMatch = {
              'package.json',
            },
            url = 'https://json.schemastore.org/package.json',
          },
        },
      },
    },
    setup = {
      commands = {
        Format = {
          function()
            vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line '$', 0 })
          end,
        },
      },
    },
  },
  yamlls = {
    settings = {
      yaml = {
        hover = true,
        completion = true,
        validate = true,
        schemaStore = {
          enable = true,
          url = 'https://www.schemastore.org/api/json/catalog.json',
        },
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

  -- @see https://github.com/22mahmoud/dotfiles/blob/main/efm-langserver/.config/efm-langserver/config.yaml
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
