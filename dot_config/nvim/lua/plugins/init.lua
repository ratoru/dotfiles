-- [[ Configure and install plugins ]]
--
--  Each module calls `vim.pack.add()` for its own plugins, then sets them up.
--  Order matters: dependencies must be required before their dependents.
--
--  Update plugins:   :lua vim.pack.update()
--  Inspect state:    :lua vim.pack.update(nil, { offline = true })
--  Remove a plugin:  delete its require below, then :lua vim.pack.del({ 'name' })
--  Health:           :checkhealth vim.pack

-- Load a plugin module after startup (once the first screen is drawn).
-- Only for plugins reached by keymap/command, never needed before the first keypress.
local later = function(mod)
  vim.schedule(function() require(mod) end)
end

-- Shared dependencies first
require 'plugins.mini' -- mini.icons is used by oil, fzf, grapple, render-markdown

-- UI that must be ready before the first redraw
-- require 'plugins.colorschemes.catppuccin'
-- require 'plugins.colorschemes.gruvbox'
-- require 'plugins.colorschemes.kanagawa'
require 'plugins.colorschemes.tokyonight'
-- require 'plugins.colorschemes.vague'
require 'plugins.snacks' -- dashboard + `Snacks` global
require 'plugins.which-key'

-- Treesitter
require 'plugins.treesitter'
require 'plugins.treesitter-textobjects'
require 'plugins.treesitter-context'

-- Completion & LSP
require 'plugins.lazydev'
require 'plugins.copilot' -- no-op unless vim.g.ai_enabled
require 'plugins.blink-cmp'
require 'plugins.fzf'
require 'plugins.lspconfig'
require 'plugins.conform'
require 'plugins.lint'

-- Git
require 'plugins.gitsigns'

-- Editing & navigation
require 'plugins.guess-indent'
require 'plugins.oil'
require 'plugins.grapple'
require 'plugins.flash'
require 'plugins.todo-comments'
require 'plugins.autopairs'
require 'plugins.render-markdown'
require 'plugins.sidekick' -- no-op unless vim.g.ai_enabled

-- Statusline last: reads Snacks, grapple and sidekick
require 'plugins.lualine'

-- Deferred until after startup
later 'plugins.diffview'
later 'plugins.grug-far'
later 'plugins.trouble'
later 'plugins.treesj'
later 'plugins.neogen'
later 'plugins.refactoring'

-- vim: ts=2 sts=2 sw=2 et
