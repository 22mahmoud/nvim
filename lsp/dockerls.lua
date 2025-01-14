---@type vim.lsp.Config
return {
  cmd = { 'docker-langserver', '--stdio' },
  root_markers = { 'Dockerfile' },
  filetypes = { 'dockerfile' },
}
