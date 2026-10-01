vim.pack.add { 'https://github.com/MagicDuck/grug-far.nvim' }

---@module 'grug-far'
---@type grug.far.OptionsOverride
local opts = { headerMaxWidth = 80 }
require('grug-far').setup(opts)

vim.keymap.set({ 'n', 'v' }, '<leader>sr', function()
  local grug = require 'grug-far'
  local ext = vim.bo.buftype == '' and vim.fn.expand '%:e'
  grug.open {
    transient = true,
    prefills = {
      filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
    },
  }
end, { desc = 'Search and Replace' })

-- vim: ts=2 sts=2 sw=2 et
