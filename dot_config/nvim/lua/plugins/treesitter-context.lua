return {
  'nvim-treesitter/nvim-treesitter-context',
  config = function()
    require('treesitter-context').setup {
      max_lines = 6,
      multiline_threshold = 2,
    }
    vim.keymap.set('n', '[c', function()
      require('treesitter-context').go_to_context(vim.v.count1)
    end, { silent = true, desc = 'Go to [c]ontext' })
  end,
}
