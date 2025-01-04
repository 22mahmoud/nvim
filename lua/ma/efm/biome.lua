---@type EfmLanguage
return {
  formatCommand = table.concat({
    'biome',
    'check',
    '--apply',
    "--stdin-file-path '${INPUT}'",
  }, ' '),
  formatStdin = true,
  rootMarkers = { 'rome.json', 'biome.json' },
}
