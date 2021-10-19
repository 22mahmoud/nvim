local M = {}

local lsp_kind = {
  "   (Text) ",
  "   (Method)",
  "   (Function)",
  "   (Constructor)",
  "   (Field)",
  "  (Variable)",
  "   (Class)",
  " ﰮ  (Interface)",
  "   (Module)",
  " 襁 (Property)",
  "   (Unit)",
  "   (Value)",
  " 練 (Enum)",
  "   (Keyword)",
  "   (Snippet)",
  "   (Color)",
  "   (File)",
  "   (Reference)",
  "   (Folder)",
  "   (EnumMember)",
  "   (Constant)",
  "   (Struct)",
  "   (Event)",
  "   (Operator)",
  "   (TypeParameter)"
}

function M.setup()
  vim.lsp.protocol.CompletionItemKind = lsp_kind
end

return M
