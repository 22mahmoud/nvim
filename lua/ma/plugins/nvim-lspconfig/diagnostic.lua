local lsp = vim.lsp
local fn = vim.fn

local function publishDiagnostics(error, result, ctx)
  lsp.diagnostic.on_publish_diagnostics(error, result, ctx)

  local bufnr = vim.uri_to_bufnr(result.uri)
  if bufnr ~= vim.api.nvim_get_current_buf() then
    return
  end

  local diagnostics = vim.diagnostic.get(bufnr)

  fn.setloclist(
    0,
    {},
    "r",
    {
      title = "LSP errors",
      bufnr = bufnr,
      items = vim.diagnostic.toqflist(diagnostics)
    }
  )
end

return publishDiagnostics
