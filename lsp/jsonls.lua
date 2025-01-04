local function get_json_schemas()
  return {
    {
      description = 'NPM configuration file',
      fileMatch = { 'package.json' },
      name = 'package.json',
      url = 'https://json.schemastore.org/package.json',
    },
    {
      name = 'GraphQL Config',
      description = 'GraphQL Config config file',
      fileMatch = {
        'graphql.config.json',
        '.graphqlrc',
        '.graphqlrc.json',
      },
      url = 'https://unpkg.com/graphql-config/config-schema.json',
    },
    {
      description = 'ESLint configuration files',
      fileMatch = { '.eslintrc', '.eslintrc.json' },
      name = '.eslintrc',
      url = 'https://json.schemastore.org/eslintrc.json',
    },
    {
      description = '.prettierrc configuration file',
      fileMatch = { '.prettierrc', '.prettierrc.json' },
      name = 'prettierrc.json',
      url = 'https://json.schemastore.org/prettierrc.json',
      versions = {
        ['1.8.2'] = 'https://json.schemastore.org/prettierrc-1.8.2.json',
        ['2.8.8'] = 'https://json.schemastore.org/prettierrc-2.8.8.json',
        ['3.0.0'] = 'https://json.schemastore.org/prettierrc.json',
      },
    },
    {
      description = 'TypeScript compiler configuration file',
      fileMatch = { 'tsconfig*.json' },
      name = 'tsconfig.json',
      url = 'https://json.schemastore.org/tsconfig.json',
    },
  }
end

---@type vim.lsp.Config
return {
  cmd = { 'vscode-json-language-server', '--stdio' },
  root_markers = { '.git' },
  filetypes = { 'json', 'jsonc' },
  settings = {
    json = {
      schemas = get_json_schemas(),
      validate = { enable = true },
    },
  },
}
