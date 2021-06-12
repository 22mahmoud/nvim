local tbl_extend = vim.tbl_extend

local function map(mode, lhs, rhs, opts)
  local options = tbl_extend(
    "keep",
    opts or {},
    {silent = true, noremap = true}
  )

  vim.api.nvim_set_keymap(
    mode,
    lhs,
    rhs,
    options
  )
end

local function nmap(lhs, rhs, opts) 
  map("n", lhs, rhs, opts)
end

local function vmap(lhs, rhs, opts) 
  map("v", lhs, rhs, opts)
end

local function cmap(lhs, rhs, opts)
  local options = tbl_extend(
    "keep",
    opts or {},
    {silent = false}
  )

  map(
    "c",
    lhs,
    rhs,
    options
  )
end

return {
  nmap = nmap,
  vmap = vmap,
  cmap = cmap,
}
