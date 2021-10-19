local fmt = string.format
local fn = vim.fn
local empty = fn.empty
local filter = fn.filter
local getwininfo = fn.getwininfo
local tbl_extend = vim.tbl_extend
local nvim_buf_set_keymap = vim.api.nvim_buf_set_keymap
local nvim_set_keymap = vim.api.nvim_set_keymap

local M = {}
_G._.utils = M

--- Inspired by @tjdevries' astraunauta.nvim/ @TimUntersberger's config
__KeyMapStore = __KeyMapStore or {}
M._store = __KeyMapStore

M._create = function(f)
  table.insert(M._store, f)
  return #M._store
end

M._execute = function(id)
  M._store[id]()
end

local function has_value(tab, val)
  for _, value in ipairs(tab) do
    if value == val then
      return true
    end
  end

  return false
end

local function tbl_filter(func, t)
  vim.validate {func = {func, "c"}, t = {t, "t"}}

  local out = {}
  for key, value in next, t do
    if func(value, key) then
      out[key] = value
    end
  end

  return out
end

local function is_map_args(value, key)
  if type(value) ~= "boolean" then
    return false
  end
  local valid_args = {"buffer", "nowait", "silent", "script", "expr", "unique"}
  return has_value(valid_args, key)
end

function M.map(mode, default_options)
  if not mode then return end
  return function(lhs, rhs, extra_options)
    if not lhs or not rhs then return end

    default_options = default_options or {}
    extra_options = extra_options or {}

    local bufnr = extra_options.bufnr

    if vim.fn.maparg(lhs, "n") ~= "" and bufnr then
      return
    end

    local opts =
      tbl_extend(
      "keep",
      tbl_filter(is_map_args, extra_options),
      default_options
    )

    if type(rhs) == "function" then
      local fn_id = M._create(rhs)
      rhs = fmt([[<cmd>lua require("ma.utils")._execute(%s)<CR>]], fn_id)
    end

    if bufnr then
      nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
    else
      nvim_set_keymap(mode, lhs, rhs, opts)
    end
  end
end

local map_opts = {noremap = false, silent = true}
M.nmap = M.map("n", map_opts)
M.imap = M.map("i", map_opts)
M.vmap = M.map("v", map_opts)
M.tmap = M.map("t", map_opts)
M.xmap = M.map("x", map_opts)
M.cmap = M.map("c", tbl_extend("keep", {silent = false}, map_opts))

local noremap_opts = tbl_extend("keep", {noremap = true}, map_opts)
M.nnoremap = M.map("n", noremap_opts)
M.inoremap = M.map("i", noremap_opts)
M.vnoremap = M.map("v", noremap_opts)
M.tnoremap = M.map("t", noremap_opts)
M.xnoremap = M.map("x", noremap_opts)
M.cnoremap = M.map("c", tbl_extend("keep", {silent = false}, noremap_opts))

function M.sign_define(name, text)
  vim.fn.sign_define(
    name,
    {
      texthl = name,
      text = text,
      numhl = '',
      linehl = '',
    }
  )
end

function M.augroup(name, commands)
  vim.cmd("augroup " .. name)
  vim.cmd("autocmd!")
  for _, c in ipairs(commands) do
    local command = c.command
    if type(command) == "function" then
      local fn_id = M._create(command)
      command = fmt('lua require("ma.utils")._execute(%s)', fn_id)
    end
    vim.cmd(
      string.format(
        "autocmd %s %s %s %s",
        table.concat(c.events, ","),
        table.concat(c.targets or {}, ","),
        table.concat(c.modifiers or {}, " "),
        command
      )
    )
  end
  vim.cmd("augroup END")
end

function M.toggle_qf()
  local locations = vim.fn.getqflist()

  -- if no quickfix list then do nothing
  if vim.tbl_isempty(locations) then
    return
  end

  if empty(filter(getwininfo(), "v:val.quickfix")) == 1 then
    -- open qflist 100% horizontally
    vim.cmd [[botright copen]]
  else
    vim.cmd [[cclose]]
  end
end

M.icons =
  setmetatable(
  {
    -- Exact Match
    ["gruntfile.coffee"] = "",
    ["gruntfile.js"] = "",
    ["gruntfile.ls"] = "",
    ["gulpfile.coffee"] = "",
    ["gulpfile.js"] = "",
    ["gulpfile.ls"] = "",
    ["mix.lock"] = "",
    ["dropbox"] = "",
    [".ds_store"] = "",
    [".gitconfig"] = "",
    [".gitignore"] = "",
    [".gitlab-ci.yml"] = "",
    [".bashrc"] = "",
    [".zshrc"] = "",
    [".vimrc"] = "",
    [".gvimrc"] = "",
    ["_vimrc"] = "",
    ["_gvimrc"] = "",
    [".bashprofile"] = "",
    ["favicon.ico"] = "",
    ["license"] = "",
    ["node_modules"] = "",
    ["react.jsx"] = "",
    ["procfile"] = "",
    ["dockerfile"] = "",
    ["docker-compose.yml"] = "",
    -- Extension
    ["styl"] = "",
    ["sass"] = "",
    ["scss"] = "",
    ["htm"] = "",
    ["html"] = "",
    ["slim"] = "",
    ["ejs"] = "",
    ["css"] = "",
    ["less"] = "",
    ["md"] = "",
    ["mdx"] = "",
    ["markdown"] = "",
    ["rmd"] = "",
    ["json"] = "",
    ["js"] = "",
    ["mjs"] = "",
    ["jsx"] = "",
    ["rb"] = "",
    ["php"] = "",
    ["py"] = "",
    ["pyc"] = "",
    ["pyo"] = "",
    ["pyd"] = "",
    ["coffee"] = "",
    ["mustache"] = "",
    ["hbs"] = "",
    ["conf"] = "",
    ["ini"] = "",
    ["yml"] = "",
    ["yaml"] = "",
    ["toml"] = "",
    ["bat"] = "",
    ["jpg"] = "",
    ["jpeg"] = "",
    ["bmp"] = "",
    ["png"] = "",
    ["gif"] = "",
    ["ico"] = "",
    ["twig"] = "",
    ["cpp"] = "",
    ["c++"] = "",
    ["cxx"] = "",
    ["cc"] = "",
    ["cp"] = "",
    ["c"] = "",
    ["cs"] = "",
    ["h"] = "",
    ["hh"] = "",
    ["hpp"] = "",
    ["hxx"] = "",
    ["hs"] = "",
    ["lhs"] = "",
    ["lua"] = "",
    ["java"] = "",
    ["sh"] = "",
    ["fish"] = "",
    ["bash"] = "",
    ["zsh"] = "",
    ["ksh"] = "",
    ["csh"] = "",
    ["awk"] = "",
    ["ps1"] = "",
    ["ml"] = "λ",
    ["mli"] = "λ",
    ["diff"] = "",
    ["db"] = "",
    ["sql"] = "",
    ["dump"] = "",
    ["clj"] = "",
    ["cljc"] = "",
    ["cljs"] = "",
    ["edn"] = "",
    ["scala"] = "",
    ["go"] = "",
    ["dart"] = "",
    ["xul"] = "",
    ["sln"] = "",
    ["suo"] = "",
    ["pl"] = "",
    ["pm"] = "",
    ["t"] = "",
    ["rss"] = "",
    ["f#"] = "",
    ["fsscript"] = "",
    ["fsx"] = "",
    ["fs"] = "",
    ["fsi"] = "",
    ["rs"] = "",
    ["rlib"] = "",
    ["d"] = "",
    ["erl"] = "",
    ["hrl"] = "",
    ["ex"] = "",
    ["exs"] = "",
    ["eex"] = "",
    ["leex"] = "",
    ["vim"] = "",
    ["ai"] = "",
    ["psd"] = "",
    ["psb"] = "",
    ["ts"] = "",
    ["tsx"] = "",
    ["jl"] = "",
    ["pp"] = "",
    ["vue"] = "﵂",
    ["elm"] = "",
    ["swift"] = "",
    ["xcplayground"] = ""
  },
  {
    __index = function(table, key)
      local ext = key:match "%.(.+)$"

      return ext and table[ext] or ""
    end
  }
)

return M
