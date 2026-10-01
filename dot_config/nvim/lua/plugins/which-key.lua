-- Useful plugin to show you pending keybinds.
vim.pack.add { 'https://github.com/folke/which-key.nvim' }

---@module 'which-key'
---@type wk.Opts
---@diagnostic disable-next-line: missing-fields
local opts = {
  -- delay between pressing a key and opening which-key (milliseconds)
  -- this setting is independent of vim.o.timeoutlen
  delay = 0,
  icons = { mappings = vim.g.have_nerd_font },

  -- Document existing key chains
  spec = {
    { '<leader>a', group = 'AI', icon = '' },
    { '<leader>b', group = 'Buffer' },
    { '<leader>c', group = 'Code', mode = { 'n', 'x' } },
    -- { '<leader>d', group = 'Document' },
    { '<leader>f', group = 'Find' },
    { '<leader>g', group = 'Git' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
    { '<leader>o', group = 'Open', icon = '󱡀' },
    { '<leader>s', group = 'Search', mode = { 'n', 'v' } },
    { '<leader>u', group = 'UI' },
    { '<leader>w', group = 'Workspace' },
    { '<leader>t', group = 'Toggle' },
    { '<leader>x', group = 'Diagnostic' },
    { '<leader>z', group = 'Zettelkasten', icon = '' },
    { '<leader>R', group = 'Http' },
    -- { 'gr', group = 'LSP Actions', mode = { 'n' } },
  },
}
require('which-key').setup(opts)

-- vim: ts=2 sts=2 sw=2 et
