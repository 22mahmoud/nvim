local sign_define = vim.fn.sign_define
local utils = require "utils"

vim.lsp.handlers["textDocument/publishDiagnostics"] =
  vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  {
    underline = false,
    signs = true,
    update_in_insert = true,
    virtual_text = {
      spacing = 4,
      prefix = "~"
    }
  }
)

vim.api.nvim_command(
  "autocmd CursorHold <buffer> lua vim.lsp.diagnostic.show_line_diagnostics()"
)

vim.api.nvim_command(
  "autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()"
)

vim.api.nvim_command(
  "autocmd CursorMoved <buffer> lua vim.lsp.util.buf_clear_references()"
)

sign_define(
  "LspDiagnosticsSignError",
  {text = "", texthl = "LspDiagnosticsError"}
)

sign_define(
  "LspDiagnosticsSignWarning",
  {text = "", texthl = "LspDiagnosticsWarning"}
)

sign_define(
  "LspDiagnosticsSignInformation",
  {text = "כֿ", texthl = "LspDiagnosticsInformation"}
)

sign_define(
  "LspDiagnosticsSignHint",
  {text = "➤", texthl = "LspDiagnosticsHint"}
)
