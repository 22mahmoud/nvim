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
    ['https://raw.githubusercontent.com/jesseduffield/lazygit/master/schema/config.json'] = {
      '**/lazygit/config.yml',
      'lazygit.yml',
      '.lazygit.yml',
    },
    ['https://unpkg.com/graphql-config/config-schema.json'] = {
      'graphql.config.yaml',
      'graphql.config.yml',
      '.graphqlrc.yaml',
      '.graphqlrc.yml',
    },
  }
end

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
