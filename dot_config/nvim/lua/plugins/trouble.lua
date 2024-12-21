return {
  'folke/trouble.nvim',
  opts = {
    auto_close = true,
    focus = true,
  }, -- for default options, refer to the configuration section for custom setup.
  cmd = 'Trouble',
  keys = {
    {
      '<leader>xx',
      '<cmd>Trouble diagnostics toggle<cr>',
      desc = 'Diagnostics',
    },
    {
      '<leader>xX',
      '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
      desc = 'Buffer Diagnostics',
    },
    {
      '<leader>cs',
      '<cmd>Trouble symbols toggle focus=false<cr>',
      desc = 'Symbols',
    },
    {
      '<leader>cl',
      '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
      desc = 'LSP Definitions, references, ...',
    },
    {
      '<leader>xL',
      '<cmd>Trouble loclist toggle<cr>',
      desc = 'Location List',
    },
    {
      '<leader>xQ',
      '<cmd>Trouble qflist toggle<cr>',
      desc = 'Quickfix List',
    },
  },
}