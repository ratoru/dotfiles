-- Add `version = vim.version.range '*'` to follow only stable versions
vim.pack.add { 'https://github.com/danymat/neogen' }

require('neogen').setup {
  snippet_engine = 'nvim',
}

vim.keymap.set('n', '<leader>cd', '<cmd>Neogen<cr>', { desc = 'Generate [d]oc comments' })

-- vim: ts=2 sts=2 sw=2 et
