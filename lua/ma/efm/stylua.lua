return {
  formatCommand = table.concat({
    'stylua',
    '--color Never',
    '${--range-start:charStart}',
    '${--range-end:charEnd}',
    '--stdin-filepath ${INPUT} -',
  }, ' '),
  formatStdin = true,
  rootMarkers = { 'stylua.toml', '.stylua.toml' },
}
