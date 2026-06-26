---@module 'lazy'
---@type LazySpec
return {
  'ThePrimeagen/refactoring.nvim',
  dependencies = {
    'lewis6991/async.nvim',
  },
  opts = {},
  keys = {
    {
      '<leader>cr',
      function() require('refactoring').select_refactor {} end,
      mode = { 'n', 'x' },
      desc = '[R]efactor',
    },
  },
}
