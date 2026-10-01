vim.pack.add { { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' } }

require('catppuccin').setup {
  flavor = 'mocha',
  integrations = {
    flash = true,
    neotree = true,
    lsp_trouble = true,
    which_key = true,
    blink_cmp = true,
    grug_far = true,
  },
}
-- vim.cmd.colorscheme 'catppuccin'

-- vim: ts=2 sts=2 sw=2 et
