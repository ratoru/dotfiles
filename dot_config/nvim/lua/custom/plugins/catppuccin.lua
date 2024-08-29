return {
  'catppuccin/nvim',
  priority = 1000, -- Make sure to load this before all the other start plugins.

  config = function()
    require('catppuccin').setup {
      flavor = 'mocha',
      -- custom_highlights = function(colors)
      --   return {
      --     VertSplit = { fg = colors.surface0 },
      --     WinSeparator = {
      --       fg = colors.lavender,
      --     },
      --   }
      -- end,
      extensions = {
        flash = true,
        harpoon = true,
        neotree = true,
        lsp_trouble = true,
        which_key = true,
      },
    }
    -- Load the colorscheme here.
    -- Like many other themes, this one has different styles, and you could load
    -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
    -- vim.cmd.colorscheme 'onedark'
    -- vim.cmd.colorscheme 'nightfox'
    -- vim.cmd.colorscheme 'monokai-pro-spectrum'
    vim.cmd.colorscheme 'catppuccin'
    -- vim.cmd.colorscheme 'bamboo'

    -- You can configure highlights by doing something like:
    vim.cmd.hi 'Comment gui=none'
  end,
}
