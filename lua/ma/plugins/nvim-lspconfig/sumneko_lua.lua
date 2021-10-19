local root_pattern = require("lspconfig/util").root_pattern

local function get_sumneko_cmd()
  local os = jit.os
  local cache_dir = vim.fn.stdpath("cache")

  local sumneko_root_path =
    string.format("%s/lspconfig/sumneko_lua/lua-language-server", cache_dir)

  local sumneko_bin =
    string.format("%s/bin/%s/lua-language-server", sumneko_root_path, os)

  return {
    sumneko_bin,
    "-E",
    string.format("%s/main.lua", sumneko_root_path)
  }
end

return {
  cmd = get_sumneko_cmd(),
  root_dir = root_pattern(".git", vim.fn.getcwd()),
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        path = vim.split(package.path, ";")
      },
      diagnostics = {
        globals = {"vim"}
      },
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
        }
      },
      telemetry = {
        enable = false
      }
    }
  }
}
