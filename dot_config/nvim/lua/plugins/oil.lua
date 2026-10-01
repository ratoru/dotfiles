-- Depends on: plugins.mini (icons)
vim.pack.add { 'https://github.com/stevearc/oil.nvim' }

---@module 'oil'
---@type oil.SetupOpts
local opts = {
  columns = { 'icon' },
  keymaps = {
    ['<C-h>'] = false,
    ['<C-l>'] = false,
    ['<C-k>'] = false,
    ['<C-j>'] = false,
    ['<M-h>'] = 'actions.select_split',
    ['q'] = { 'actions.close', mode = 'n' },
  },
  delete_to_trash = true,
  skip_confirm_for_simple_edits = true,
  view_options = {
    show_hidden = true,
  },
}
require('oil').setup(opts)

vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

-- vim: ts=2 sts=2 sw=2 et
