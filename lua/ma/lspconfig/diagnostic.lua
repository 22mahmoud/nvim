local lsp = vim.lsp

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

local function sign_define(name, text)
  vim.fn.sign_define(
    name,
    {
      texthl = name,
      text = text,
      numhl = name
    }
  )
end

sign_define("LspDiagnosticsSignError", "")
sign_define("LspDiagnosticsSignWarning", "")
sign_define("LspDiagnosticsSignHint", "")
sign_define("LspDiagnosticsSignInformation", "")
