local has_colorizer = pcall(require, "colorizer")

if not has_colorizer then
  return
end

require("colorizer").setup()
vim.cmd "ColorizerReloadAllBuffers"
