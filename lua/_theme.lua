local set_hl = function(group, options)
  local bg     = options.bg == nil and "" or "guibg=" .. options.bg
  local fg     = options.fg == nil and "" or "guifg=" .. options.fg
  local gui    = options.gui == nil and "" or "gui=" .. options.gui
  local link   = options.link or false
  local target = options.target

  if not link then
    vim.cmd(string.format("hi %s %s %s %s", group, bg, fg, gui))
  else
    vim.cmd(string.format("hi! link", group, target))
  end
end

ColorUtil = {}

ColorUtil.override_gruvbox = function()
  local highlights = {
    -- normal stuff
    { "Normal",      { bg  = "#1d2021"    }},
    { "Comment",     { gui = "italic"  }},
    { "SignColumn",  { bg  = "NONE"    }},
    { "ColorColumn", { bg  = "#3C3836" }},
    { "IncSearch",   { bg  = "#928374" }},
    { "String",      { gui = "NONE"    }},
    { "Special",     { gui = "NONE"    }},
    { "Folded",      { gui = "NONE"    }},
    { "EndOfBuffer", { bg  = "NONE",fg = "#282828" }},

    -- tabline stuff
    { "Tabline",            { bg = "NONE"  }},
    { "TablineSuccess",     { bg = "NONE", fg = "#b8bb26", gui = "bold" }},
    { "TablineError",       { bg = "NONE", fg = "#fb4934"  }},
    { "TablineWarning",     { bg = "NONE", fg = "#d79921"  }},
    { "TablineInformation", { bg = "NONE", fg = "#458588"  }},
    { "TablineHint",        { bg = "NONE", fg = "#689D6A"  }},

    -- git stuff
    { "SignAdd",    { fg = "#458588", bg = "NONE" }},
    { "SignChange", { fg = "#D79921", bg = "NONE" }},
    { "SignDelete", { fg = "#fb4934", bg = "NONE" }},

    -- lsp saga stuff
    { "TargetWord",             { fg = "#d79921", bg  = "NONE",    gui = "bold" }},
    { "LspSagaFinderSelection", { fg = "#d79921", bg  = "#3C3836", gui = "bold" }},
    { "LspDiagErrorBorder",     { fg = "#fb4934", gui = "bold" }},
    { "LspDiagWarnBorder",      { fg = "#d79921", gui = "bold" }},
    { "LspDiagInfoBorder",      { fg = "#458588", gui = "bold" }},
    { "LspDiagHintBorder",      { fg = "#458588", gui = "bold" }},

    -- misc
    { "jsonNoQuotesError",     { fg  = "#fb4934" }},
    { "jsonMissingCommaError", { fg  = "#fb4934" }},
    { "mkdLineBreak",          { bg  = "NONE"    }},
    { "htmlLink",              { gui = "NONE",    fg  = "#ebdbb2"   }},
    { "IncSearch",             { bg  = "#282828", fg  = "#928374"   }},
    { "mkdLink",               { fg  = "#458588", gui = "underline" }},
    { "markdownCode",          { bg  = "NONE",    fg  = "#fe8019"   }},
    { "StrikeThrough",         { gui = "strikethrough" }},

    -- nvimtree
    { "NvimTreeFolderIcon",   { fg = "#d79921" }},
    { "NvimTreeIndentMarker", { fg = "#928374" }},

    -- telescope
    { "TelescopeSelection", { bg = "NONE", fg = "#d79921", gui = "bold" }},
    { "TelescopeMatching",  { bg = "NONE", fg = "#fb4934", gui = "bold" }},
    { "TelescopeBorder",    { bg = "NONE", fg = "#928374", gui = "bold" }},

    -- diagnostic nvim
    { "LspDiagnosticsDefaultError",         { bg  = "NONE", fg = "#fb4934" }},
    { "LspDiagnosticsDefaultWarning",       { bg  = "NONE", fg = "#d79921" }},
    { "LspDiagnosticsDefaultInformation",   { bg  = "NONE", fg = "#458588" }},
    { "LspDiagnosticsDefaultHint",          { bg  = "NONE", fg = "#689D6A" }},
    { "LspDiagnosticsUnderlineError",       { gui = "underline" }},
    { "LspDiagnosticsUnderlineWarning",     { gui = "underline" }},
    { "LspDiagnosticsUnderlineInformation", { gui = "underline" }},
    { "LspDiagnosticsUnderlineHint",        { gui = "underline" }},

    -- ts override
    { "TSKeywordOperator", { bg = "NONE", fg = "#fb4934" }},
    { "TSOperator",        { bg = "NONE", fg = "#fe8019" }},
  }

  for _, highlight in ipairs(highlights) do
    set_hl(highlight[1], highlight[2])
  end
end

-- italicize comments
set_hl("Comment", { gui = "italic" })

-- automatically override colourscheme
vim.api.nvim_exec([[
  augroup NewColor
  au!
  au ColorScheme gruvbox8 call v:lua.ColorUtil.override_gruvbox()
  augroup END
]], false)

-- disable invert selection for gruvbox
vim.g.gruvbox_invert_selection = false
vim.cmd [[colorscheme gruvbox8]]
