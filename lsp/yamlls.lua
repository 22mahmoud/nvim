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
      settings = {
        Lua = {
          runtime = {
            version = 'LuaJit',
          },
          diagnostics = {
            globals = { 'vim' },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file('', true),
          },
          telemetry = {
            enable = false,
          },
        },
      },
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
