---@type EfmLanguage
return {
  formatCanRange = true,
  formatCommand = table.concat({
    'prettierd',
    '${INPUT}',
    '${--range-start=charStart} ${--range-end=charEnd}',
    '${--tab-width=tabWidth} ${--use-tabs=!insertSpaces}',
  }, ' '),
  formatStdin = true,
  rootMarkers = {
    '.prettierrc',
    '.prettierrc.json',
    '.prettierrc.js',
    '.prettierrc.yml',
    '.prettierrc.yaml',
    '.prettierrc.json5',
    '.prettierrc.mjs',
    '.prettierrc.cjs',
    '.prettierrc.toml',
    'prettier.config.js',
    'prettier.config.cjs',
    'prettier.config.mjs',
  },
}
