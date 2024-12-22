--- @see https://github.com/echasnovski/mini.nvim/blob/7b210cc5207e36f562f6c1e83200d5dfc0a4451d/lua/mini/completion.lua

local M = {}

local function process_lsp_response(request_result, processor)
  if not request_result then return {} end

  local response = {}

  for client_id, item in pairs(request_result) do
    if not item.error and item.result then
      vim.list_extend(response, processor(item.result, client_id) or {})
    end
  end

  return response
end

local function on_complete_done()
  local completed_item = vim.v.completed_item

  local item = vim.tbl_get(completed_item or {}, 'user_data', 'nvim', 'lsp', 'completion_item')

  if not item then return end

  local bufnr = vim.api.nvim_get_current_buf()

  vim.lsp.buf_request_all(
    bufnr,
    vim.lsp.protocol.Methods.completionItem_resolve,
    item,
    function(response)
      local resolved = process_lsp_response(
        response,
        function(result) return result.additionalTextEdits end
      )

      local edits

      if #resolved >= 1 then
        edits = resolved
      else
        edits = vim.tbl_get(
          completed_item or {},
          'user_data',
          'nvim',
          'lsp',
          'completion_item',
          'additionalTextEdits'
        )
      end

      if edits == nil then return end

      vim.lsp.util.apply_text_edits(resolved, bufnr, 'utf-8')
    end
  )
end

function M.attach(client, bufnr)
  G.augroup('TSLspImportOnCompletion', {
    {
      events = 'CompleteDonePre',
      buffer = bufnr,
      command = on_complete_done,
    },
  })
end

return M
