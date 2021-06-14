local function get_system_name()
  if vim.fn.has("mac") == 1 then return "macOS" end

  if vim.fn.has("unix") == 1 then return "Linux" end

  print("unsupported system for sumneko")
  return
end

local sumneko_root_path =
  vim.fn.stdpath('cache')..'/lspconfig/sumneko_lua/lua-language-server'

local sumneko_binary =
  sumneko_root_path.."/bin/"..get_system_name().."/lua-language-server"

return {
  sumneko_root_path = sumneko_root_path,
  sumneko_binary = sumneko_binary
}

