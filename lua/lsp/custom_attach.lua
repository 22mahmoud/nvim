local map = vim.api.nvim_set_keymap

local mapper = function(mode, key, result)
  map(
    mode,
    key,
    "<cmd>lua " .. result .. "<cr>",
    {noremap = true, silent = true}
  )
end

local function custom_attach(client)
  if client.resolved_capabilities.find_references then
    mapper("n", "gr", "vim.lsp.buf.references()")
  end

  if client.resolved_capabilities.goto_definition then
    mapper("n", "gd", "vim.lsp.buf.definition()")
  end

  if client.resolved_capabilities.implementation then
    mapper("n", "gD", "vim.lsp.buf.implementation()")
  end

  if client.resolved_capabilities.document_formatting then
    mapper("n", ",f", "vim.lsp.buf.formatting()")
  end

  if client.resolved_capabilities.rename then
    mapper("n", "<leader>r", "vim.lsp.buf.rename()")
  end

  local ft = vim.api.nvim_buf_get_option(0, "filetype")
  if ft ~= "lua" then
    mapper("n", "K", "vim.lsp.buf.hover()")
  end

  -- diagnostic
  map(
    "n",
    "<leader>dd",
    ":LspDiagnostics 0<CR>",
    {noremap = true, silent = true}
  )
  mapper("n", "<leader>dn", "vim.lsp.diagnostic.goto_next()")
  mapper("n", "<leader>dn", "vim.lsp.diagnostic.goto_next()")
  mapper("n", "<leader>dp", "vim.lsp.diagnostic.goto_prev()")
  mapper("n", "<leader>ds", "vim.lsp.diagnostic.show_line_diagnostics()")
end

return custom_attach
