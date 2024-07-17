-- This remap allows you to paste text over a highlighted text
-- while keeping the original text in the yanked register.
vim.keymap.set('x', '<leader>p', [["_dP]], { desc = '[p]aste and keep yanked text' })

-- System Clipboard Management
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]], { desc = '[y]ank to system clipboard' })
vim.keymap.set('n', '<leader>Y', [["+Y]], { desc = '[Y]ank to system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]], { desc = '[d]elete to system clipboard' })

-- Window management
vim.keymap.set('n', '<leader>wv', '<C-w>v', { desc = 'Split [W]indow [V]ertically' })
vim.keymap.set('n', '<leader>ws', '<C-w>s', { desc = 'Split [W]indow Horizontally' })
vim.keymap.set('n', '<leader>we', '<C-w>=', { desc = 'Make [W]indow splits [E]qual size' })
vim.keymap.set('n', '<leader>wx', '<cmd>close<CR>', { desc = 'Close current split' })

-- vim.keymap.set('n', ';', '<Nop>')
