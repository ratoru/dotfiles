return {
  'ThePrimeagen/refactoring.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {},
  keys = {
    {
      '<leader>cr',
      function()
        require('refactoring').select_refactor {}
      end,
      mode = { 'n', 'x' },
      desc = '[R]efactor',
    },
  },
}
