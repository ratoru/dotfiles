---@module 'lazy'
---@type LazySpec
return {
  '2kabhishek/seeker.nvim',
  dependencies = { 'folke/snacks.nvim' },
  cmd = { 'Seeker' },
  keys = {
    { '<leader>ff', ':Seeker files<CR>', desc = 'Seek Files' },
    { '<leader>fg', ':Seeker git_files<CR>', desc = 'Seek Git Files' },
    { '<leader>sg', ':Seeker grep<CR>', desc = 'Seek Grep' },
    { '<leader>/', ':Seeker grep<CR>', desc = 'Seek Grep' },
  },
  opts = {}, -- Required unless you call seeker.setup() manually, add your configs here
}
