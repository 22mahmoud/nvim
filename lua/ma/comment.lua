local M = {}
G.comment = M

function M.operator(mode)
  if not mode then
    vim.opt.operatorfunc = 'v:lua.G.comment.operator'
    return 'g@'
  end

  vim.cmd(
    string.format(
      'lockmarks lua G.comment.toggle_lines(%d, %d)',
      unpack(vim.api.nvim_buf_get_mark(0, mode == 'visual' and '<' or '[')),
      unpack(vim.api.nvim_buf_get_mark(0, mode == 'visual' and '>' or ']'))
    )
  )

  return ''
end

function M.toggle_lines(line_start, line_end)
  print(line_start, line_end)

  local comment_parts = M.parse_comment_string()
  local lines = vim.api.nvim_buf_get_lines(0, line_start - 1, line_end, false)

  local indent, is_comment = M.get_lines_info(lines, comment_parts)

  local f
  if is_comment then
    f = M.make_uncomment_function(comment_parts)
  else
    f = M.make_comment_function(comment_parts, indent)
  end

  for n, l in pairs(lines) do
    lines[n] = f(l)
  end

  vim.api.nvim_buf_set_lines(0, line_start - 1, line_end, false, lines)
end

function M.parse_comment_string()
  local cs = vim.opt.commentstring:get()

  if cs == '' then
    vim.notify [[Option 'commentstring' is empty.]]
    return { right = '', left = '' }
  end

  local left, right = cs:match '^%s*(.-)%s*%%s%s*(.-)%s*$'

  return { left = left, right = right }
end

function M.get_lines_info(lines, comment_parts)
  local indent = math.huge
  local indent_cur = indent

  local is_comment = true
  local comment_check = M.make_comment_check(comment_parts)

  for _, l in pairs(lines) do
    -- Update lines indent: minimum of all indents except empty lines
    if indent > 0 then
      _, indent_cur = l:find '^%s*'
      -- Condition "current indent equals line length" detects empty line
      if (indent_cur < indent) and (indent_cur < l:len()) then
        indent = indent_cur
      end
    end

    -- Update comment info: lines are comment if every single line is comment
    if is_comment then
      is_comment = comment_check(l)
    end
  end

  return indent, is_comment
end

function M.make_comment_check(comment_parts)
  local l, r = comment_parts.left, comment_parts.right
  -- String is commented if it has structure:
  -- <space> <left> <anything> <right> <space>
  local regex = string.format([[^%%s-%s.*%s%%s-$]], vim.pesc(l), vim.pesc(r))

  return function(line)
    return line:find(regex) ~= nil
  end
end

function M.make_comment_function(comment_parts, indent)
  local indent_str = string.rep(' ', indent)
  local nonindent_start = indent + 1

  local l, r = comment_parts.left, comment_parts.right
  local lpad = (l == '') and '' or ' '
  local rpad = (r == '') and '' or ' '

  local empty_comment = indent_str .. l .. r
  local nonempty_format = indent_str .. l .. lpad .. '%s' .. rpad .. r

  return function(line)
    -- Line is empty if it doesn't have anything except whitespace
    if line:find '^%s*$' ~= nil then
      -- If doesn't want to comment empty lines, return `line` here
      return empty_comment
    else
      return string.format(nonempty_format, line:sub(nonindent_start))
    end
  end
end

function M.make_uncomment_function(comment_parts)
  local l, r = comment_parts.left, comment_parts.right
  local lpad = (l == '') and '' or '[ ]?'
  local rpad = (r == '') and '' or '[ ]?'

  -- Usage of `lpad` and `rpad` as possbile single space enables uncommenting
  -- of commented empty lines without trailing whitespace (like '  #').
  local uncomment_regex = string.format(
    [[^(%%s-)%s%s(.-)%s%s%%s-$]],
    vim.pesc(l),
    lpad,
    rpad,
    vim.pesc(r)
  )

  return function(line)
    local indent_str, new_line = string.match(line, uncomment_regex)
    -- Return original if line is not commented
    if new_line == nil then
      return line
    end
    -- Remove indent if line is a commented empty line
    if new_line == '' then
      indent_str = ''
    end
    return indent_str .. new_line
  end
end

function M.textobject()
  local comment_parts = M.parse_comment_string()
  local comment_check = M.make_comment_check(comment_parts)
  local line_cur = vim.api.nvim_win_get_cursor(0)[1]

  if not comment_check(vim.fn.getline(line_cur)) then
    return
  end

  local line_start = line_cur
  while (line_start >= 2) and comment_check(vim.fn.getline(line_start - 1)) do
    line_start = line_start - 1
  end

  local line_end = line_cur
  local n_lines = vim.api.nvim_buf_line_count(0)
  while
    (line_end <= n_lines - 1) and comment_check(vim.fn.getline(line_end + 1))
  do
    line_end = line_end + 1
  end

  -- This visual selection doesn't seem to change `'<` and `'>` marks when
  -- executed as `onoremap` mapping
  vim.cmd(string.format('normal! %dGV%dG', line_start, line_end))
end

function M.setup()
  G.nnoremap('gc', [[v:lua.G.comment.operator()]], { expr = true })
  G.xnoremap('gc', [[:<c-u>lua G.comment.operator("visual")<cr>]])
  G.nnoremap('gcc', [[v:lua.G.comment.operator() . "_"]], { expr = true })
  G.onoremap('gc', [[<cmd>lua G.comment.textobject()<cr>]])
end

M.setup()

return M
