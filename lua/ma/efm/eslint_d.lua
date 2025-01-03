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
  rootMarkers = {
    '.eslintrc',
    '.eslintrc.cjs',
    '.eslintrc.js',
    '.eslintrc.json',
    '.eslintrc.yaml',
    '.eslintrc.yml',
  },
}
