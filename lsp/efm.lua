local stylua = require 'ma.efm.stylua'
local shellcheck = require 'ma.efm.shellcheck'
local shfmt = require 'ma.efm.shfmt'
local biome = require 'ma.efm.biome'
local prettierd = require 'ma.efm.prettier_d'
local eslintd = require 'ma.efm.eslint_d'
local gofmt = require 'ma.efm.gofmt'
local phpstan = require 'ma.efm.phpstan'
local djlint = require 'ma.efm.djlint'

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

local eslint_supported = vim.g.eslint_supported
  or {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
    'vue',
    'svelte',
    'astro',
    'json',
    'jsonc',
    'markdown',
  }

local languages = {
  lua = { stylua },
  sh = { shellcheck, shfmt },
  zsh = { shfmt },
  htmldjango = { djlint },
  go = { gofmt },
  php = { phpstan },
}

for _, ft in ipairs(biome_supported) do
  languages[ft] = languages[ft] or {}
  table.insert(languages[ft], biome)
end

for _, ft in ipairs(prettier_supported) do
  languages[ft] = languages[ft] or {}
  table.insert(languages[ft], prettierd)
end

for _, ft in ipairs(eslint_supported) do
  languages[ft] = languages[ft] or {}
  table.insert(languages[ft], eslintd)
end

---@type vim.lsp.Config
return {
  cmd = { 'efm-langserver' },
  filetypes = vim.tbl_keys(languages),
  settings = { languages = languages },
  init_options = {
    documentFormatting = true,
    documentRangeFormatting = true,
  },
}
