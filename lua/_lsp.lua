local lspconfig = require("lspconfig")
local nlua = require("nlua.lsp.nvim")
local util = require("lspconfig/util")
local map = vim.api.nvim_set_keymap

local mapper = function(mode, key, result)
  vim.api.nvim_buf_set_keymap(0, mode, key, "<cmd>lua " .. result .. "<cr>", {noremap = true, silent = true})
end

-- use volta(a node version manager) as node provider
if vim.fn.executable("volta") then
  vim.g.node_host_prog = vim.fn.trim(vim.fn.system("volta which neovim-node-host"))
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local custom_attach = function(_, buf_nr)
  require("lspfuzzy").setup {}
  vim.api.nvim_buf_set_option(buf_nr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  local filetype = vim.api.nvim_buf_get_option(0, "filetype")
  if filetype ~= "lua" then
    mapper("n", "K", "vim.lsp.buf.hover()")
  end

  mapper("n", "ga", "vim.lsp.buf.code_action()")
  mapper("n", "gr", "vim.lsp.buf.references()")
  mapper("n", "gd", "vim.lsp.buf.definition()")
  mapper("n", "gD", "vim.lsp.buf.implementation()")
  mapper("n", "<leader>r", "vim.lsp.buf.rename()")

  -- diagnostic
  map("n", "<leader>dd", ":LspDiagnostics 0<CR>", {noremap = true, silent = true})
  mapper("n", "<leader>dn", "vim.lsp.diagnostic.goto_next()")
  mapper("n", "<leader>dn", "vim.lsp.diagnostic.goto_next()")
  mapper("n", "<leader>dp", "vim.lsp.diagnostic.goto_prev()")
  mapper("n", "<leader>ds", "vim.lsp.diagnostic.show_line_diagnostics()")
end

nlua.setup(
  lspconfig,
  {
    on_attach = custom_attach,
    globals = {
      "use"
    }
  }
)

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
  vuels = {},
  cssls = {}
}

servers.gopls = {
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

servers.tsserver = {
  root_dir = function(fname)
    return util.find_git_ancestor(fname) or util.path.dirname(fname)
  end
}

for server, config in pairs(servers) do
  lspconfig[server].setup(
    vim.tbl_deep_extend(
      "force",
      {
        on_attach = custom_attach,
        capabilities = capabilities
      },
      config
    )
  )
end
