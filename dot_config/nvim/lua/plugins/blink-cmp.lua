---@module 'lazy'
---@type LazySpec
return {
  'saghen/blink.cmp',
  lazy = false, -- lazy loading handled internally
  -- optional: provides snippets for the snippet source
  dependencies = {
    'rafamadriz/friendly-snippets',
    -- 'fang2hou/blink-copilot',
  },

  -- Build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  build = 'cargo build --release',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 'default' for mappings similar to built-in completion
    -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
    -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
    -- see the "default configuration" section below for full documentation on how to define
    -- your own keymap.
    keymap = { preset = 'super-tab' },

    appearance = {
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- will be removed in a future release
      use_nvim_cmp_as_default = true,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
    },

    -- default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, via `opts_extend`
    sources = {
      default = { 'lsp', 'path', 'snippets', 'lazydev', 'buffer', 'copilot' },
      min_keyword_length = function()
        if vim.bo.filetype == 'markdown' then
          return 3
        end
        -- only applies when typing a command, doesn't apply to arguments
        -- if ctx.mode == 'cmdline' and string.find(ctx.line, ' ') == nil then
        --   return 2
        -- end
        return 0
      end,
      providers = {
        -- copilot = {
        --   name = 'copilot',
        --   module = 'blink-copilot',
        --   score_offset = 100,
        --   async = true,
        --   opts = {
        --     max_completions = 3,
        --     max_attempts = 4,
        --   },
        -- },
        lazydev = { module = 'lazydev.integrations.blink', score_offset = 99 },
        -- Can add config to put buffer source at a lower priority
      },
    },

    -- experimental auto-brackets support
    completion = {
      accept = { auto_brackets = { enabled = true } },

      menu = {
        draw = {
          columns = {
            { 'label', 'label_description', gap = 1 },
            { 'kind_icon', 'kind', gap = 1 },
          },
        },
        border = 'rounded',
      },

      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = {
          border = 'rounded',
        },
      },

      -- Displays a preview of the selected item on the current line
      ghost_text = { enabled = true },
    },

    -- experimental signature help support
    signature = {
      enabled = true,
      window = {
        border = 'rounded',
      },
    },

    fuzzy = {
      prebuilt_binaries = {
        download = false,
      },
    },
  },
}
