---@type vim.lsp.Config
return {
  cmd = { 'graphql-lsp', 'server', '-m', 'stream' },
  filetypes = { 'graphql', 'typescriptreact', 'javascriptreact' },
  root_dir = vim.fs.root(0, {
    '.graphqlrc.json',
    '.graphqlrc.jsonc',

    '.graphql.config.js',
    '.graphql.config.ts',
    '.graphql.config.mjs',

    'graphql.config.js',
    'graphql.config.ts',
    'graphql.config.mjs',
  }),
}
