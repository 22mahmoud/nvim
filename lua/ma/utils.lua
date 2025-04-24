local M = {}

function G.P(...)
  print(vim.inspect(...))

  return ...
end

function G.root_dir(markers)
  return function(bufnr, cb)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local project_root = vim.fs.root(fname, markers)

    if not project_root then return end

    cb(project_root)
  end
end

function M.toggle_qf()
  local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
  local action = qf_winid > 0 and 'cclose' or 'copen'

  vim.cmd('botright ' .. action)
end

--- Returns a function which applies `specs` on args. This function produces an object having
-- the same structure than `specs` by mapping each property to the result of calling its
-- associated function with the supplied arguments
-- @name applySpec
-- @param specs a table
-- @return a function
function M.applySpec(specs)
  return function(...)
    local spec = {}
    for i, f in pairs(specs) do
      spec[i] = f(...)
    end
    return spec
  end
end

G.icons = setmetatable({
  -- Exact Match
  ['init.lua'] = '',
  ['gruntfile.coffee'] = '',
  ['gruntfile.js'] = '',
  ['gruntfile.ls'] = '',
  ['gulpfile.coffee'] = '',
  ['gulpfile.js'] = '',
  ['gulpfile.ls'] = '',
  ['mix.lock'] = '',
  ['dropbox'] = '',
  ['.ds_store'] = '',
  ['.gitconfig'] = '',
  ['.gitignore'] = '',
  ['.env'] = '',
  ['.gitlab-ci.yml'] = '',
  ['.bashrc'] = '',
  ['.profile'] = '',
  ['.zprofile'] = '',
  ['.zshenv'] = '',
  ['.zshrc'] = '',
  ['.vimrc'] = '',
  ['.gvimrc'] = '',
  ['_vimrc'] = '',
  ['_gvimrc'] = '',
  ['.bashprofile'] = '',
  ['favicon.ico'] = '',
  ['license'] = '',
  ['node_modules'] = '',
  ['react.jsx'] = '󰜈',
  ['procfile'] = '',
  ['dockerfile'] = '󰡨',
  ['docker-compose.yml'] = '󰡨',
  ['compose.yml'] = '󰡨',
  ['bun.lock'] = '',
  -- Extension
  ['styl'] = '',
  ['sass'] = '',
  ['scss'] = '',
  ['htm'] = '',
  ['html'] = '',
  ['edge'] = '',
  ['slim'] = '',
  ['ejs'] = '',
  ['css'] = '',
  ['less'] = '',
  ['md'] = '',
  ['mdx'] = '',
  ['markdown'] = '',
  ['rmd'] = '',
  ['json'] = '',
  ['jsonc'] = '',
  ['js'] = '',
  ['mjs'] = '',
  ['jsx'] = '',
  ['rb'] = '',
  ['astro'] = '',
  ['php'] = '',
  ['py'] = '',
  ['pyc'] = '',
  ['pyo'] = '',
  ['pyd'] = '',
  ['coffee'] = '',
  ['mustache'] = '',
  ['hbs'] = '',
  ['conf'] = '',
  ['ini'] = '',
  ['yml'] = '',
  ['yaml'] = '',
  ['toml'] = '',
  ['bat'] = '',
  ['jpg'] = '',
  ['jpeg'] = '',
  ['bmp'] = '',
  ['png'] = '',
  ['gif'] = '',
  ['ico'] = '',
  ['twig'] = '',
  ['cpp'] = '',
  ['c++'] = '',
  ['cxx'] = '',
  ['cc'] = '',
  ['cp'] = '',
  ['c'] = '',
  ['cs'] = '',
  ['h'] = '',
  ['hh'] = '',
  ['hpp'] = '',
  ['hxx'] = '',
  ['hs'] = '',
  ['lhs'] = '',
  ['lua'] = '',
  ['java'] = '',
  ['sh'] = '',
  ['fish'] = '',
  ['bash'] = '',
  ['zsh'] = '',
  ['ksh'] = '',
  ['csh'] = '',
  ['awk'] = '',
  ['ps1'] = '',
  ['ml'] = 'λ',
  ['mli'] = 'λ',
  ['diff'] = '',
  ['db'] = '',
  ['sql'] = '',
  ['dump'] = '',
  ['clj'] = '',
  ['cljc'] = '',
  ['cljs'] = '',
  ['edn'] = '',
  ['scala'] = '',
  ['go'] = '',
  ['dart'] = '',
  ['xul'] = '',
  ['sln'] = '',
  ['suo'] = '',
  ['pl'] = '',
  ['pm'] = '',
  ['t'] = '',
  ['rss'] = '',
  ['f#'] = '',
  ['fsscript'] = '',
  ['fsx'] = '',
  ['fs'] = '',
  ['fsi'] = '',
  ['rs'] = '',
  ['rlib'] = '',
  ['d'] = '',
  ['erl'] = '',
  ['hrl'] = '',
  ['ex'] = '',
  ['exs'] = '',
  ['eex'] = '',
  ['leex'] = '',
  ['vim'] = '',
  ['ai'] = '',
  ['psd'] = '',
  ['psb'] = '',
  ['ts'] = '',
  ['tsx'] = '',
  ['jl'] = '',
  ['pp'] = '',
  ['vue'] = '󰡄',
  ['elm'] = '',
  ['swift'] = '',
  ['xcplayground'] = '',
}, {
  __index = function(table, key)
    local ext = key:match '%.(.+)$'

    return ext and table[ext] or '󰈔'
  end,
})

---@class EfmCommand
---@field title string The title of the command.
---@field command string The command to execute.
---@field arguments string[]|nil Optional arguments for the command.
---@field os string|nil The operating system for which the command is specific.

---@class EfmLanguage
---@field prefix string The prefix for the language.
---@field lintFormats string[] An array of lint format strings.
---@field lintStdin boolean Whether linting supports stdin.
---@field lintOffset integer The lint offset value.
---@field lintOffsetColumns integer The lint offset for columns.
---@field lintCommand string The command used for linting.
---@field lintIgnoreExitCode boolean Whether to ignore the exit code of the lint command.
---@field lintCategoryMap table<string, string> A mapping of lint categories.
---@field lintSource string The source of linting information.
---@field lintSeverity integer The severity level for linting.
---@field lintWorkspace boolean Whether linting is workspace-based.
---@field lintAfterOpen boolean Whether linting occurs after a file is opened.
---@field lintOnSave boolean Whether linting occurs on save.
---@field formatCommand string The command used for formatting.
---@field formatCanRange boolean Whether formatting supports a range of text.
---@field formatStdin boolean Whether formatting supports stdin.
---@field symbolCommand string The command used for symbol operations.
---@field symbolStdin boolean Whether symbol operations support stdin.
---@field symbolFormats string[] An array of formats for symbols.
---@field completionCommand string The command used for autocompletion.
---@field completionStdin boolean Whether autocompletion supports stdin.
---@field hoverCommand string The command used for hover information.
---@field hoverStdin boolean Whether hover information supports stdin.
---@field hoverType string The type of hover information.
---@field hoverChars string Characters related to hover information.
---@field env string[] Environment variables for the language.
---@field rootMarkers string[] A list of markers to identify the project root.
---@field requireMarker boolean Whether a marker is required for operations.
---@field commands Command[] A list of commands associated with the language.

return M
