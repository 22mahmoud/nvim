vim.filetype.add {
  extension = {
    ejs = 'html',
    edge = 'html',
    eta = 'html',
  },
  filename = {
    ['wrangler.json'] = 'jsonc',
    ['.swcrc'] = 'jsonc',
    ['biome.json'] = 'jsonc',
    ['bun.lock'] = 'jsonc',
  },
  pattern = {
    ['tsconfig*.json'] = 'jsonc',
  },
}
