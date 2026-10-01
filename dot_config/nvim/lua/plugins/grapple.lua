-- Depends on: plugins.mini (icons)
vim.pack.add { 'https://github.com/cbochs/grapple.nvim' }

local grapple = require 'grapple'
grapple.setup {
  scope = 'git_branch',
  icons = true,
  status = true,
}

local function grapple_select(index)
  -- Implements an auto-back-and-forth functionality.
  -- Toggling the same file twice brings you back to the previous file.
  if grapple.exists() and grapple.find { index = index } == grapple.find { buffer = 0 } then
    vim.cmd.buffer '#'
  else
    grapple.select { index = index }
  end
end

vim.keymap.set('n', '<leader>;', grapple.toggle, { desc = 'Tag a file' })
vim.keymap.set('n', '<C-E>', grapple.toggle_tags, { desc = 'Toggle grapple tags menu' })
vim.keymap.set('n', '<C-S>n', function() grapple.cycle_tags 'next' end, { desc = 'Next tag' })
vim.keymap.set('n', '<C-S>p', function() grapple.cycle_tags 'prev' end, { desc = 'Previous tag' })
for i = 1, 9 do
  vim.keymap.set('n', '<leader>' .. i, function() grapple_select(i) end, { desc = 'which_key_ignore' })
end

-- vim: ts=2 sts=2 sw=2 et
