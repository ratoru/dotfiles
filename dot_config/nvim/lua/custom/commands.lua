-- Utility command for clearing macros.
vim.api.nvim_create_user_command('ClearRegisters', function()
  for r in ('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'):gmatch '%a' do
    vim.fn.setreg(r, '')
  end
  vim.cmd 'wshada'
end, { desc = 'Clear registers' })

-- Resize splits if the window gets resized.
vim.api.nvim_create_autocmd('VimResized', {
  group = vim.api.nvim_create_augroup('ResizeSplits', { clear = true }),
  callback = function()
    vim.cmd 'tabdo wincmd ='
  end,
})

-- Close some filetypes with <q>.
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('CloseWithQ', { clear = true }),
  pattern = {
    'checkhealth',
    'help',
    'man',
    'qf',
    'query',
    'spectre_panel',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf })
  end,
})
