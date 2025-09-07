---@type EfmLanguage
return {
  formatCommand = table.concat({
    'biome',
    'format',
    "--stdin-file-path '${INPUT}'",
  }, ' '),
  formatStdin = true,
  rootMarkers = { 'rome.json', 'biome.json' },
}
