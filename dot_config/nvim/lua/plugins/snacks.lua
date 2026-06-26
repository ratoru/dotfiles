---@module 'lazy'
---@type LazySpec
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
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
        { section = 'startup' },
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
  },
  keys = {
    -- Non-picker snacks features (picker keymaps now live in plugins/fzf.lua)
    {
      '<leader>.',
      function() Snacks.scratch() end,
      desc = 'Toggle Scratch Buffer',
    },
    {
      '<leader>hx',
      function() Snacks.gitbrowse() end,
      desc = 'git - open file in browser',
    },
    {
      '<leader>hl',
      function() Snacks.lazygit() end,
      desc = 'lazygit',
    },
    {
      '<leader>bd',
      function() Snacks.bufdelete() end,
      desc = 'Close buffer',
    },
    {
      '<leader>e',
      function() Snacks.explorer() end,
      desc = 'File Explorer',
    },
  },
  init = function()
    -- Lets LSP clients know that a file has been renamed
    vim.api.nvim_create_autocmd('User', {
      pattern = 'OilActionsPost',
      callback = function(event)
        if event.data.actions[1].type == 'move' then
          Snacks.rename.on_rename_file(event.data.actions[1].src_url, event.data.actions[1].dest_url)
        end
      end,
    })
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function()
        -- Create some toggle mappings
        Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>us'
        Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>uw'
      end,
    })
  end,
}
