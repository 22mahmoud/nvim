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
    end
 }
}

gls.left[2] = {
  FileIcon = {
    provider = "FileIcon",
    condition = condition.buffer_not_empty
  }
}

gls.left[3] = {
  FileName = {
    provider = "FileName",
    condition = condition.buffer_not_empty
  }
}

gls.left[4] = {
  LineInfo = {
    provider = "LineColumn",
    separator = " "
  }
}

gls.right[1] = {
  DiagnosticError = {
    provider = "DiagnosticError",
    icon = "  "
  }
}

gls.right[2] = {
  DiagnosticWarn = {
    provider = "DiagnosticWarn",
    icon = "  "
  }
}

gls.right[3] = {
  FileEncode = {
    provider = "FileEncode",
    separator = " "
  }
}

gls.right[4] = {
  FileFormat = {
    provider = "FileFormat",
    separator = " "
  }
}

gls.right[5] = {
  GitIcon = {
    provider = function()
      return "  "
    end,
    condition = condition.check_git_workspace,
    separator = " "
  }
}

gls.right[6] = {
  GitBranch = {
    provider = "GitBranch",
    condition = condition.check_git_workspace
  }
}

gls.short_line_left[1] = {
  BufferType = {
    provider = "FileTypeName",
    separator = " "
  }
}

gls.short_line_left[2] = {
  SFileName = {
    provider = "SFileName",
    condition = condition.buffer_not_empty
  }
}

gls.short_line_right[1] = {
  BufferIcon = {
    provider = "BufferIcon"
  }
}
