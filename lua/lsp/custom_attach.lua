local has_lspsaga = pcall(require, "lspsaga")

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
  local ft = vim.api.nvim_buf_get_option(0, "filetype")

  if client.resolved_capabilities.document_formatting then
    mapper("n", ",f", "vim.lsp.buf.formatting()")
  end

  if has_lspsaga then
    mapper("n", "ga", "require('lspsaga.codeaction').code_action()")
    mapper("n", "gr", "require('lspsaga.provider').lsp_finder()")
    mapper("n", "gd", "require('lspsaga.provider').preview_definition()")
    if ft ~= "vim" then
      mapper("n", "K", "require('lspsaga.hover').render_hover_doc()")
    end
    mapper("n", "<leader>r", "require('lspsaga.rename').rename()")
    mapper("n", "<C-f>", "require('lspsaga.action').smart_scroll_with_saga(1)")
    mapper("n", "<C-b>", "require('lspsaga.action').smart_scroll_with_saga(-1)")
    -- diagnostic
    mapper(
      "n",
      "<leader>ds",
      "require('lspsaga.diagnostic').show_line_diagnostics()"
    )
    mapper(
      "n",
      "<leader>dn",
      "require('lspsaga.diagnostic').lsp_jump_diagnostic_next()"
    )
    mapper(
      "n",
      "<leader>dp",
      "require('lspsaga.diagnostic').lsp_jump_diagnostic_prev()"
    )
  else
    if client.resolved_capabilities.code_action then
      mapper("n", "ga", "vim.lsp.buf.code_action()")
    end

    if client.resolved_capabilities.find_references then
      mapper("n", "gr", "vim.lsp.buf.references()")
    end

    if client.resolved_capabilities.goto_definition then
      mapper("n", "gd", "vim.lsp.buf.definition()")
    end

    if client.resolved_capabilities.implementation then
      mapper("n", "gD", "vim.lsp.buf.implementation()")
    end

    if client.resolved_capabilities.rename then
      mapper("n", "<leader>r", "vim.lsp.buf.rename()")
    end

    if ft ~= "lua" then
      mapper("n", "K", "vim.lsp.buf.hover()")
    end

    -- diagnostic
    mapper("n", "<leader>dn", "vim.lsp.diagnostic.goto_next()")
    mapper("n", "<leader>dp", "vim.lsp.diagnostic.goto_prev()")
    mapper("n", "<leader>ds", "vim.lsp.diagnostic.show_line_diagnostics()")
  end
end

return custom_attach
