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

  if client.resolved_capabilities.implementation then
    mapper("n", "gD", "vim.lsp.buf.implementation()")
  end

  if has_lspsaga then
    mapper("n", "ga", "require('lspsaga.codeaction').code_action()")
    map(
      "v",
      "ga",
      "<cmd>'<,'>lua require'lspsaga.codeaction'.range_code_action()<CR>",
      {noremap = true, silent = true}
    )
    mapper("n", "gr", "require('lspsaga.provider').lsp_finder()")
    mapper("n", "gd", "require('lspsaga.provider').preview_definition()")
    mapper("n", "gs", "require('lspsaga.signaturehelp').signature_help()")
    if ft ~= "vim" then
      mapper("n", "K", "require('lspsaga.hover').render_hover_doc()")
      mapper(
        "n",
        "<C-f>",
        "require('lspsaga.action').smart_scroll_with_saga(1)"
      )
      mapper(
        "n",
        "<C-b>",
        "require('lspsaga.action').smart_scroll_with_saga(-1)"
      )
    end
    mapper("n", "<leader>r", "require('lspsaga.rename').rename()")
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
  end
end

return custom_attach
