return {
  'ibhagwan/fzf-lua',
  -- optional for icon support
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local fzf = require 'fzf-lua'
    -- local actions = require 'fzf-lua.actions'

    fzf.setup {
      winopts = {
        preview = {
          default = 'bat',
        },
      },
      fzf_colors = true,
      oldfiles = {
        include_current_session = true,
      },
      previewers = {
        bat = {
          theme = 'Catppuccin Mocha',
        },
      },
    }

    ---@param lhs string
    ---@param rhs string|function
    ---@param desc string
    local function map(lhs, rhs, desc, mode)
      mode = mode or 'n'
      vim.keymap.set('n', lhs, rhs, { desc = desc })
    end
    -- Buffers and Files
    map('<leader><leader>', fzf.buffers, '[ ] Find existing buffers')
    map('<leader>/', function()
      fzf.blines { winopts = { preview = { hidden = 'hidden' } } }
    end, '[/] Fuzzy search current buffer')
    map('<leader>?', fzf.lines, '[?] Fuzzy search open buffers')
    map('<leader>sf', fzf.files, '[S]earch [F]iles')
    map('<leader>s.', fzf.oldfiles, '[S]earch Recent Files ("." for repeat)')
    map('<leader>sn', function()
      fzf.files { cwd = vim.fn.stdpath 'config' }
    end, '[S]earch [N]eovim files')

    -- Search
    map('<leader>sg', fzf.live_grep_native, '[S]each by [G]rep')
    map('<leader>sw', fzf.grep_cword, '[S]each Current [w]ord')
    map('<leader>sW', fzf.grep_cWORD, '[S]earch Current [W]ORD')

    -- Git
    map('<leader>sG', fzf.git_status, '[S]each [G]it status')

    -- LSPs in `lspconfig.lua`
    -- Misc
    map('<leader>sc', fzf.resume, '[S]earch [C]ontinue')
    map('<leader>sh', fzf.helptags, '[S]earch [H]elp tags')
    map('<leader>sk', fzf.keymaps, '[S]earch [K]eymaps')
    map("<leader>s'", fzf.marks, "[S]earch ['] (marks)")
    map('<leader>s"', fzf.registers, '[S]earch ["] (registers)')
    map('<leader>sj', fzf.jumps, '[S]earch [J]umps')
  end,
}
