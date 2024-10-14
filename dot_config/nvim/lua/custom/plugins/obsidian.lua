return {
  'epwalsh/obsidian.nvim',
  version = '*', -- recommended, use latest release instead of latest commit
  lazy = true,
  -- Only load obsidian.nvim for markdown files in your vault:
  event = {
    -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    -- refer to `:h file-pattern` for more examples
    'BufReadPre '
      .. vim.fn.expand '~'
      .. '/Documents/Notes/*.md',
    'BufNewFile ' .. vim.fn.expand '~' .. '/Documents/Notes/*.md',
    'BufReadPre ' .. vim.fn.expand '~' .. '/Documents/People/*.md',
    'BufNewFile ' .. vim.fn.expand '~' .. '/Documents/People/*.md',
  },
  dependencies = {
    -- Required.
    'nvim-lua/plenary.nvim',

    -- Optional.
    'hrsh7th/nvim-cmp',
    'nvim-telescope/telescope.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {
    workspaces = {
      {
        name = 'personal',
        path = '~/Documents/Notes',
      },
      {
        name = 'people',
        path = '~/Documents/People',
      },
    },

    -- see below for full list of options 👇
    daily_notes = {
      -- Optional, if you keep daily notes in a separate directory.
      folder = './400 Daily Notes',
      -- Optional, default tags to add to each new daily note created.
      default_tags = { 'journal' },
      -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
      template = '~/Documents/Notes/800 Templates/Daily Note Template Deutsch.md',
    },

    templates = {
      folder = './800 Templates',
      date_format = '%Y-%m-%d',
      time_format = '%H:%M',
      -- A map for custom variables, the key should be the variable and the value a function
      substitutions = {},
    },
  },
}
