local has_nvim_autopairs = pcall(require, "nvim-autopairs")

if not has_nvim_autopairs then
  return
end

require("nvim-autopairs").setup {check_ts = true}
