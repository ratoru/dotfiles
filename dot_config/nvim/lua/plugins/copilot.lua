if not vim.g.ai_enabled then
  return
end

-- Run `:Copilot auth` once after first install.
vim.pack.add { 'https://github.com/zbirenbaum/copilot.lua' }

require('copilot').setup {
  suggestion = { enabled = false },
  panel = { enabled = false },
}

-- vim: ts=2 sts=2 sw=2 et
