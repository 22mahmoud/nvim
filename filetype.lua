vim.filetype.add {
  extension = {
    ejs = 'html',
    edge = 'html',
    eta = 'html',
  },
  filename = {
    ['.swcrc'] = 'jsonc',
    ['biome.json'] = 'jsonc',
  },
  pattern = {
    ['tsconfig*.json'] = 'jsonc',
  },
}
