---@type EfmLanguage
return {
  formatCommand = table.concat({
    'djlint',
    '--reformat',
    '-',
  }, ' '),
  lintCommand = table.concat({
    'djlint',
    '--linter-output-format',
    [['I:{line}: {message}']],
    '--profile=django',
    '-',
  }, ' '),
  lintFormats = { '%t:%l:%c: %m' },
  lintStdin = true,
  lintIgnoreExitCode = true,
  formatStdin = true,
}
