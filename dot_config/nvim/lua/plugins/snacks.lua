-- Loaded early: provides the dashboard and the `Snacks` global used by other modules (e.g. lualine).
vim.pack.add { 'https://github.com/folke/snacks.nvim' }

---@module 'snacks'
---@type snacks.Config
local opts = {
  dashboard = {
    -- Keep snacks' default buttons + icons; just route their pickers to fzf-lua.
    preset = {
      pick = function(cmd, opts)
        -- "Recent Files" (r) -> frecency; everything else -> matching fzf-lua picker
        if cmd == 'oldfiles' then
          return require('fzf-lua-frecency').frecency(opts)
        end
        return require('fzf-lua')[cmd or 'files'](opts)
      end,
    },
    sections = {
      { icon = ' ', title = 'Keymaps', section = 'keys', indent = 2, padding = 1 },
      { icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
      -- Replaces snacks' `startup` section, which reads lazy.nvim's stats.
      function()
        -- Like lazy.nvim: process CPU time (user + system) when the dashboard is first drawn on UIEnter.
        -- Cached so redraws (e.g. on resize) keep the startup value.
        if not vim.g.startuptime_ms then
          local ru = vim.uv.getrusage()
          vim.g.startuptime_ms = (ru.utime.sec + ru.stime.sec) * 1e3 + (ru.utime.usec + ru.stime.usec) / 1e3
        end
        local plugins = vim.pack.get()
        local loaded = #vim.tbl_filter(function(p) return p.active end, plugins)
        return {
          align = 'center',
          text = {
            { '⚡ Neovim loaded ', hl = 'footer' },
            { loaded .. '/' .. #plugins, hl = 'special' },
            { ' plugins in ', hl = 'footer' },
            { ('%.2fms'):format(vim.g.startuptime_ms), hl = 'special' },
          },
        }
      end,
    },
  },
  explorer = {
    replace_netrw = false,
  },
  gh = {},
  image = {},
  input = {},
  lazygit = {},
  -- fzf-lua owns vim.ui.select (see plugins/fzf.lua register_ui_select)
  picker = { ui_select = false },
  scratch = { enabled = true },
  toggle = {},
}
require('snacks').setup(opts)

-- Lets LSP clients know that a file has been renamed
vim.api.nvim_create_autocmd('User', {
  pattern = 'OilActionsPost',
  callback = function(event)
    if event.data.actions[1].type == 'move' then
      Snacks.rename.on_rename_file(event.data.actions[1].src_url, event.data.actions[1].dest_url)
    end
  end,
})

-- Toggle mappings
Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>us'
Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>uw'

-- Non-picker snacks features (picker keymaps live in plugins/fzf.lua)
vim.keymap.set('n', '<leader>.', function() Snacks.scratch() end, { desc = 'Toggle Scratch Buffer' })
vim.keymap.set('n', '<leader>hx', function() Snacks.gitbrowse() end, { desc = 'git - open file in browser' })
vim.keymap.set('n', '<leader>hl', function() Snacks.lazygit() end, { desc = 'lazygit' })
vim.keymap.set('n', '<leader>bd', function() Snacks.bufdelete() end, { desc = 'Close buffer' })
vim.keymap.set('n', '<leader>e', function() Snacks.explorer() end, { desc = 'File Explorer' })

-- vim: ts=2 sts=2 sw=2 et
