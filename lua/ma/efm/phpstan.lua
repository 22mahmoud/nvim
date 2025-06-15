---@type EfmLanguage
return {
  lintCommand = table.concat({
    './vendor/bin/phpstan',
    'analyse',
    '--no-progress',
    '--error-format=raw',
    '--memory-limit=2048M',
    '"${INPUT}"',
  }, ' '),
  lintSource = 'efm/phpstan',
  lintStdin = false,
  lintFormats = {
    '%f:%l:%m',
    '%-G%.%#',
  },
  rootMarkers = { 'phpstan.neon', 'phpstan.neon.dist', 'composer.json' },
}
