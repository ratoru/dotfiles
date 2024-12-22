return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    indent = { animate = { enabled = false } },
    scratch = { enabled = true },
    dashboard = {
      sections = {
        { section = 'header' },
        {
          pane = 2,
          section = 'terminal',
          -- cmd = 'colorscript -e square',
          cmd = 'cat /etc/motd',
          height = 5,
          padding = 1,
        },
        { section = 'keys', gap = 1, padding = 1 },
        { pane = 2, icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
        { pane = 2, icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
        {
          pane = 2,
          icon = ' ',
          title = 'Git Status',
          section = 'terminal',
          enabled = function()
            return Snacks.git.get_root() ~= nil
          end,
          cmd = 'git status --short --branch --renames',
          height = 5,
          padding = 1,
          ttl = 5 * 60,
          indent = 3,
        },
        { section = 'startup' },
      },
    },
    lazygit = {},
  },
  keys = {
    {
      '<leader>.',
      function()
        Snacks.scratch()
      end,
      desc = 'Toggle Scratch Buffer',
    },
    {
      '<leader>hx',
      function()
        Snacks.gitbrowse()
      end,
      desc = 'git - open file in browser',
    },
    {
      '<leader>hl',
      function()
        Snacks.lazygit()
      end,
      desc = 'lazygit',
    },
  },
}
