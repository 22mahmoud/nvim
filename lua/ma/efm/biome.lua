---@type EfmLanguage
return {
  formatCommand = table.concat({
    'biome',
    'check',
    '--write',
    "--stdin-file-path '${INPUT}'",
  }, ' '),
  formatStdin = true,
  rootMarkers = { 'rome.json', 'biome.json', 'package.json', 'Biomefile' },
}
