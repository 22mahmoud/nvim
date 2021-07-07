local has_nvim_comment = pcall(require, "nvim_comment")

if not has_nvim_comment then
  return
end

require("nvim_comment").setup({})
