if not vim.filetype then return end

vim.filetype.add {
  filename = {
    ['.swcrc'] = 'jsonc',
    ['biome.json'] = 'jsonc',
  },
  pattern = {
    ['tsconfig*.json'] = 'jsonc',
  },
}
