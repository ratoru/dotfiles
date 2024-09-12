-- Sets up Copilot. Uses lua alternative of official repo.
-- TODO: compare this setup: https://github.com/fredrikaverpil/dotfiles/blob/main/nvim-fredrik/lua/plugins/copilot.lua
return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  build = ':Copilot auth',
  event = 'InsertEnter',
  opts = {
    -- setup for usage with cmp
    suggestion = { enabled = false },
    panel = { enabled = false },
    filetypes = {
      beancount = false,
      ledger = false,
    },
  },
}
