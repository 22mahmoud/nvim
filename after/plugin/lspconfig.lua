local loaded, lspconfig = pcall(require, 'lspconfig')
if not loaded then return end

local root_pattern = require('lspconfig/util').root_pattern

local dirname = vim.fs.dirname

local function find_git(fname)
  return dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
end

local servers = {
  html = {},
  cssls = {},
  jdtls = {},
  astro = {},
  -- htmx = {},
  clangd = {
    on_attach = function(client) client.server_capabilities.semanticTokensProvider = nil end,
  },
  pyright = {},
  vimls = {},
  bashls = {
    filetypes = { 'bash' },
  },
  svelte = {},
  intelephense = {
    settings = {
      intelephense = {
        format = { enable = false },
      },
    },
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
  biome = {},
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
  ts_ls = {
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
}

local function get_client_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      'documentation',
      'detail',
      'additionalTextEdits',
    },
  }

  return capabilities
end

local function get_config_opts()
  return {
    capabilities = get_client_capabilities(),
    flags = {
      allow_incremental_sync = true,
      debounce_text_changes = 150,
    },
  }
end

local function setup()
  local config = get_config_opts()

  for server, user_config in pairs(servers) do
    local enabled = true
    if user_config.enable ~= nil then enabled = user_config.enable end

    if enabled then lspconfig[server].setup(vim.tbl_deep_extend('force', config, user_config)) end
  end
end

setup()
