---@type EfmLanguage
return {
  prefix = 'eslint_d',
  lintSource = 'efm/eslint_d',
  lintCommand = table.concat({
    'eslint_d',
    '--no-color',
    '--format visualstudio',
    '--stdin-filename',
    '"${INPUT}" --stdin',
  }, ' '),
  lintStdin = true,
  lintFormats = { '%f(%l,%c): %trror %m', '%f(%l,%c): %tarning %m' },
  lintIgnoreExitCode = true,
  formatCommand = table.concat({
    'eslint_d',
    '--fix-to-stdout',
    '--stdin-filename ${INPUT}',
    '--stdin',
  }, ' '),
  formatStdin = true,
  rootMarkers = {
    'eslint.config.js',
    'eslint.config.mjs',
    'eslint.config.ts',
    'eslint.config.mts',
    '.eslintrc',
    '.eslintrc.cjs',
    '.eslintrc.js',
    '.eslintrc.json',
    '.eslintrc.yaml',
    '.eslintrc.yml',
  },
}
