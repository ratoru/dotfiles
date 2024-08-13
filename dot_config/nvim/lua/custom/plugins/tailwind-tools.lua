return {
  'luckasRanarison/tailwind-tools.nvim',
  name = 'tailwind-tools',
  build = ':UpdateRemotePlugins',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-telescope/telescope.nvim', -- optional
  },
  opts = {}, -- your configuration
  ft = { 'html', 'css', 'javascript', 'typescript', 'vue', 'astro', 'typescriptreact', 'javascriptreact' },
}
