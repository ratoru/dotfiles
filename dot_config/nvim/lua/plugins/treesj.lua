---@module 'lazy'
---@type LazySpec
return {
  'Wansmer/treesj',
  dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`
  opts = {},
  keys = {
    {
      '<leader>tm',
      function() require('treesj').toggle() end,
      desc = 'split / join code block',
    },
    {
      '<leader>tM',
      function() require('treesj').toggle { split = { recursive = true } } end,
      desc = 'split / join code block rec',
    },
  },
}
