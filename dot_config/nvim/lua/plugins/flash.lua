vim.pack.add { 'https://github.com/folke/flash.nvim' }

---@module 'flash'
---@type Flash.Config
---@diagnostic disable-next-line: missing-fields
local opts = {}
require('flash').setup(opts)

-- stylua: ignore start
vim.keymap.set({ 'n', 'x', 'o' }, 's', function() require('flash').jump() end, { desc = 'Flash' })
vim.keymap.set({ 'n', 'x', 'o' }, 'S', function() require('flash').treesitter() end, { desc = 'Flash Treesitter' })
vim.keymap.set('o', 'r', function() require('flash').remote() end, { desc = 'Remote Flash' })
vim.keymap.set({ 'o', 'x' }, 'R', function() require('flash').treesitter_search() end, { desc = 'Treesitter Search' })
vim.keymap.set('c', '<c-s>', function() require('flash').toggle() end, { desc = 'Toggle Flash Search' })
-- stylua: ignore end

-- vim: ts=2 sts=2 sw=2 et
