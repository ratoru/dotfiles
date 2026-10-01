vim.pack.add { 'https://github.com/folke/tokyonight.nvim' }

---@module 'tokyonight'
---@type tokyonight.Config
---@diagnostic disable-next-line: missing-fields
local opts = {
  style = 'night',
  styles = {
    comments = { italic = false },
  },
}
require('tokyonight').setup(opts)
vim.cmd.colorscheme 'tokyonight'

-- vim: ts=2 sts=2 sw=2 et
