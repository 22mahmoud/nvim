return {
  formatCommand = table.concat({
    'shfmt',
    '-filename ${INPUT}',
    '-',
  }, ' '),
  formatStdin = true,
}
