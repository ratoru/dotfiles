vim.pack.add {
  'https://github.com/lewis6991/async.nvim',
  'https://github.com/ThePrimeagen/refactoring.nvim',
}
require('refactoring').setup {}

vim.keymap.set({ 'n', 'x' }, '<leader>cr', function() require('refactoring').select_refactor {} end, { desc = '[R]efactor' })

-- vim: ts=2 sts=2 sw=2 et
