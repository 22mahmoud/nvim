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
  }
end

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
