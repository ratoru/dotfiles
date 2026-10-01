vim.pack.add { 'https://github.com/folke/trouble.nvim' }

---@module 'trouble'
---@type trouble.Config
local opts = {
  auto_close = true,
  focus = true,
}
require('trouble').setup(opts)

local function map(lhs, rhs, desc) vim.keymap.set('n', lhs, rhs, { desc = desc }) end
map('<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', 'Diagnostics')
map('<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', 'Buffer Diagnostics')
map('<leader>cs', '<cmd>Trouble symbols toggle focus=false<cr>', 'Symbols')
map('<leader>cl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', 'LSP Definitions, references, ...')
map('<leader>xL', '<cmd>Trouble loclist toggle<cr>', 'Location List')
map('<leader>xQ', '<cmd>Trouble qflist toggle<cr>', 'Quickfix List')

-- vim: ts=2 sts=2 sw=2 et
