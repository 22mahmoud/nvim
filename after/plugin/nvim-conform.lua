local loaded = pcall(require, 'conform')

if not loaded then return end

require('conform').setup {
  formatters_by_ft = {
    yaml = { 'yamlfmt' },
    lua = { 'stylua' },
    go = { 'goimports', 'gofmt' },
    javascript = { 'prettierd' },
    html = { 'prettierd' },
    css = { 'prettierd' },
    typescript = { 'prettierd' },
    json = { 'prettierd' },
    javascriptreact = { 'prettierd' },
    typescriptreact = { 'prettierd' },
    xslt = { 'prettierd' },
    sh = { 'shfmt' },
  },
}

G.nnoremap(',f', function() require('conform').format { bufnr = 0 } end)
