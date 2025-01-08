vim.loader.enable()

local o = vim.opt
local methods = vim.lsp.protocol.Methods
local keymap = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- options
vim.g.mapleader = ' '

o.mouse = 'a'
o.confirm = true
o.clipboard = 'unnamedplus'
o.wrap = false
o.signcolumn = 'yes'
o.colorcolumn = '80'
o.list = true
o.listchars = {
  trail = '•',
  tab = '» ',
  nbsp = '␣',
}

o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.smartindent = true

o.hlsearch = false
o.smartcase = true
o.ignorecase = true

o.splitbelow = true
o.splitright = true

o.swapfile = false
o.undofile = true
o.undolevels = 10000

o.completeopt = { 'fuzzy', 'menu', 'menuone', 'noselect' }
o.pumheight = 30
o.pumblend = 5
o.wildmode = { 'longest:full', 'full' }
o.wildoptions = 'pum,fuzzy'
o.wildignorecase = true
o.wildignore = {
  '*.out',
  '*.o',
  '*/.next/*',
  '*/node_modules/*',
  '*/.git/*',
}

-- mappings

-- navigation & find & search
keymap('n', '<leader>p', ':find<space>')
keymap('n', '<leader>rg', [[:silent grep ''<left>]])
keymap('n', '<leader>gw', ':silent grep <C-R>=expand("<cword>")<CR><CR>')

-- better movement between window buffers
keymap('n', '<c-k>', '<c-w><c-k>')
keymap('n', '<c-h>', '<c-w><c-h>')
keymap('n', '<c-j>', '<c-w><c-j>')
keymap('n', '<c-l>', '<c-w><c-l>')

-- better indenting experience
keymap('v', '<', '<gv')
keymap('v', '>', '>gv')

-- buffers
keymap('n', '<s-l>', ':bn<cr>')
keymap('n', '<s-h>', ':bp<cr>')
keymap('n', '<leader>bl', ':ls t<cr>:b<space>')
keymap('n', '<leader>bd', ':bd!<cr>')

-- quick list
keymap('n', '<leader>qn', ':cn<cr>zz')
keymap('n', '<leader>qp', ':cp<cr>zz')
keymap('n', '<leader>ql', function()
  local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
  local action = qf_winid > 0 and 'cclose' or 'copen'
  vim.cmd('botright ' .. action)
end)
keymap('n', '<leader>qq', ':cex []<cr>')

-- special remaps
keymap('n', 'n', 'nzz')
keymap('n', 'N', 'Nzz')

-- better command mode navigation
keymap('c', '<C-b>', '<Left>')
keymap('c', '<C-f>', '<Right>')
keymap('c', '<C-n>', '<Down>')
keymap('c', '<C-p>', '<Up>')
keymap('c', '<C-e>', '<End>')
keymap('c', '<C-a>', '<Home>')
keymap('c', '<C-d>', '<Del>')
keymap('c', '<C-h>', '<BS>')

-- diagnostics
keymap('n', '<leader>ds', function() vim.diagnostic.open_float(nil, { source = 'always' }) end)
keymap('n', '<leader>dn', function() vim.diagnostic.jump { count = 1 } end)
keymap('n', '<leader>dp', function() vim.diagnostic.jump { count = -1 } end)
keymap('n', '<leader>dq', vim.diagnostic.setloclist)

-- lsp
vim.lsp.config('lua_ls', {
  cmd = { 'lua-language-server' },
  root_markers = {
    '.luarc.json',
    '.luarc.jsonc',
    '.luacheckrc',
    '.stylua.toml',
    'stylua.toml',
    'selene.toml',
    'selene.yml',
    '.git',
  },
  filetypes = { 'lua' },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJit',
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

vim.lsp.config('ts_ls', {
  cmd = { 'typescript-language-server', '--stdio' },
  root_markers = { '.git', 'packages.json' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  }
})

vim.lsp.config('html_ls', {
  cmd = { 'vscode-html-language-server', '--stdio' },
  filetypes = { 'html', 'templ' },
  settings = {},
  init_options = {
    provideFormatter = false,
    embeddedLanguages = { css = true, javascript = true },
    configurationSection = { 'html', 'css', 'javascript' },
  },
})

vim.lsp.config('css_ls', {
  cmd = { 'vscode-css-language-server', '--stdio' },
  filetypes = { 'css', 'scss', 'less' },
  init_options = { provideFormatter = false },
  settings = {
    css = { validate = true },
    scss = { validate = true },
    less = { validate = true },
  },
})

autocmd({ 'LspAttach' }, {
  group = augroup('UserLspAttach', {}),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    local buffer = args.buf

    if not client or not buffer then return end

    if client:supports_method(methods.textDocument_formatting) then
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = buffer,
        callback = function() vim.lsp.buf.format { bufnr = buffer, id = client.id } end,
      })
    end
  end,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  },
}

vim.lsp.config('*', {
  capabilities = capabilities,
  root_markers = { '.git', 'package.json' },
})

vim.lsp.enable({ 'lua_ls', 'ts_ls', 'html_ls', 'css_ls' })

-- exrc
local rc_file_name = '.nvimrc.lua'
local project_root = vim.fs.root(0, rc_file_name) or vim.env.HOME
local rc_file = vim.fs.joinpath(project_root, rc_file_name)
if vim.uv.fs_stat(rc_file) and vim.secure.read(rc_file) then
  vim.cmd.source(rc_file)
end
