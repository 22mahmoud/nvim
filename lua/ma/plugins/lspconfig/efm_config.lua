local util = require("lspconfig/util")
local custom_attach = require("ma.lspconfig.custom_attach")

local prettier = {
  formatCommand = "./node_modules/.bin/prettier --stdin --stdin-filepath ${INPUT}",
  formatStdin = true
}

local eslint_d = {
  lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
  lintStdin = true,
  lintFormats = {"%f:%l:%c: %m"},
  lintIgnoreExitCode = true,
  formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
  formatStdin = true
}

local luafmt = {
  formatCommand = "luafmt -i 2 -l 80 --stdin",
  formatStdin = true
}

local languages = {
  typescript = {prettier, eslint_d},
  javascript = {prettier, eslint_d},
  typescriptreact = {prettier, eslint_d},
  javascriptreact = {prettier, eslint_d},
  css = {prettier},
  scss = {prettier},
  json = {prettier},
  html = {prettier},
  lua = {luafmt}
}

local efmConfig = {
  root_dir = util.root_pattern(".git", vim.fn.getcwd()),
  on_attach = function(client, bufnr)
    custom_attach(client, bufnr)
    client.resolved_capabilities.document_formatting = true
  end,
  filetypes = vim.tbl_keys(languages),
  init_options = {documentFormatting = true, codeAction = true},
  settings = {
    rootMarkers = {"package.json", ".git"},
    lintDebounce = 500,
    languages = languages
  }
}

return efmConfig
