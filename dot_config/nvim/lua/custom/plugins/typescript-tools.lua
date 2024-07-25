return {
  -- This plugin serves as a replacement for typescript-language-server,
  -- so you should remove the nvim-lspconfig setup for it.
  'pmizio/typescript-tools.nvim',
  lazy = true,
  ft = { 'typescript', 'typescriptreact' },
  dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  opts = {},
}
