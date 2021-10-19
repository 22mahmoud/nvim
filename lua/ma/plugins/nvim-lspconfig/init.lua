local root_pattern = require('lspconfig/util').root_pattern
local lsp = require 'ma.plugins.nvim-lspconfig.config'

lsp.setup {
  html = {},
  cssls = {},
  tsserver = {
    root_dir = root_pattern(
      'package.json',
      'tsconfig.json',
      'jsconfig.json',
      '.git',
      vim.fn.getcwd()
    ),
  },
  eslint = {},
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
