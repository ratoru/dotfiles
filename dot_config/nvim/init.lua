-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Set to false on machines without AI access (e.g. no Copilot license).
vim.g.ai_enabled = false

-- Ensure node (installed via mise) is on PATH for LSPs/plugins.
do
  local mise_shims = vim.fn.expand '~/.local/share/mise/shims'
  if vim.fn.isdirectory(mise_shims) == 1 and not (':' .. vim.env.PATH .. ':'):find(':' .. mise_shims .. ':', 1, true) then
    vim.env.PATH = mise_shims .. ':' .. vim.env.PATH
  end
end

-- [[ Setting options ]]
require 'options'
require 'filetype'

-- [[ Basic Keymaps ]]
require 'keymaps'
require 'commands'

-- [[ Install `lazy.nvim` plugin manager ]]
require 'lazy-bootstrap'

-- [[ Configure and install plugins ]]
require 'lazy-plugins'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
