local rc_file_name = '.nvimrc.lua'

local project_root = vim.fs.root(0, rc_file_name) or vim.env.HOME
local rc_file = vim.fs.joinpath(project_root, rc_file_name)

if not vim.uv.fs_stat(rc_file) then return end
if not vim.secure.read(rc_file) then return end

vim.cmd.source(rc_file)
