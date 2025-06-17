local function get_yaml_schemas()
  return {
    ['https://json.schemastore.org/github-workflow.json'] = {
      '**/.github/workflows/*.yml',
      '**/.github/workflows/*.yaml',
      '**/.gitea/workflows/*.yml',
      '**/.gitea/workflows/*.yaml',
      '**/.forgejo/workflows/*.yml',
      '**/.forgejo/workflows/*.yaml',
    },
    ['https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json'] = {
      '**/docker-compose.yml',
      '**/docker-compose.yaml',
      '**/docker-compose.*.yml',
      '**/docker-compose.*.yaml',
      '**/compose.yml',
      '**/compose.yaml',
      '**/compose.*.yml',
      '**/compose.*.yaml',
    },
    ['https://unpkg.com/graphql-config/config-schema.json'] = {
      'graphql.config.yaml',
      'graphql.config.yml',
      '.graphqlrc',
      '.graphqlrc.yaml',
      '.graphqlrc.yml',
    },
    ['https://json.schemastore.org/pre-commit-config.json'] = {
      '.pre-commit-config.yml',
      '.pre-commit-config.yaml',
    },
    ['https://json.schemastore.org/pre-commit-hooks.json'] = {
      '.pre-commit-hooks.yml',
      '.pre-commit-hooks.yaml',
    },
  }
end

---@type vim.lsp.Config
return {
  cmd = { 'yaml-language-server', '--stdio' },
  root_markers = { '.git' },
  filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab' },
  settings = {
    redhat = { telemetry = { enabled = false } },
    yaml = {
      schemaStore = {
        enable = false,
        url = '',
      },
      schemas = get_yaml_schemas(),
    },
  },
}
