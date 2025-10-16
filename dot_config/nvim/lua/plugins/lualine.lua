---@module 'lazy'
---@type LazySpec
return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = ' '
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,
  dependencies = {
    { 'ratoru/lualine-pretty-path' },
  },
  opts = function(_, opts)
    -- local lualine_require = require('lualine_require')
    -- lualine_require.require = require
    local lazy_status = require 'lazy.status' -- to configure lazy pending updates count

    --- From: https://github.com/nvim-lualine/lualine.nvim/wiki/Component-snippets
    --- @param trunc_width number trunctates component when screen width is less then trunc_width
    --- @param trunc_len number truncates component to trunc_len number of chars
    --- @param hide_width number hides component when window width is smaller then hide_width
    --- @param no_ellipsis boolean whether to disable adding '...' at end after truncation
    --- return function that can format the component accordingly
    local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
      return function(str)
        local win_width = vim.o.columns
        if hide_width and win_width < hide_width then
          return ''
        elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
          return str:sub(1, trunc_len) .. (no_ellipsis and '' or '…')
        end
        return str
      end
    end

    -- Show LSP status, borrowed from Heirline cookbook
    -- https://github.com/rebelot/heirline.nvim/blob/master/cookbook.md#lsp
    local function lsp_status_all()
      local haveServers = false
      local names = {}
      for _, server in pairs(vim.lsp.get_clients { bufnr = 0 }) do
        -- msg = ' '
        haveServers = true
        table.insert(names, server.name)
      end
      if not haveServers then
        return ''
      end
      if vim.g.custom_lualine_show_lsp_names then
        return ' ' .. table.concat(names, ',')
      end
      return ' '
    end

    -- Override 'encoding': Don't display if encoding is UTF-8.
    local encoding_only_if_not_utf8 = function()
      local ret, _ = (vim.bo.fenc or vim.go.enc):gsub('^utf%-8$', '')
      return ret
    end
    -- fileformat: Don't display if &ff is unix.
    local fileformat_only_if_not_unix = function()
      local ret, _ = vim.bo.fileformat:gsub('^unix$', '')
      return ret
    end

    Snacks.toggle({
      name = 'lualine symbols',
      get = function()
        return vim.b.trouble_lualine ~= false
      end,
      set = function(state)
        vim.b.trouble_lualine = state
      end,
    }):map '<leader>tl'

    Snacks.toggle({
      name = 'lualine lsp names',
      get = function()
        return vim.g.custom_lualine_show_lsp_names
      end,
      set = function(state)
        vim.g.custom_lualine_show_lsp_names = state
      end,
    }):map '<leader>tL'

    Snacks.toggle({
      name = 'lualine session name',
      get = function()
        return vim.g.custom_lualine_show_session_name
      end,
      set = function(state)
        vim.g.custom_lualine_show_session_name = state
      end,
    }):map '<leader>ts'

    ---@class PrettyPath.BasePlusHarpoonProvider: PrettyPath.Provider
    ---@field super PrettyPath.Provider
    local pretty_path_util = require('lualine-pretty-path.providers.base'):extend()

    function pretty_path_util:render_symbols()
      local indexChar = { '¹', '²', '³', '⁴', '⁵' }
      if package.loaded['harpoon'] then
        local current_file = vim.fn.fnamemodify(vim.fn.bufname '%', ':.')
        local harpoonItem, harpoonIndex = require('harpoon'):list():get_by_value(current_file)
        if harpoonItem then
          return indexChar[harpoonIndex]
        end
      end
    end

    return vim.tbl_deep_extend('force', opts or {}, {
      options = {
        -- When theme is set to auto, Lualine uses dofile instead of require
        -- to load the theme. We need the theme to be loaded via require since
        -- we modify the cached singleton in tokyonight's config function to
        -- add different colors for the x section
        theme = function()
          if vim.g.colors_name and vim.g.colors_name:match '^tokyonight' then
            return require('lualine.themes.' .. vim.g.colors_name)
          end
          return 'auto'
        end,
        component_separators = { left = '╲', right = '╱' },
        disabled_filetypes = { 'alpha', 'snacks_dashboard' },
        section_separators = { left = '', right = '' },
        ignore_focus = { 'trouble' },
        globalstatus = true,
      },
      sections = {
        lualine_a = {
          {
            'mode',
            fmt = trunc(130, 3, 0, true),
          },
        },
        lualine_b = {
          {
            'branch',
            fmt = trunc(70, 15, 65, true),
            separator = '',
          },
        },
        lualine_c = {
          {
            'pretty_path',
            providers = {
              default = pretty_path_util,
            },
            directories = {
              max_depth = 4,
            },
            highlights = {
              newfile = 'LazyProgressDone',
            },
            separator = '',
          },
        },
        lualine_x = {
          {
            'diagnostics',
            symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
            separator = '',
          },
          {
            'diff',
            symbols = {
              added = ' ',
              modified = ' ',
              removed = ' ',
            },
            fmt = trunc(0, 0, 60, true),
            separator = '',
          },
          {
            function()
              return 'recording @' .. vim.fn.reg_recording()
            end,
            cond = function()
              return vim.fn.reg_recording() ~= ''
            end,
            color = { fg = '#ff007c' },
            separator = '',
          },
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            -- color = { fg = '#3d59a1' },
            fmt = trunc(0, 0, 160, true), -- hide when window is < 100 columns
            separator = '',
          },
          {
            lsp_status_all,
            fmt = trunc(0, 8, 140, false),
            separator = '',
          },
          {
            encoding_only_if_not_utf8,
            fmt = trunc(0, 0, 140, true), -- hide when window is < 80 columns
            separator = '',
          },
          {
            fileformat_only_if_not_unix,
            fmt = trunc(0, 0, 140, true), -- hide when window is < 80 columns
            separator = '',
          },
          -- {
          --   function()
          --     return ' '
          --   end,
          --   color = function()
          --     local status = require('sidekick.status').get()
          --     if status then
          --       return status.kind == 'Error' and 'DiagnosticError' or status.busy and 'DiagnosticWarn' or 'Special'
          --     end
          --   end,
          --   cond = function()
          --     local status = require 'sidekick.status'
          --     return status.get() ~= nil
          --   end,
          -- },
        },
        lualine_y = {
          { 'grapple' },
          { 'progress', fmt = trunc(0, 0, 40, true) },
        },
        lualine_z = {
          { 'location', fmt = trunc(0, 0, 80, true) },
        },
      },
      inactive_sections = {
        lualine_c = {
          {
            'pretty_path',
          },
        },
      },
      extensions = {
        'lazy',
        'mason',
        'oil',
        'quickfix',
        'toggleterm',
        'trouble',
      },
    })
  end,
}
