---@module 'lazy'
---@type LazySpec
return {
  {
    'ibhagwan/fzf-lua',
    -- mini.icons (via mini.nvim) provides file icons
    dependencies = { 'nvim-mini/mini.nvim' },
    config = function()
      local fzf = require 'fzf-lua'
      local fzf_path = require 'fzf-lua.path'

      ------------------------------------------------------------------
      -- seeker-style progressive refinement: toggle files <-> grep with
      -- <C-e>, scoping the next picker to the currently-filtered set.
      --   * `prefix = 'select-all'` => the action receives ALL filtered
      --     entries (not just <Tab>-selected ones).
      --   * `search_paths` scopes files/grep to that exact file list.
      ------------------------------------------------------------------
      local function entries_to_files(selected, opts)
        local seen, files = {}, {}
        for _, e in ipairs(selected) do
          local entry = fzf_path.entry_to_file(e, opts)
          local p = entry and entry.path
          if p and not seen[p] then
            seen[p] = true
            files[#files + 1] = p
          end
        end
        return files
      end

      -- Files -> live grep, scoped to the filtered files
      local function files_to_grep(selected, opts)
        local files = entries_to_files(selected, opts)
        if #files == 0 then
          return
        end
        fzf.live_grep { search_paths = files }
      end

      -- Grep -> files, listing exactly the files that currently have matches.
      -- NOTE: the files picker uses `fd`, whose `search_paths` must be DIRECTORIES,
      -- so passing a file list there errors ("not a dir"). Instead we feed the exact
      -- file list via `cmd` (printf), which bypasses fd entirely (see files provider).
      local function grep_to_files(selected, opts)
        local files = entries_to_files(selected, opts)
        if #files == 0 then
          return
        end
        local escaped = {}
        for _, f in ipairs(files) do
          escaped[#escaped + 1] = vim.fn.shellescape(f)
        end
        fzf.files { cmd = "printf '%s\\n' " .. table.concat(escaped, ' ') }
      end

      local toggle_to_grep = { fn = files_to_grep, prefix = 'select-all' }
      local toggle_to_files = { fn = grep_to_files, prefix = 'select-all' }

      fzf.setup {
        fzf_colors = true,
        fzf_opts = {
          ['--no-scrollbar'] = true,
        },
        defaults = {
          color_icons = true,
          file_icons = 'mini',
          git_icons = false,
        },
        winopts = {
          preview = { scrollbar = false },
        },
        files = {
          prompt = ' 󰈞  ',
          cwd_prompt = false,
          actions = { ['ctrl-e'] = toggle_to_grep },
        },
        grep = {
          prompt = ' 󰱼  ',
          actions = { ['ctrl-e'] = toggle_to_files },
        },
        git = {
          files = {
            prompt = ' 󰊢  ',
            cwd_prompt = false,
            actions = { ['ctrl-e'] = toggle_to_grep },
          },
        },
        buffers = { prompt = ' 󰓩  ' },
        oldfiles = { prompt = ' 󰋚  ' },
        lsp = { code_actions = { prompt = ' 󰌶  ' } },
        helptags = { prompt = ' 󰋖  ' },
        manpages = { prompt = ' 󰈙  ' },
        highlights = { prompt = ' 󰏘  ' },
      }

      -- Route vim.ui.select (LSP code actions, etc.) through fzf-lua
      fzf.register_ui_select()

      local function map(lhs, rhs, desc) vim.keymap.set('n', lhs, rhs, { desc = desc }) end

      -- Files & buffers
      map('<leader><space>', function() require('fzf-lua-frecency').frecency { cwd_only = true } end, 'Find frecent files')
      map('<leader>,', fzf.buffers, 'Buffers')
      map('<leader>ff', fzf.files, 'Find files')
      map('<leader>fg', fzf.git_files, 'Find git files')
      map('<leader>fr', fzf.oldfiles, 'Recent files')
      map('<leader>fc', function() fzf.files { cwd = vim.fn.stdpath 'config' } end, 'Find config files')
      map('<leader>fd', function()
        local buf = vim.api.nvim_buf_get_name(0)
        if buf == '' then
          vim.notify('[fzf-lua] No file in current buffer', vim.log.levels.WARN)
          return
        end
        fzf.files { cwd = vim.fn.fnamemodify(buf, ':h') }
      end, 'Find files in buffer dir')

      -- Grep (live_grep = rg reruns per keystroke; <C-e> toggles to scoped files)
      map('<leader>sg', fzf.live_grep_native, 'Grep (project)')
      map('<leader>/', fzf.live_grep, 'Grep (project, live)')
      map('<leader>sw', fzf.grep_cword, 'Grep word under cursor')
      -- map('<leader>sW', fzf.grep_cWORD, 'Grep WORD under cursor') -- rare: sw covers it
      vim.keymap.set('x', '<leader>sw', fzf.grep_visual, { desc = 'Grep visual selection' })
      map('<leader>sb', function() fzf.blines { winopts = { preview = { hidden = true } } } end, 'Grep current buffer')
      -- map('<leader>?', fzf.lines, 'Grep open buffers') -- rare: sb (current buffer) is the one used

      -- Search / pickers
      map('<leader>sc', fzf.resume, 'Continue search')
      map('<leader>sh', fzf.helptags, 'Help tags')
      map('<leader>sk', fzf.keymaps, 'Keymaps')
      map('<leader>sm', fzf.marks, 'Marks')
      -- map('<leader>sj', fzf.jumps, 'Jumps') -- rare: <C-o>/<C-i> navigate the jumplist
      map('<leader>st', fzf.treesitter, 'Treesitter symbols')
      -- map('<leader>sl', fzf.loclist, 'Location list') -- rare: use trouble.nvim
      -- map('<leader>sq', fzf.quickfix, 'Quickfix list') -- rare: use trouble.nvim
      -- map('<leader>s"', fzf.registers, 'Registers') -- rare: "<reg>p
      -- map('<leader>s/', fzf.search_history, 'Search history') -- rare: q/ in normal mode
      -- map('<leader>:', fzf.command_history, 'Command history') -- rare: q: in normal mode
      map('<leader>sC', fzf.commands, 'Commands')
      map('<leader>sd', fzf.diagnostics_document, 'Diagnostics (buffer)')
      map('<leader>sD', fzf.diagnostics_workspace, 'Diagnostics (workspace)')
      map('<leader>uC', fzf.colorschemes, 'Colorschemes')

      -- Git
      map('<leader>gs', fzf.git_status, 'Git status')
      map('<leader>gb', fzf.git_branches, 'Git branches')
      map('<leader>gl', fzf.git_commits, 'Git log (project)')
      map('<leader>gf', fzf.git_bcommits, 'Git log (buffer)')
    end,
  },
  {
    'elanmed/fzf-lua-frecency.nvim',
    dependencies = { 'ibhagwan/fzf-lua' },
    opts = {},
  },
}
