return {
  'danymat/neogen',
  opts = {
    snippet_engine = 'luasnip',
  },
  -- Uncomment next line if you want to follow only stable versions
  -- version = "*"
  keys = {
    {
      '<leader>cd',
      '<cmd>Neogen<cr>',
      desc = 'Generate [d]oc comments',
    },
  },
}
