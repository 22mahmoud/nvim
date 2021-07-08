local M = {}

function M.setup()
  local utils = require("ma.utils")
  local nnoremap = utils.nnoremap

  nnoremap("<leader>cn", ":ConflictMarkerNextHunk<cr>")
  nnoremap("<leader>cp", ":ConflictMarkerPrevHunk<cr>")
  nnoremap("<leader>cb", ":ConflictMarkerBoth<cr>")
  nnoremap("<leader>ct", ":ConflictMarkerThemselves<cr>")
  nnoremap("<leader>co", ":ConflictMarkerOurselves<cr>")
  nnoremap("<leader>cx", ":ConflictMarkerNone<cr>")
  nnoremap("<leader>cx", ":ConflictMarkerNone<cr>")
end

function M.config()
  local utils = require("ma.utils")

  local augroup = utils.augroup

  vim.g.conflict_marker_highlight_group = ""
  vim.g.conflict_marker_enable_mappings = 0
  vim.g.conflict_marker_begin = "^<<<<<<< .*$"
  vim.g.conflict_marker_end = "^>>>>>>> .*$"

  local function conflict_marker_hilights()
    vim.cmd [[hi ConflictMarkerBegin guibg=#2f7366]]
    vim.cmd [[hi ConflictMarkerOurs guibg=#2e5049]]
    vim.cmd [[hi ConflictMarkerTheirs guibg=#344f69]]
    vim.cmd [[hi ConflictMarkerEnd guibg=#2f628e]]
    vim.cmd [[hi ConflictMarkerCommonAncestorsHunk guibg=#754a81]]
  end

  conflict_marker_hilights()

  augroup(
    "ConflictMarkerHighlight",
    {
      {
        events = {"ColorScheme"},
        targets = {"*"},
        command = function()
          conflict_marker_hilights()
        end
      }
    }
  )
end

return M
