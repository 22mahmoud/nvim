---@type vim.lsp.Config
return {
  cmd = { 'gdshader-lsp', '--stdio' },
  filetypes = { 'gdshader', 'gdshaderinc' },
  root_markers = { 'project.godot' },
}
