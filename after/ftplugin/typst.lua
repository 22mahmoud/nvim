vim.g.typst_auto_compile = vim.g.typst_auto_compile ~= false

local group = vim.api.nvim_create_augroup('TypstAutoMake', { clear = false })

vim.api.nvim_create_autocmd('BufWritePost', {
  group = group,
  buffer = 0,
  callback = function()
    if not vim.g.typst_auto_compile then return end

    local file = vim.fn.expand '%:p'

    vim.fn.jobstart({ 'typst', 'compile', file }, {
      on_exit = function(_, code)
        if code ~= 0 then vim.notify('Typst compile failed', vim.log.levels.ERROR) end
      end,
    })
  end,
})

vim.keymap.set('n', '<leader>zo', function()
  local filename = vim.fn.expand '%:p:r' .. '.pdf'

  vim.fn.jobstart({ 'zathura', '--fork', filename }, { detach = true })
end)
