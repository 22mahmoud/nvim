vim.filetype.add {
  extension = {
    ejs = 'html',
    edge = 'html',
    eta = 'html',
    env = 'dotenv',
  },
  filename = {
    ['wrangler.json'] = 'jsonc',
    ['.swcrc'] = 'jsonc',
    ['biome.json'] = 'jsonc',
    ['bun.lock'] = 'jsonc',
    ['Procfile'] = 'yaml',
    ['procfile'] = 'yaml',
  },
  pattern = {
    ['tsconfig*.json'] = 'jsonc',
    ['%.env.*'] = 'dotenv',
    ['%.env'] = 'dotenv',
  },
}
