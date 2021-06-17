local custom_attach = require("ma.plugins.lspconfig.custom_attach")

local fmt = string.format
local os = jit.os
local cache_dir = vim.fn.stdpath("cache")

local sumneko_root_path =
  fmt("%s/lspconfig/sumneko_lua/lua-language-server", cache_dir)

local sumneko_binary =
  fmt("%s/bin/%s/lua-language-server", sumneko_root_path, os)

local sumneko_command = function()
  return {
    sumneko_binary,
    "-E",
    fmt("%s/main.lua", sumneko_root_path),
    sumneko_root_path .. "/main.lua"
  }
end

local sumneko_config  = {
  cmd = sumneko_command(),
  on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = false
    custom_attach(client, bufnr)
  end,
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

return sumneko_config
