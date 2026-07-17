---@module 'lazy'
---@type LazySpec
return {
  'OXY2DEV/markview.nvim',
  lazy = false,
  -- Completion for `blink.cmp`
  dependencies = { 'saghen/blink.cmp' },
  opts = {
    preview = {
      icon_provider = 'mini',
      filetype = { 'markdown', 'markdown.mdx' },
    },
  },
  keys = {
    {
      '<leader>tm',
      '<CMD>Markview<CR>',
      desc = 'Toggle Markdown preview',
    },
  },
}
