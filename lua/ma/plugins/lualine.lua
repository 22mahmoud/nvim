local M = {}

function M.config()
  local colors = require("base16-colorscheme").colors

  local base16 = {
    normal = {
      a = {bg = colors.base01, fg = colors.base04, gui = "bold"},
      b = {bg = colors.base04, fg = colors.base02},
      c = {bg = colors.base01, fg = colors.base05}
    },
    insert = {
      a = {bg = colors.base01, fg = colors.base0B, gui = "bold"},
      b = {bg = colors.base04, fg = colors.base02},
      c = {bg = colors.base01, fg = colors.base05}
    },
    visual = {
      a = {bg = colors.base01, fg = colors.base09, gui = "bold"},
      b = {bg = colors.base04, fg = colors.base02},
      c = {bg = colors.base01, fg = colors.base05}
    },
    replace = {
      a = {bg = colors.base01, fg = colors.base0E, gui = "bold"},
      b = {bg = colors.base04, fg = colors.base02},
      c = {bg = colors.base01, fg = colors.base05}
    },
    inactive = {
      a = {bg = colors.base01, fg = colors.base01, gui = "bold"},
      b = {bg = colors.base04, fg = colors.base01},
      c = {bg = colors.base05, fg = colors.base01}
    }
  }

  require("lualine").setup {
    options = {
      theme = base16
    }
  }
end

return M
