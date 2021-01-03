local lspconfig = require "lspconfig"
local configs = require "lspconfig/configs"
local completion = require "completion"
local utils = require "utils"

local on_attach = function(client)
  local resolved_capabilities = client.resolved_capabilities
  completion.on_attach(client)

  local opts = {noremap = true, silent = true}
  utils.map("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  utils.map("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
  utils.map("n", "ga", "<Cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  utils.map("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
  utils.map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  utils.map("n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  utils.map("n", "gr", "<cmd>lua require'telescope.builtin'.lsp_references()<CR>", opts)
  utils.map("n", "<leader>ld", "<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>", opts)
  utils.map("n", "[c", "<cmd> lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
  utils.map("n", "]c", "<cmd> lua vim.lsp.diagnostic.goto_next()<CR>", opts)

  utils.augroup(
    "LSP",
    function()
      vim.api.nvim_command("autocmd CursorHold <buffer> lua vim.lsp.diagnostic.show_line_diagnostics()")

      if resolved_capabilities.document_highlight then
        vim.api.nvim_command("autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()")
        vim.api.nvim_command("autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()")
        vim.api.nvim_command("autocmd CursorMoved <buffer> lua vim.lsp.util.buf_clear_references()")
      end
    end
  )
end

local system_name
if vim.fn.has("mac") == 1 then
  system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
  system_name = "Linux"
elseif vim.fn.has("win32") == 1 then
  system_name = "Windows"
else
  print("Unsupported system for sumneko")
end

local home = vim.fn.expand("$HOME")
local sumneko_root_path = home .. "/repos/lua-language-server"
local sumneko_binary = sumneko_root_path .. "/bin/" .. system_name .. "/lua-language-server"

local servers = {
  bashls = {},
  vimls = {},
  tsserver = {},
  jsonls = {},
  clangd = {},
  svelte = {},
  jedi_language_server = {},
  intelephense = {},
  dockerls = {},
  html = {},
  sumneko_lua = {
    cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
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
        }
      }
    }
  },
  vuels = {},
  cssls = {},
  gopls = {
    cmd = {"gopls", "serve"},
    settings = {
      gopls = {
        analyses = {
          unusedparams = true
        },
        staticcheck = true
      }
    }
  }
}

for server, config in pairs(servers) do
  lspconfig[server].setup(vim.tbl_deep_extend("force", {on_attach = on_attach}, config))
end
