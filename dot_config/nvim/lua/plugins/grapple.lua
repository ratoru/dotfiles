local function grapple_select(index)
  -- Implements an auto-back-and-forth functionality.
  -- Toggling the same file twice brings you back to the previous file.
  local grapple = require 'grapple'
  if grapple.exists() and grapple.find { index = index } == grapple.find { buffer = 0 } then
    vim.cmd.buffer '#'
  else
    grapple.select { index = index }
  end
end

---@module 'lazy'
---@type LazySpec
return {
  'cbochs/grapple.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event = { 'BufReadPost', 'BufNewFile' },
  cmd = 'Grapple',
  opts = {
    scope = 'git_branch',
    icons = true,
    status = true,
  },
  keys = {
    {
      '<leader>;',
      function() require('grapple').toggle() end,
      desc = 'Tag a file',
    },
    {
      '<C-E>',
      function() require('grapple').toggle_tags() end,
      desc = 'Toggle grapple tags menu',
    },
    {
      '<C-S>n',
      function() require('grapple').cycle_tags 'next' end,
      desc = 'Next tag',
    },
    {
      '<C-S>p',
      function() require('grapple').cycle_tags 'prev' end,
      desc = 'Previous tag',
    },
    {
      '<leader>1',
      function() grapple_select(1) end,
      desc = 'which_key_ignore',
    },
    {
      '<leader>2',
      function() grapple_select(2) end,
      desc = 'which_key_ignore',
    },
    {
      '<leader>3',
      function() grapple_select(3) end,
      desc = 'which_key_ignore',
    },
    {
      '<leader>4',
      function() grapple_select(4) end,
      desc = 'which_key_ignore',
    },
    {
      '<leader>5',
      function() grapple_select(5) end,
      desc = 'which_key_ignore',
    },
    {
      '<leader>6',
      function() grapple_select(6) end,
      desc = 'which_key_ignore',
    },
    {
      '<leader>7',
      function() grapple_select(7) end,
      desc = 'which_key_ignore',
    },
    {
      '<leader>8',
      function() grapple_select(8) end,
      desc = 'which_key_ignore',
    },
    {
      '<leader>9',
      function() grapple_select(9) end,
      desc = 'which_key_ignore',
    },
  },
}
