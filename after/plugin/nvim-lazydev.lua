local loaded = pcall(require, 'lazydev')

if not loaded then return end

require('lazydev').setup {
  runtime = vim.env.VIMRUNTIME --[[@as string]],
  integrations = {
    lspconfig = true,
    cmp = false,
    coq = false,
  },
  library = {
    { path = 'luvit-meta/library', words = { 'vim%.uv' } },
  },
}

require('lazydev').find_workspace(0)
