-- Depends on: plugins.treesitter
vim.pack.add {
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects', version = 'main' },
}

---@module 'nvim-treesitter-textobjects'
---@type TSTextObjects.UserConfig
local opts = {
  select = {
    -- Automatically jump forward to textobj, similar to targets.vim
    lookahead = true,
  },
  move = {
    set_jumps = true, -- whether to set jumps in the jumplist
  },
}
require('nvim-treesitter-textobjects').setup(opts)

local select = function(query) return function() require('nvim-treesitter-textobjects.select').select_textobject(query, 'textobjects') end end
local swap_next = function(query) return function() require('nvim-treesitter-textobjects.swap').swap_next(query) end end
local swap_prev = function(query) return function() require('nvim-treesitter-textobjects.swap').swap_previous(query) end end
local move = function(fn, query, group)
  return function() require('nvim-treesitter-textobjects.move')[fn](query, group or 'textobjects') end
end

-- stylua: ignore start
-- Select keymaps
local xo = { 'x', 'o' }
vim.keymap.set(xo, 'i=', select '@assignment.inner', { desc = 'Select inner part of an assignment' })
vim.keymap.set(xo, 'l=', select '@assignment.lhs', { desc = 'Select left hand side of an assignment' })
vim.keymap.set(xo, 'r=', select '@assignment.rhs', { desc = 'Select right hand side of an assignment' })
vim.keymap.set(xo, 'aa', select '@parameter.outer', { desc = 'Select outer part of a parameter/argument' })
vim.keymap.set(xo, 'ia', select '@parameter.inner', { desc = 'Select inner part of a parameter/argument' })
vim.keymap.set(xo, 'ai', select '@conditional.outer', { desc = 'Select outer part of a conditional' })
vim.keymap.set(xo, 'ii', select '@conditional.inner', { desc = 'Select inner part of a conditional' })
vim.keymap.set(xo, 'al', select '@loop.outer', { desc = 'Select outer part of a loop' })
vim.keymap.set(xo, 'il', select '@loop.inner', { desc = 'Select inner part of a loop' })
vim.keymap.set(xo, 'af', select '@call.outer', { desc = 'Select outer part of a function call' })
vim.keymap.set(xo, 'if', select '@call.inner', { desc = 'Select inner part of a function call' })
vim.keymap.set(xo, 'am', select '@function.outer', { desc = 'Select outer part of a method/function definition' })
vim.keymap.set(xo, 'im', select '@function.inner', { desc = 'Select inner part of a method/function definition' })
vim.keymap.set(xo, 'ac', select '@class.outer', { desc = 'Select outer part of a class' })
vim.keymap.set(xo, 'ic', select '@class.inner', { desc = 'Select inner part of a class' })
vim.keymap.set(xo, 'a=', select '@assignment.outer', { desc = 'Select outer part of an assignment' })

-- Swap keymaps
vim.keymap.set('n', '<leader>cp', swap_next '@parameter.inner', { desc = 'Swap parameters/argument with next' })
vim.keymap.set('n', '<leader>cf', swap_next '@function.outer', { desc = 'Swap function with next' })
vim.keymap.set('n', '<leader>cP', swap_prev '@parameter.inner', { desc = 'Swap parameters/argument with previous' })
vim.keymap.set('n', '<leader>cF', swap_prev '@function.outer', { desc = 'Swap function with previous' })

-- Move keymaps - goto_next_start
vim.keymap.set('n', ']f', move('goto_next_start', '@call.outer'), { desc = 'Next function call start' })
vim.keymap.set('n', ']m', move('goto_next_start', '@function.outer'), { desc = 'Next method/function def start' })
vim.keymap.set('n', ']]', move('goto_next_start', '@class.outer'), { desc = 'Next class start' })
vim.keymap.set('n', ']i', move('goto_next_start', '@conditional.outer'), { desc = 'Next conditional start' })
vim.keymap.set('n', ']o', move('goto_next_start', '@loop.outer'), { desc = 'Next loop start' })
vim.keymap.set('n', ']s', move('goto_next_start', '@local.scope', 'locals'), { desc = 'Next scope' })
vim.keymap.set('n', ']z', move('goto_next_start', '@fold', 'folds'), { desc = 'Next fold' })
-- Move keymaps - goto_next_end
vim.keymap.set('n', ']F', move('goto_next_end', '@call.outer'), { desc = 'Next function call end' })
vim.keymap.set('n', ']M', move('goto_next_end', '@function.outer'), { desc = 'Next method/function def end' })
vim.keymap.set('n', '][', move('goto_next_end', '@class.outer'), { desc = 'Next class end' })
vim.keymap.set('n', ']I', move('goto_next_end', '@conditional.outer'), { desc = 'Next conditional end' })
vim.keymap.set('n', ']O', move('goto_next_end', '@loop.outer'), { desc = 'Next loop end' })
-- Move keymaps - goto_previous_start
vim.keymap.set('n', '[f', move('goto_previous_start', '@call.outer'), { desc = 'Prev function call start' })
vim.keymap.set('n', '[m', move('goto_previous_start', '@function.outer'), { desc = 'Prev method/function def start' })
vim.keymap.set('n', '[[', move('goto_previous_start', '@class.outer'), { desc = 'Prev class start' })
vim.keymap.set('n', '[i', move('goto_previous_start', '@conditional.outer'), { desc = 'Prev conditional start' })
vim.keymap.set('n', '[o', move('goto_previous_start', '@loop.outer'), { desc = 'Prev loop start' })
-- Move keymaps - goto_previous_end
vim.keymap.set('n', '[F', move('goto_previous_end', '@call.outer'), { desc = 'Prev function call end' })
vim.keymap.set('n', '[M', move('goto_previous_end', '@function.outer'), { desc = 'Prev method/function def end' })
vim.keymap.set('n', '[]', move('goto_previous_end', '@class.outer'), { desc = 'Prev class end' })
vim.keymap.set('n', '[I', move('goto_previous_end', '@conditional.outer'), { desc = 'Prev conditional end' })
vim.keymap.set('n', '[O', move('goto_previous_end', '@loop.outer'), { desc = 'Prev loop end' })
-- stylua: ignore end

-- vim: ts=2 sts=2 sw=2 et
