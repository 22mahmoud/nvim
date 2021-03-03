local gl = require("galaxyline")
local colors = require("galaxyline.theme").default
local condition = require("galaxyline.condition")
local gls = gl.section

vim.o.laststatus = 2
vim.o.showmode = true

gl.short_line_list = {"NvimTree"}

gls.left[1] = {
  RainbowRed = {
    provider = function()
      return "▊ "
    end,
    highlight = {colors.blue, colors.bg}
  }
}

gls.left[2] = {
  FileIcon = {
    provider = "FileIcon",
    condition = condition.buffer_not_empty,
    highlight = {
      require("galaxyline.provider_fileinfo").get_file_icon_color,
      colors.bg
    }
  }
}

gls.left[3] = {
  FileName = {
    provider = "FileName",
    condition = condition.buffer_not_empty,
    highlight = {colors.magenta, colors.bg, "bold"}
  }
}

gls.left[4] = {
  LineInfo = {
    provider = "LineColumn",
    separator = " ",
    separator_highlight = {"NONE", colors.bg},
    highlight = {colors.fg, colors.bg}
  }
}

gls.right[1] = {
  DiagnosticError = {
    provider = "DiagnosticError",
    icon = "  ",
    highlight = {colors.red, colors.bg}
  }
}

gls.right[2] = {
  DiagnosticWarn = {
    provider = "DiagnosticWarn",
    icon = "  ",
    highlight = {colors.yellow, colors.bg}
  }
}

gls.right[3] = {
  FileEncode = {
    provider = "FileEncode",
    separator = " ",
    separator_highlight = {"NONE", colors.bg},
    highlight = {colors.green, colors.bg, "bold"}
  }
}

gls.right[4] = {
  FileFormat = {
    provider = "FileFormat",
    separator = " ",
    separator_highlight = {"NONE", colors.bg},
    highlight = {colors.green, colors.bg, "bold"}
  }
}

gls.right[5] = {
  GitIcon = {
    provider = function()
      return "  "
    end,
    condition = condition.check_git_workspace,
    separator = " ",
    separator_highlight = {"NONE", colors.bg},
    highlight = {colors.violet, colors.bg, "bold"}
  }
}

gls.right[6] = {
  GitBranch = {
    provider = "GitBranch",
    condition = condition.check_git_workspace,
    highlight = {colors.violet, colors.bg, "bold"}
  }
}

gls.short_line_left[1] = {
  BufferType = {
    provider = "FileTypeName",
    separator = " ",
    separator_highlight = {"NONE", colors.bg},
    highlight = {colors.blue, colors.bg, "bold"}
  }
}

gls.short_line_left[2] = {
  SFileName = {
    provider = "SFileName",
    condition = condition.buffer_not_empty,
    highlight = {colors.fg, colors.bg, "bold"}
  }
}

gls.short_line_right[1] = {
  BufferIcon = {
    provider = "BufferIcon",
    highlight = {colors.fg, colors.bg}
  }
}
