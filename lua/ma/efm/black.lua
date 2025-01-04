---@type EfmLanguage
return {
  formatCommand = table.concat({
    'black',
    '--no-color',
    '-q',
    [[$(echo \
      ${--useless:rowStart} ${--useless:rowEnd} |
      xargs -n4 -r sh -c 'echo --line-ranges=$(($1+1))-$(($3+1))')]],
    '-',
  }, ' '),
  formatCanRange = true,
  formatStdin = true,
}
