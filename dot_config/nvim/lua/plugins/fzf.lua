return {
  'ibhagwan/fzf-lua',
  -- optional for icon support
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local fzf = require 'fzf-lua'
    -- local actions = require 'fzf-lua.actions'

    fzf.setup {
      'max-perf',
      winopts = {
        preview = {
          default = 'bat',
        },
      },
      fzf_colors = true,
      files = { prompt = '   ' },
      grep = { prompt = ' 󰱼  ' },
      buffers = { prompt = '   ' },
      lsp = { code_actions = { prompt = '   ' } },
      oldfiles = { prompt = '   ' },
      helptags = { prompt = '   ' },
      manpages = { prompt = '   ' },
      highlights = { prompt = '   ' },
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
    map('<leader>sf', fzf.files, 'Search files')
    map('<leader>sd', function()
      local buffer_path = vim.api.nvim_buf_get_name(0)
      if buffer_path == '' then
        print '[fzf-lua] No buffer is currently open.'
        return
      end
      local buffer_dir = vim.fn.fnamemodify(buffer_path, ':h')
      fzf.files {
        cwd = buffer_dir,
      }
    end, 'Search buffer directory')
    map('<leader>s.', fzf.oldfiles, 'Search recent files ("." for repeat)')
    map('<leader>sn', function()
      fzf.files { cwd = vim.fn.stdpath 'config' }
    end, 'Search neovim files')

    -- Search
    map('<leader>sg', fzf.live_grep_native, 'Search by grep')
    map('<leader>sw', fzf.grep_cword, 'Search current word')
    map('<leader>sW', fzf.grep_cWORD, 'Search current WORD')

    -- Git
    map('<leader>sm', fzf.git_status, 'Search git status')

    -- LSPs in `lspconfig.lua`
    -- Misc
    map('<leader>sc', fzf.resume, 'Search continue')
    map('<leader>sC', fzf.colorschemes, 'Search Colorschmes')
    map('<leader>sh', fzf.helptags, 'Search help tags')
    map('<leader>sk', fzf.keymaps, 'Search keymaps')
    map("<leader>s'", fzf.marks, "Search ['] (marks)")
    map('<leader>s"', fzf.registers, 'Search ["] (registers)')
    map('<leader>sj', fzf.jumps, 'Search jumps')
  end,
}
