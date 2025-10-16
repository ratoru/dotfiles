---@module 'lazy'
---@type LazySpec
return {
  'Bekaboo/dropbar.nvim',
  event = 'VeryLazy',
  opts = {
    sources = {
      treesitter = {
        max_depth = 1,
      },
      lsp = {
        max_depth = 1,
      },
    },
  },
}
