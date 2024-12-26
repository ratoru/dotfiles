-- Bufferline for pretty tabs.
return {
  {
    'akinsho/bufferline.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'nvim-tree/nvim-web-devicons', 'echasnovski/mini.bufremove' },
    opts = {
      options = {
        close_command = function(bufnr)
          require('mini.bufremove').delete(bufnr, false)
        end,
        right_mouse_command = function(bufnr)
          require('mini.bufremove').delete(bufnr, false)
        end,
        diagnostics = 'nvim_lsp',
      },
    },
    keys = {
      { '[b', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Previous buffer' }, mode = 'n' },
      { ']b', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next buffer' }, mode = 'n' },
      {
        '<leader>bd',
        function()
          require('mini.bufremove').delete(0, true)
        end,
        desc = 'Delete current buffer',
      },
      { '<leader>bl', '<cmd>BufferLineCloseLeft<cr>', desc = 'Close buffers to the left' },
      { '<leader>bp', '<cmd>BufferLineTogglePin<cr>', desc = 'Pin buffer' },
      { '<leader>br', '<cmd>BufferLineCloseRight<cr>', desc = 'Close buffers to the right' },
      { '<leader>1', '<cmd>BufferLineGoToBuffer 1<cr>', desc = 'which_key_ignore' },
      { '<leader>2', '<cmd>BufferLineGoToBuffer 2<cr>', desc = 'which_key_ignore' },
      { '<leader>3', '<cmd>BufferLineGoToBuffer 3<cr>', desc = 'which_key_ignore' },
      { '<leader>4', '<cmd>BufferLineGoToBuffer 4<cr>', desc = 'which_key_ignore' },
      { '<leader>5', '<cmd>BufferLineGoToBuffer 5<cr>', desc = 'which_key_ignore' },
      { '<leader>6', '<cmd>BufferLineGoToBuffer 6<cr>', desc = 'which_key_ignore' },
      { '<leader>7', '<cmd>BufferLineGoToBuffer 7<cr>', desc = 'which_key_ignore' },
    },
  },
}
