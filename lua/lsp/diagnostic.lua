local lsp, sign_define = vim.lsp, vim.fn.sign_define

lsp.handlers["textDocument/publishDiagnostics"] =
  lsp.with(
  lsp.diagnostic.on_publish_diagnostics,
  {
    underline = true,
    signs = true,
    update_in_insert = false,
    virtual_text = {
      severity_limit = "Warning",
      spacing = 4,
      prefix = "~"
    }
  }
)

sign_define(
  "LspDiagnosticsSignError",
  {text = "", texthl = "LspDiagnosticsError"}
)

sign_define(
  "LspDiagnosticsSignWarning",
  {text = "", texthl = "LspDiagnosticsWarning"}
)

sign_define(
  "LspDiagnosticsSignInformation",
  {text = "", texthl = "LspDiagnosticsInformation"}
)

sign_define(
  "LspDiagnosticsSignHint",
  {text = "", texthl = "LspDiagnosticsHint"}
)
