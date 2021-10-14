local utils = require("ma.utils")

local lsp = vim.lsp
local sign_define = utils.sign_define

lsp.handlers["textDocument/publishDiagnostics"] =
  lsp.with(
  lsp.diagnostic.on_publish_diagnostics,
  {
    underline = true,
    signs = true,
    update_in_insert = false,
    virtual_text = {
      severity_limit = "Warning",
      prefix = "",
      spacing = 0
    }
  }
)

sign_define("LspDiagnosticsSignError", "")
sign_define("LspDiagnosticsSignWarning", "")
sign_define("LspDiagnosticsSignHint", "")
sign_define("LspDiagnosticsSignInformation", "")
