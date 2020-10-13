local U = {}

-- Key mapping
function U.map(mode, key, result, opts)
  vim.fn.nvim_set_keymap(
    mode,
    key,
    result,
    {
      noremap = true,
      silent = opts.silent or false,
      expr = opts.expr or false,
      script = opts.script or false
    }
  )
end

return U
