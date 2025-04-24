---@type vim.lsp.Config
return {
  cmd = { 'phpactor', 'language-server' },
  filetypes = { 'php' },
  root_dir = G.root_dir { 'composer.json', '.git', '.phpactor.json', '.phpactor.yml' },
}
