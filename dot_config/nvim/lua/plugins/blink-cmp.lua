local fancy_border = {
  menu = { '󱐋', 'WarningMsg' },
  info = { '', 'DiagnosticHint' },
  body = { '─', '╮', '│', '╯', '─', '╰', '│' },
}

return {
  'saghen/blink.cmp',
  lazy = false, -- lazy loading handled internally
  -- optional: provides snippets for the snippet source
  dependencies = { 'rafamadriz/friendly-snippets' },

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
      default = { 'lsp', 'path', 'snippets', 'buffer' },
      -- providers = {
      -- copilot = {
      --   name = 'copilot',
      --   module = 'blink-cmp-copilot',
      -- },
      -- },
    },

    -- experimental auto-brackets support
    completion = {
      accept = { auto_brackets = { enabled = true } },

      list = { selection = 'auto_insert' },

      menu = {
        draw = {
          columns = {
            { 'kind_icon', gap = 1 },
            { 'label', 'label_description', gap = 1 },
            { 'kind' },
          },
        },
        border = { fancy_border.menu, unpack(fancy_border.body) },
      },

      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = {
          border = { fancy_border.info, unpack(fancy_border.body) },
        },
      },

      -- Displays a preview of the selected item on the current line
      ghost_text = { enabled = true },
    },

    -- experimental signature help support
    signature = {
      enabled = true,
      window = {
        border = { fancy_border.info, unpack(fancy_border.body) },
      },
    },

    fuzzy = {
      prebuilt_binaries = {
        download = false,
      },
    },
  },
}
