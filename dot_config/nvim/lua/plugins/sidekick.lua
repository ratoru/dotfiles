if not vim.g.ai_enabled then
  return
end

-- Depends on: plugins.copilot
vim.pack.add { 'https://github.com/folke/sidekick.nvim' }
require('sidekick').setup {}

vim.keymap.set('n', '<tab>', function()
  -- if there is a next edit, jump to it, otherwise apply it if any
  if not require('sidekick').nes_jump_or_apply() then
    return '<Tab>' -- fallback to normal tab
  end
end, { expr = true, desc = 'Goto/Apply Next Edit Suggestion' })

local cli = function() return require 'sidekick.cli' end
vim.keymap.set({ 'n', 't', 'i', 'x' }, '<c-.>', function() cli().toggle() end, { desc = 'Sidekick Toggle' })
vim.keymap.set('n', '<leader>aa', function() cli().toggle() end, { desc = 'Sidekick Toggle CLI' })
vim.keymap.set('n', '<leader>as', function() cli().select { filter = { installed = true } } end, { desc = 'Select CLI' })
vim.keymap.set('n', '<leader>ad', function() cli().close() end, { desc = 'Detach a CLI Session' })
vim.keymap.set({ 'x', 'n' }, '<leader>at', function() cli().send { msg = '{this}' } end, { desc = 'Send This' })
vim.keymap.set('n', '<leader>af', function() cli().send { msg = '{file}' } end, { desc = 'Send File' })
vim.keymap.set('x', '<leader>av', function() cli().send { msg = '{selection}' } end, { desc = 'Send Visual Selection' })
vim.keymap.set({ 'n', 'x' }, '<leader>ap', function() cli().prompt() end, { desc = 'Sidekick Select Prompt' })
-- Example of a keybinding to open Claude directly
vim.keymap.set('n', '<leader>ac', function() cli().toggle { name = 'claude', focus = true } end, { desc = 'Sidekick Toggle Claude' })

-- vim: ts=2 sts=2 sw=2 et
