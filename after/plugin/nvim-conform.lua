local loaded = pcall(require, 'conform')

if not loaded then return end

local util = require 'conform.util'

require('conform').setup {
  formatters_by_ft = {
    yaml = { 'yamlfmt' },
    lua = { 'stylua' },
    go = { 'goimports', 'gofmt' },
    javascript = { 'prettierd', lsp_format = 'fallback' },
    html = { 'prettierd', lsp_format = 'fallback' },
    css = { 'prettierd', lsp_format = 'fallback' },
    typescript = { 'prettierd', lsp_format = 'fallback' },
    json = { 'prettierd', lsp_format = 'fallback' },
    jsonc = { lsp_format = 'fallback' },
    javascriptreact = { 'prettierd', lsp_format = 'fallback' },
    typescriptreact = { 'prettierd', lsp_format = 'fallback' },
    xslt = { 'prettierd' },
    sh = { 'shfmt' },
  },

  formatters = {
    prettierd = {
      require_cwd = true,
      cwd = function(files, ctx)
        local has_biome = util.root_file { 'biome.json' }(files, ctx)

        if has_biome then return nil end

        return util.root_file {
          '.prettierrc',
          '.prettierrc.json',
          '.prettierrc.yml',
          '.prettierrc.yaml',
          '.prettierrc.json5',
          '.prettierrc.js',
          '.prettierrc.cjs',
          '.prettierrc.mjs',
          '.prettierrc.toml',
          'prettier.config.js',
          'prettier.config.cjs',
          'prettier.config.mjs',
          'package.json',
        }(files, ctx)
      end,
    },
  },
}

G.nnoremap(',f', function() require('conform').format { bufnr = 0 } end)
