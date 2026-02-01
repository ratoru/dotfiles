---@module 'lazy'
---@type LazySpec
return {
  'Wansmer/treesj',
  dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`
  opts = {},
  keys = {
    {
      '<leader>cm',
      function() require('treesj').toggle() end,
      desc = 'Split / join code block',
    },
    {
      '<leader>cM',
      function() require('treesj').toggle { split = { recursive = true } } end,
      desc = 'Split / join code block rec',
    },
  },
}
