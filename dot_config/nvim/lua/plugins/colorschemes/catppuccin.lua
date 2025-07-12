---@module 'lazy'
---@type LazySpec
return {
  'catppuccin/nvim',
  -- Make sure to load this before all the other start plugins.
  -- priority = 1000,

  config = function()
    require('catppuccin').setup {
      flavor = 'mocha',
      integrations = {
        flash = true,
        harpoon = true,
        neotree = true,
        lsp_trouble = true,
        which_key = true,
        blink_cmp = true,
        grug_far = true,
      },
    }
    -- Load the colorscheme here.
    -- Like many other themes, this one has different styles, and you could load
    -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
    -- vim.cmd.colorscheme 'onedark'
  end,
}
