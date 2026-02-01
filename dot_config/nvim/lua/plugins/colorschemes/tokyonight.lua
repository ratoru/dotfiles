---@module 'lazy'
---@type LazySpec
return {
  'folke/tokyonight.nvim',
  priority = 1000,
  opts = {
    style = 'night',
    styles = {
      comments = { italic = false },
    },
  },
  config = function(_, opts)
    require('tokyonight').setup(opts)
    vim.cmd.colorscheme 'tokyonight'
  end,
}
-- vim: ts=2 sts=2 sw=2 et
