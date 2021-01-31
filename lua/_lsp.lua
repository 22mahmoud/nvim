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
  root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git", vim.fn.getcwd())
}

local eslint_d = {
  lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
  lintStdin = true,
  lintFormats = {"%f:%l:%c: %m"},
  lintIgnoreExitCode = true,
  formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
  formatStdin = true
}

servers.efm = {
  root_dir = util.root_pattern(".git", vim.fn.getcwd()),
  filetypes = {
    "javascript",
    "typescript",
    "typescriptreact",
    "javascriptreact"
  },
  init_options = {
    documentFormatting = true,
    codeAction = true
  },
  settings = {
    languages = {
      typescript = {eslint_d},
      javascript = {eslint_d},
      typescriptreact = {eslint_d},
      javascriptreact = {eslint_d}
    }
  }
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
