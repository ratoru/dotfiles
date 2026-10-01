-- Highlight todo, notes, etc in comments
vim.pack.add {
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/folke/todo-comments.nvim',
}

---@module 'todo-comments'
---@type TodoOptions
---@diagnostic disable-next-line: missing-fields
local opts = { signs = false }
require('todo-comments').setup(opts)

-- vim: ts=2 sts=2 sw=2 et
