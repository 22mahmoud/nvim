local root_pattern = require('lspconfig/util').root_pattern
local lsp = require 'ma.lsp'

lsp.setup {
  html = {},
  cssls = {},
  pyright = {},
  vimls = {},
  tsserver = {
    on_attach = function(client, bufnr)
      lsp.on_attach(client, bufnr)

      client.resolved_capabilities.document_formatting = false
    end,
    root_dir = root_pattern(
      'package.json',
      'tsconfig.json',
      'jsconfig.json',
      '.git',
      vim.fn.getcwd()
    ),
  },
  eslint = {},
  -- @see https://github.com/22mahmoud/dotfiles/blob/main/efm-langserver/.config/efm-langserver/config.yaml
  efm = {
    init_options = {
      documentFormatting = true,
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
  jsonls = {
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
  sumneko_lua = {
    cmd = { 'lua-language-server' },
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
          path = vim.tbl_deep_extend(
            'force',
            vim.split(package.path, ';'),
            { 'lua/?.lua', 'lua/?/init.lua' }
          ),
        },
        diagnostics = {
          globals = { 'vim' },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file('', true),
        },
        telemetry = {
          enable = false,
        },
      },
    },
  },
}
