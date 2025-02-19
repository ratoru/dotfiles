return {
  'zk-org/zk-nvim',
  dependencies = {
    'folke/snacks.nvim',
  },
  config = function()
    require('zk').setup {
      picker = 'snacks_picker',
    }
  end,
  filetype = 'markdown',
  keys = {
    {
      '<leader>zn',
      function()
        ---@type snacks.input.Opts
        local opts = {
          icon = ' ',
          icon_hl = 'SnacksInputIcon',
          icon_pos = 'left',
          prompt_pos = 'title',
          win = { style = 'input' },
          expand = true,
          prompt = 'Note Title?',
        }

        require('snacks.input').input(opts, function(ans)
          if ans then
            require('zk.commands').get 'ZkNew' { title = ans }
          end
        end)
      end,
      desc = 'Zk New',
    },
    {
      '<leader>zo',
      "<Cmd>ZkNotes { sort = { 'modified' } }<CR>",
      desc = 'Zk Open',
    },
    {
      '<leader>zt',
      '<Cmd>ZkTags<CR>',
      desc = 'Zk Tags',
    },
    {
      '<leader>zs',
      function()
        ---@type snacks.input.Opts
        local opts = {
          icon = '󰱼 ',
          icon_hl = 'SnacksInputIcon',
          icon_pos = 'left',
          prompt_pos = 'title',
          win = { style = 'input' },
          expand = true,
          prompt = 'Search Notes',
        }

        require('snacks.input').input(opts, function(ans)
          if ans then
            require('zk.commands').get 'ZkNotes' { sort = { 'modified' }, match = { ans } }
          end
        end)
      end,
      mode = 'n',
      desc = 'Zk Search',
    },
    {
      '<leader>zs',
      ":'<,'>ZkMatch<CR>",
      mode = 'v',
      desc = 'Zk Search selection',
    },
    {
      '<leader>zl',
      '<Cmd>ZkLinks<CR>',
      desc = 'Zk outbound Links',
    },
    {
      '<leader>zb',
      '<Cmd>ZkBacklinks<CR>',
      desc = 'Zk Backlinks',
    },
  },
}
