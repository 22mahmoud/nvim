local utils = require 'ma.utils'

---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local cmd = 'biome'
    local local_cmd = (config or {}).root_dir and config.root_dir .. '/node_modules/.bin/biome'

    if local_cmd and vim.fn.executable(local_cmd) == 1 then cmd = local_cmd end

    return vim.lsp.rpc.start({ cmd, 'lsp-proxy' }, dispatchers)
  end,
  root_dir = function(bufnr, on_dir)
    local root_markers =
      { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock', 'deno.lock' }
    local project_root = vim.fs.root(bufnr, { root_markers })
    if not project_root then return end

    -- We know that the buffer is using Biome if it has a config file
    -- in its directory tree.
    local filename = vim.api.nvim_buf_get_name(bufnr)
    local biome_config_files = { 'biome.json', 'biome.jsonc' }
    biome_config_files = utils.insert_package_json(biome_config_files, 'biome', filename)

    local is_buffer_using_biome = vim.fs.find(biome_config_files, {
      path = filename,
      type = 'file',
      limit = 1,
      upward = true,
      stop = vim.fs.dirname(project_root),
    })[1]

    if not is_buffer_using_biome then return end

    on_dir(project_root)
  end,
  filetypes = {
    'astro',
    'css',
    'graphql',
    'html',
    'javascript',
    'javascriptreact',
    'json',
    'jsonc',
    'svelte',
    'typescript',
    'typescript.tsx',
    'typescriptreact',
    'vue',
  },
  on_init = function(client)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
}
