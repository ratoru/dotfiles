-- This remap allows you to paste text over a highlighted text
-- while keeping the original text in the yanked register.
vim.keymap.set('x', '<leader>p', [["_dP]], { desc = '[p]aste and keep yanked text' })
vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]], { desc = '[d]elete without buffer' })

-- System Clipboard Management
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]], { desc = '[y]ank to system clipboard' })
vim.keymap.set('n', '<leader>Y', [["+Y]], { desc = '[Y]ank to system clipboard' })

-- Window management
vim.keymap.set('n', '<leader>wv', '<C-w>v', { desc = '[W]indow [V]ertical split' })
vim.keymap.set('n', '<leader>ws', '<C-w>s', { desc = '[W]indow horizontal split' })
vim.keymap.set('n', '<leader>we', '<C-w>=', { desc = 'Make [W]indows [E]qual size' })
vim.keymap.set('n', '<leader>wq', '<C-w>q', { desc = '[Q]uit window' })

-- vim.keymap.set('n', ';', '<Nop>')

-- Indent while remaining in visual mode.
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- Execute macro over visual region.
vim.keymap.set('x', '@', function()
  return ':norm @' .. vim.fn.getcharstr() .. '<cr>'
end, { expr = true })

-- Quitting.
vim.keymap.set('n', '<leader>Q', '<cmd>qa<cr>', { desc = 'Quit all' })

-- Keeping the cursor centered.
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll downwards' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll upwards' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next result' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous result' })
