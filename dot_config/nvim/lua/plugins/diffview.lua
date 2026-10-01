vim.pack.add { 'https://github.com/sindrets/diffview.nvim' }

---@module 'diffview'
---@type DiffviewConfig
---@diagnostic disable-next-line: missing-fields
local opts = {
  enhanced_diff_hl = true,
  view = {
    merge_tool = {
      layout = 'diff3_mixed',
    },
  },
}
require('diffview').setup(opts)
-- vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<cr>', { desc = 'DiffView' })

-- vim: ts=2 sts=2 sw=2 et
