local custom_attach = require("ma.lspconfig.custom_attach")

local prettier = {
  formatCommand = "./node_modules/.bin/prettier --stdin --stdin-filepath ${INPUT}",
  formatStdin = true
}

local eslint_d = {
  lintCommand = "eslint_d -f visualstudio --stdin --stdin-filename ${INPUT}",
  lintStdin = true,
  lintFormats = {"%f:%l:%c: %m"},
  lintIgnoreExitCode = true,
  formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
  formatStdin = true
}

local shellcheck = {
  lintCommand = "shellcheck --format=gcc --external-sources -",
  lintStdin = true,
  lintFormats = {
    "%f:%l:%c: %trror: %m",
    "%f:%l:%c: %tarning: %m",
    "%f:%l:%c: %tote: %m"
  },
  lintSource = "shellcheck"
}

local shfmt = {
  formatCommand = "shfmt -ci -s -bn -i 2",
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
  lua = {luafmt},
  sh = {shfmt, shellcheck},
  bash = {shfmt, shellcheck}
}

local efmConfig = {
  root_dir = vim.loop.cwd,
  on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = true
    custom_attach(client, bufnr)
  end,
  filetypes = vim.tbl_keys(languages),
  init_options = {documentFormatting = true},
  settings = {
    rootMarkers = {".git/", vim.loop.cwd()},
    languages = languages
  }
}

return efmConfig
