local loaded, conform = pcall(require, 'conform')

if not loaded then return end

---@alias ConformCtx {buf: number, filename: string, dirname: string}

local formatters_by_ft = {
  lua = { 'stylua' },
  sh = { 'shellcheck', 'shfmt' },
  bash = { 'shfmt' },
  python = { 'black' },
  json = { 'fixjson' },
}

local formatters = {}

-- setup biome
local biome_supported = vim.g.biome_supported
  or {
    'astro',
    'css',
    'graphql',
    'javascript',
    'javascriptreact',
    'json',
    'jsonc',
    'svelte',
    'typescript',
    'typescriptreact',
    'vue',
  }

for _, ft in ipairs(biome_supported) do
  formatters_by_ft[ft] = formatters_by_ft[ft] or {}
  table.insert(formatters_by_ft[ft], 'biome')
end

formatters.biome = {
  require_cwd = true,
}

-- prettier
local prettier_supported = vim.g.prettier_supported
  or {
    'astro',
    'css',
    'graphql',
    'handlebars',
    'html',
    'javascript',
    'javascriptreact',
    'json',
    'jsonc',
    'less',
    'markdown',
    'markdown.mdx',
    'scss',
    'typescript',
    'typescriptreact',
    'vue',
    'yaml',
  }

---@param ctx ConformCtx
local function has_prettier_config(ctx)
  vim.fn.system { 'prettier', '--find-config-path', ctx.filename }
  return vim.v.shell_error == 0
end

---@param ctx ConformCtx
local function has_prettier_parser(ctx)
  local ft = vim.bo[ctx.buf].filetype
  if vim.tbl_contains(prettier_supported, ft) then return true end
  local ret = vim.fn.system { 'prettier', '--file-info', ctx.filename }
  local ok, parser = pcall(function() return vim.fn.json_decode(ret).inferredParser end)
  return ok and parser and parser ~= vim.NIL
end

for _, ft in ipairs(prettier_supported) do
  formatters_by_ft[ft] = formatters_by_ft[ft] or {}
  table.insert(formatters_by_ft[ft], 'prettier')
end

formatters.prettier = {
  condition = function(_, ctx)
    local result = has_prettier_parser(ctx) or has_prettier_config(ctx)
    return result
  end,
}

conform.setup {
  formatters_by_ft = formatters_by_ft,
  formatters = formatters,
  log_level = vim.log.levels.DEBUG,
}

vim.keymap.set('n',',f', conform.format)
