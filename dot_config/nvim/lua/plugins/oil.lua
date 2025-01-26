return {
  {
    'stevearc/oil.nvim',
    lazy = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      columns = { 'icon' },
      keymaps = {
        ['<C-h>'] = false,
        ['<C-l>'] = false,
        ['<C-k>'] = false,
        ['<C-j>'] = false,
        ['<M-h>'] = 'actions.select_split',
        ['q'] = { 'actions.close', mode = 'n' },
      },
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = true,
      },
    },
    keys = {
      { '-', '<CMD>Oil<CR>', mode = 'n', desc = 'Open parent directory' },
    },
  },
}
