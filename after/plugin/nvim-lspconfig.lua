local root_pattern = require('lspconfig/util').root_pattern
local dirname = require('lspconfig/util').path.dirname
local lsp = require 'ma.lsp'

lsp.setup {
  html = {},
  cssls = {},
  ccls = {},
  pyright = {},
  vimls = {},
  bashls = {},
  tailwindcss = {},
  gopls = {},
  tsserver = {
    on_attach = function(client, bufnr)
      lsp.on_attach(client, bufnr)

      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false

      local last
      G.augroup('TSLspImportOnCompletion', {
        {
          events = { 'CompleteDone' },
          targets = { '<buffer>' },
          command = function()
            local completed_item = vim.v.completed_item
            if
              not (
                completed_item
                and completed_item.user_data
                and completed_item.user_data.nvim
                and completed_item.user_data.nvim.lsp
                and completed_item.user_data.nvim.lsp.completion_item
              )
            then
              return
            end

            local item = completed_item.user_data.nvim.lsp.completion_item
            if last == item.label then
              return
            end

            last = item.label
            vim.defer_fn(function()
              last = nil
            end, 5000)

            vim.lsp.buf_request(
              bufnr,
              'completionItem/resolve',
              item,
              function(_, result)
                if not (result and result.additionalTextEdits) then
                  return
                end

                vim.lsp.util.apply_text_edits(
                  result.additionalTextEdits,
                  bufnr,
                  'utf-8'
                )
              end
            )
          end,
        },
      })
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
      'lua',
      'html',
      'sh',
    },
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
          globals = { 'vim', 'G' },
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
