-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
-- used for completion, annotations and signatures of Neovim apis
vim.pack.add { 'https://github.com/folke/lazydev.nvim' }

---@module 'lazydev'
---@type lazydev.Config
---@diagnostic disable-next-line: missing-fields
local opts = {
  library = {
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    { path = 'snacks.nvim', words = { 'Snacks' } },
  },
}
require('lazydev').setup(opts)

-- vim: ts=2 sts=2 sw=2 et
