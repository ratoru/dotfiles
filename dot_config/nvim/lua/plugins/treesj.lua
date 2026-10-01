-- Depends on: plugins.treesitter
vim.pack.add { 'https://github.com/Wansmer/treesj' }
require('treesj').setup {}

vim.keymap.set('n', '<leader>cm', function() require('treesj').toggle() end, { desc = 'Split / join code block' })
vim.keymap.set('n', '<leader>cM', function() require('treesj').toggle { split = { recursive = true } } end, { desc = 'Split / join code block rec' })

-- vim: ts=2 sts=2 sw=2 et
