local port = os.getenv 'GDScript_Port' or '6005'

---@type vim.lsp.Config
return {
  cmd = vim.lsp.rpc.connect('127.0.0.1', tonumber(port)),
  filetypes = { 'gd', 'gdscript', 'gdscript3' },
  root_markers = { 'project.godot', '.git' },
}
