local function hl(group, options)
  local bg = options.bg == nil and "" or "guibg=" .. options.bg
  local fg = options.fg == nil and "" or "guifg=" .. options.fg
  local gui = options.gui == nil and "" or "gui=" .. options.gui

  vim.cmd(string.format("hi %s %s %s %s", group, bg, fg, gui))
end

function ApplyGruvbox()
  local highlights = {
    -- normal stuff
    {"Normal", {bg = "NONE"}},
    {"SignColumn", {bg = "NONE"}},
    {"VertSplit", {bg = "#3C3836", fg = "#3C3836"}},
    -- statusline colours
    {"StatusLine", {bg = "#3C3836", fg = "#3C3836"}},
    {"StatusLineActive", {bg = "#3C3836", fg = "#EBDBB2"}},
    {"StatusLineInactive", {bg = "#3C3836", fg = "#928374"}},
    {"StatusLineMode", {bg = "#EBDBB2", fg = "#282828", gui = "bold"}},
    {"StatusLineFileManagerIcon", {bg = "#EBDBB2", fg = "#3C3836"}},
    {"StatusLineLineCol", {bg = "#EBDBB2", fg = "#3C3836", gui = "bold"}},
    {"StatusLineFiletype", {bg = "#BDAE93", fg = "#3C3836"}},
    {"StatusLineGit", {bg = "#BDAE93", fg = "#3C3836"}},
    {
      "StatusLineFileManagerText",
      {bg = "#BDAE93", fg = "#3C3836", gui = "bold"}
    },
    {"StatusLineFilename", {bg = "#3C3836", fg = "#D5C4A1"}},
    {"StatusLineError", {bg = "#FB4934", fg = "#3C3836"}},
    {"StatusLineWarning", {bg = "##fabd2f", fg = "#3C3836"}},
    -- luatree
    {"NvimTreeFolderIcon", {fg = "#D79921"}},
    {"NvimTreeIndentMarker", {fg = "#928374"}},
    -- diagnostic-nvim
    {"LspDiagnosticsDefaultError", {bg = "NONE", fg = "#FB4934"}},
    {"LspDiagnosticsDefaultInformation", {bg = "NONE", fg = "#D3869B"}},
    {"LspDiagnosticsDefaultWarning", {bg = "NONE", fg = "#FABD2F"}},
    {"LspDiagnosticsDefaultHint", {bg = "NONE", fg = "#83A598"}}
  }

  for _, highlight in pairs(highlights) do
    hl(highlight[1], highlight[2])
  end
end

-- italicize comments
hl("Comment", {gui = "italic"})

-- automatically override colourscheme
vim.cmd("augroup NewColor")
vim.cmd("au!")
vim.cmd("au ColorScheme gruvbox8 call v:lua.ApplyGruvbox()")
vim.cmd("augroup END")

vim.g.gruvbox_invert_selection = false
vim.o.background = "dark"
vim.g.gruvbox_contrast_dark = "hard"
vim.g.gruvbox_bold = 0
vim.g.gruvbox_improved_strings = 1
vim.g.gruvbox_improved_warnings = 1
vim.g.gruvbox_invert_indent_guides = 1
vim.g.gruvbox_invert_signs = 1
vim.g.gruvbox_invert_tabline = 1
vim.g.gruvbox_italic = 1
vim.g.gruvbox_italicize_comments = 1
vim.g.gruvbox_italicize_strings = 0
vim.g.gruvbox_undercurl = 1

vim.cmd("colors gruvbox8")
