local lspconfig = require("lspconfig")
local root_pattern = require("lspconfig/util").root_pattern
local custom_attach = require("ma.plugins.lspconfig.custom_attach")
local sumneko_client = require("ma.plugins.lspconfig.sumneko_client")

local sumneko_binary = sumneko_client.sumneko_binary
local sumneko_root_path = sumneko_client.sumneko_root_path

lspconfig.sumneko_lua.setup {
  cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
  on_attach = custom_attach,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        globals = {'vim', 'use'},
      },
      workspace = {
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
      },
      telemetry = {
        enable = false,
      },
    },
  },
}

lspconfig.tsserver.setup {
  on_attach = custom_attach,
  root_dir = root_pattern(
    "package.json",
    "tsconfig.json",
    "jsconfig.json",
    ".git",
    vim.fn.getcwd()
  ),
}

lspconfig.sumneko_lua.setup {
  cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
  on_attach = custom_attach,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        globals = {'vim', 'use'},
      },
      workspace = {
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
      },
      telemetry = {
        enable = false,
      },
    },
  },
}

lspconfig.html.setup {
  on_attach = custom_attach
}

lspconfig.cssls.setup {
  on_attach = custom_attach
}
