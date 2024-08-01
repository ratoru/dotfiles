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
    config = function(_, opts)
      local mocha = require('catppuccin.palettes').get_palette 'mocha'

      opts.highlights = require('catppuccin.groups.integrations.bufferline').get {
        styles = { 'italic', 'bold' },
        custom = {
          all = {
            fill = { bg = '#000000' },
          },
          mocha = {
            background = { fg = mocha.text },
          },
          latte = {
            background = { fg = '#000000' },
          },
        },
      }
      require('bufferline').setup(opts)

      -- Buffer navigation.
      vim.keymap.set('n', '[b', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Previous buffer' })
      vim.keymap.set('n', ']b', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next buffer' })
      require('which-key').add {
        -- { '<leader>bc', '<cmd>BufferLinePickClose<cr>', desc = 'Select a buffer to close' },
        {
          '<leader>bd',
          function()
            require('mini.bufremove').delete(0, true)
          end,
          desc = 'Delete current buffer',
        },
        { '<leader>bl', '<cmd>BufferLineCloseLeft<cr>', desc = 'Close buffers to the left' },
        -- { '<leader>bo', '<cmd>BufferLinePick<cr>', desc = 'Select a buffer to open' },
        { '<leader>bp', '<cmd>BufferLineTogglePin<cr>', desc = 'Pin buffer' },
        { '<leader>br', '<cmd>BufferLineCloseRight<cr>', desc = 'Close buffers to the right' },
        { '<leader>b1', '<cmd>BufferLineGoToBuffer 1<cr>', desc = 'Go to first buffer in view', hidden = true },
        { '<leader>b2', '<cmd>BufferLineGoToBuffer 2<cr>', desc = 'Go to first buffer in view', hidden = true },
        { '<leader>b3', '<cmd>BufferLineGoToBuffer 3<cr>', desc = 'Go to first buffer in view', hidden = true },
        { '<leader>b4', '<cmd>BufferLineGoToBuffer 4<cr>', desc = 'Go to first buffer in view', hidden = true },
      }
    end,
  },
}
