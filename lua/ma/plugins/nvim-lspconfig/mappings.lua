local lsp = vim.lsp

local function create_buf_mapper(client, bufnr)
  return function(mode)
    return function(lhs, rhs, capability)
      if capability and not client.resolved_capabilities[capability] then
        return
      end

      local mapper = _.utils.map(mode, {silent = true, noremap = true})
      mapper(lhs, rhs, {bufnr = bufnr})
    end
  end
end

local function lsp_mappings(keymaps)
  return function(client, bufnr)
    local mapper = create_buf_mapper(client, bufnr)
    for mode, y in pairs(keymaps) do
      local map = mapper(mode)
      for _, mapping in pairs(y) do
        map(unpack(mapping))
      end
    end
  end
end

local function setup(keymaps)
  return lsp_mappings(keymaps)
end

return setup(
  {
    n = {
      {",f", lsp.buf.formatting, "document_formatting"},
      {"gr", lsp.buf.references, "find_references"},
      {"K", lsp.buf.hover, "hover"},
      {"gi", lsp.buf.implementation, "implementation"},
      {"gi", lsp.buf.implementation, "implementation"},
      {"gd", lsp.buf.definition, "goto_definition"},
      {"gd", lsp.buf.declaration, "declaration"},
      {"sh", lsp.buf.signature_help, "signature_help"},
      {"gW", lsp.buf.workspace_symbol, "workspace_symbol"},
      {"ga", lsp.buf.code_action, "code_action"},
      {"<leader>l", lsp.codelens.run, "code_lens"},
      {"<leader>rn", lsp.buf.rename, "rename"}
    },
    v = {
      {",f", lsp.buf.range_formatting, "document_range_formatting"}
    },
    i = {
      {"<c-space>", lsp.buf.signature_help, "signature_help"}
    }
  }
)
