---@module 'lazy'
---@type LazySpec
return {
  'folke/zen-mode.nvim',
  cmd = 'ZenMode',
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  keys = {
    { '<leader>tz', '<cmd>ZenMode<cr>', desc = 'Toggle [Z]enMode' },
  },
}
