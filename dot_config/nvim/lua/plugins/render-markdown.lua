-- Depends on: plugins.mini (icons), plugins.treesitter, plugins.snacks (toggle)
vim.pack.add { 'https://github.com/MeanderingProgrammer/render-markdown.nvim' }

---@module 'render-markdown'
---@type render.md.UserConfig
local opts = {
  completions = { lsp = { enabled = true } },
}
require('render-markdown').setup(opts)

Snacks.toggle({
  name = 'Render Markdown',
  get = function() return require('render-markdown').get() end,
  set = function(state) require('render-markdown').set(state) end,
}):map '<leader>tm'

-- vim: ts=2 sts=2 sw=2 et
