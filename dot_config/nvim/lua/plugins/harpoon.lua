---@module 'lazy'
---@type LazySpec
return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {},
  keys = {
    {
      '<leader>om',
      function()
        require('harpoon'):list():add()
      end,
      mode = { 'n' },
      desc = 'Harpoon file',
    },
    {
      '<leader>oa',
      function()
        require('harpoon'):list():select(1)
      end,
      mode = { 'n' },
      desc = 'Open file - 1',
    },
    {
      '<leader>os',
      function()
        require('harpoon'):list():select(2)
      end,
      mode = { 'n' },
      desc = 'Open file - 2',
    },
    {
      '<leader>od',
      function()
        require('harpoon'):list():select(3)
      end,
      mode = { 'n' },
      desc = 'Open file - 3',
    },
    {
      '<leader>of',
      function()
        require('harpoon'):list():select(4)
      end,
      mode = { 'n' },
      desc = 'Open file - 4',
    },
    {
      '<leader>oc',
      function()
        require('harpoon'):list():clear()
      end,
      mode = { 'n' },
      desc = 'Clear all harpoons',
    },
    {
      '<leader>p',
      function()
        require('harpoon'):list():prev()
      end,
      mode = { 'n' },
      desc = 'Open [p]rev harpoon file',
    },
    {
      '<leader>n',
      function()
        require('harpoon'):list():next()
      end,
      mode = { 'n' },
      desc = 'Open [n]ext harpoon file',
    },
    {
      '<C-S-P>',
      function()
        require('harpoon'):list():prev()
      end,
      mode = { 'n' },
      desc = 'Open [p]rev harpoon file',
    },
    {
      '<C-S-N>',
      function()
        require('harpoon'):list():next()
      end,
      mode = { 'n' },
      desc = 'Open [n]ext harpoon file',
    },
    {
      '<C-E>',
      function()
        local harpoon = require 'harpoon'

        local function normalize_list(t)
          local normalized = {}
          for _, v in pairs(t) do
            if v ~= nil then
              table.insert(normalized, v)
            end
          end
          return normalized
        end

        Snacks.picker {
          finder = function()
            local file_paths = {}
            local list = normalize_list(harpoon:list().items)
            for _, item in ipairs(list) do
              table.insert(file_paths, { text = item.value, file = item.value })
            end
            return file_paths
          end,
          win = {
            input = {
              keys = { ['dd'] = { 'harpoon_delete', mode = { 'n', 'x' } } },
            },
            list = {
              keys = { ['dd'] = { 'harpoon_delete', mode = { 'n', 'x' } } },
            },
          },
          actions = {
            harpoon_delete = function(picker, item)
              local to_remove = item or picker:selected()
              harpoon:list():remove { value = to_remove.text }
              harpoon:list().items = normalize_list(harpoon:list().items)
              picker:find { refresh = true }
            end,
          },
        }
      end,
      mode = { 'n' },
      desc = 'Open harpoon window',
    },
  },
}
