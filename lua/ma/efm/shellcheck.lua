return {
  prefix = 'shellcheck',
  lintSource = 'efm/shellcheck',
  lintCommand = table.concat({
    'shellcheck',
    '--color=never',
    '--format=gcc',
    '-',
  }, ' '),
  lintIgnoreExitCode = true,
  lintStdin = true,
  lintFormats = { '-:%l:%c: %trror: %m', '-:%l:%c: %tarning: %m', '-:%l:%c: %tote: %m' },
  rootMarkers = {},
}
