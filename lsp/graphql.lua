---@type vim.lsp.Config
return {
  cmd = { 'graphql-lsp', 'server', '-m', 'stream' },
  filetypes = { 'graphql', 'typescriptreact', 'javascriptreact' },
  root_dir = G.root_dir {
    '.graphqlrc.json',
    '.graphqlrc.jsonc',

    '.graphql.config.js',
    '.graphql.config.ts',
    '.graphql.config.mjs',

    'graphql.config.js',
    'graphql.config.ts',
    'graphql.config.mjs',
  },
}
