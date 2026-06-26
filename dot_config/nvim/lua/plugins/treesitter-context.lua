---@module 'lazy'
---@type LazySpec
return {
  'nvim-treesitter/nvim-treesitter-context',
  config = function()
    require('treesitter-context').setup {
      max_lines = 6,
      multiline_threshold = 2,
    }
    -- NOTE: [c / ]c are left as the built-in diff change-navigation mappings.
    vim.keymap.set('n', '[x', function() require('treesitter-context').go_to_context(vim.v.count1) end, { silent = true, desc = 'Go to conte[x]t' })
  end,
}
