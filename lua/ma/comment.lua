local M = {}
G.comment = M

local function padding(str, space)
  return str == '' and '' or (space or ' ')
end

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
  local lhs, rhs = M.get_comment_string()

  local lines = vim.api.nvim_buf_get_lines(0, line_start - 1, line_end, false)
  local indent = M.get_lines_indent(lines)
  local is_comment = G.all(M.is_commented(lhs, rhs), lines)

  local new_lines = G.map(
    M.handle_toggle_line(lhs, rhs, indent, is_comment),
    lines
  )

  vim.api.nvim_buf_set_lines(0, line_start - 1, line_end, false, new_lines)
end

function M.get_lines_indent(lines)
  return G.reduce(function(acc, l)
    local _, current_indent = l:find '^%s*'

    if current_indent < acc and current_indent < l:len() then
      return current_indent
    end

    return acc
  end, math.huge, lines)
end

function M.get_comment_string()
  return vim.opt.commentstring:get():match '(.*)%%s(.*)'
end

function M.is_commented(lhs, rhs)
  local regex = string.format(
    [[^%%s-%s.*%s%%s-$]],
    vim.pesc(lhs),
    vim.pesc(rhs)
  )

  return function(line)
    return line:find(regex) ~= nil
  end
end

function M.comment(lhs, rhs, line, indent)
  local indent_str = string.rep(' ', indent)

  if line:find '^%s*$' then
    return indent_str .. lhs .. rhs
  end

  return table.concat {
    indent_str,
    lhs,
    padding(lhs),
    line:sub(indent + 1),
    padding(rhs),
    rhs,
  }
end

function M.uncomment(lhs, rhs, line)
  local indent_str, new_line = line:match(
    string.format(
      [[^(%%s-)%s%s(.-)%s%s%%s-$]],
      vim.pesc(lhs),
      padding(lhs, '[ ]?'),
      padding(rhs, '[ ]?'),
      vim.pesc(rhs)
    )
  )

  return not new_line and line
    or (new_line == '' and '' or indent_str) .. new_line
end

function M.handle_toggle_line(lhs, rhs, indent, is_comment)
  return function(line)
    if is_comment then
      return M.uncomment(lhs, rhs, line)
    else
      return M.comment(lhs, rhs, line, indent)
    end
  end
end

function M.setup()
  G.nnoremap('gc', [[v:lua.G.comment.operator()]], { expr = true })
  G.xnoremap('gc', [[:<c-u>lua G.comment.operator("visual")<cr>]])
  G.nnoremap('gcc', [[v:lua.G.comment.operator() . "_"]], { expr = true })
  -- G.onoremap('gc', [[<cmd>lua G.comment.textobject()<cr>]])
end

M.setup()

return M
