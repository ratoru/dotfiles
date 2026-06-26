---@module 'lazy'
---@type LazySpec
return {
  'zbirenbaum/copilot.lua',
  enabled = function() return vim.g.ai_enabled end,
  cmd = 'Copilot',
  build = ':Copilot auth',
  -- Load on file-open as well as insert, so its copilot client (which drives
  -- both blink-copilot completions and sidekick NES) is ready before first edit.
  event = { 'InsertEnter', 'BufReadPost', 'BufNewFile' },
  opts = {
    suggestion = { enabled = false },
    panel = { enabled = false },
  },
}
