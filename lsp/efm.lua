local shellcheck = require 'ma.efm.shellcheck'
local shfmt = require 'ma.efm.shfmt'
local biome = require 'ma.efm.biome'
local prettierd = require 'ma.efm.prettierd'
local eslintd = require 'ma.efm.eslintd'
local gofmt = require 'ma.efm.gofmt'
local djlint = require 'ma.efm.djlint'
local fixjson = require 'ma.efm.fixjson'
local gdscript_formatter = require 'ma.efm.gdscript_formatter'

local biome_supported = vim.g.biome_supported
  or {
    'astro',
    'css',
    'graphql',
    'javascript',
    'javascriptreact',
    'json',
    -- 'jsonc',
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
    'markdown',
  }

local json = { fixjson }

local languages = {
  sh = { shellcheck, shfmt },
  zsh = { shfmt },
  htmldjango = { djlint },
  go = { gofmt },
  json = json,
  gdscript = { gdscript_formatter },
  gd = { gdscript_formatter },
  gdscript3 = { gdscript_formatter },
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
