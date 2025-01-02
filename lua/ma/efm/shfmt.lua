return {
  formatCommand = table.concat({
    'shfmt',
    '-i 2',
    '-filename ${INPUT}',
    '-',
  }, ' '),
  formatStdin = true,
}
