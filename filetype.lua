vim.filetype.add {
  extension = {
    ejs = 'html',
  },
  filename = {
    ['.swcrc'] = 'jsonc',
    ['biome.json'] = 'jsonc',
  },
  pattern = {
    ['tsconfig*.json'] = 'jsonc',
  },
}
