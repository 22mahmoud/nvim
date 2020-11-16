vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    -- Enable underline, use default values
    underline = true,
    -- Enable virtual text, override spacing to 4
    virtual_text = {
      spacing = 4,
      prefix = '~',
    },
    -- Use a function to dynamically turn signs off
    -- and on, using buffer local variables
    signs = function(bufnr, client_id)
      local ok, result = pcall(vim.api.nvim_buf_get_var, bufnr, 'show_signs')
      -- No buffer local variable set, so just enable by default
      if not ok then
        return true
      end

      return result
    end,
    -- Disable a feature
    update_in_insert = false,
  }
)

-- local command = vim.api.nvim_command
-- local sign_define = vim.fn.sign_define
-- local g = vim.g
-- 
-- g.diagnostic_enable_virtual_text = 1
-- g.diagnostic_enable_underline = 0
-- g.diagnostic_trimmed_virtual_text = "40"
-- g.diagnostic_insert_delay = 1
-- 
-- command("autocmd CursorHold <buffer> lua vim.lsp.util.show_line_diagnostics()")
-- command("autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()")
-- command("autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()")
-- command("autocmd CursorMoved <buffer> lua vim.lsp.util.buf_clear_references()")
-- 
-- sign_define(
--   "LspDiagnosticsErrorSign",
--   {text = "", texthl = "LspDiagnosticsError"}
-- )
-- sign_define(
--   "LspDiagnosticsWarningSign",
--   {text = "", texthl = "LspDiagnosticsWarning"}
-- )
-- sign_define(
--   "LspDiagnosticsInformationSign",
--   {text = "כֿ", texthl = "LspDiagnosticsInformation"}
-- )
-- sign_define(
--   "LspDiagnosticsHintSign",
--   {text = "➤", texthl = "LspDiagnosticsHint"}
-- )



