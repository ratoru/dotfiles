local wezterm = require 'wezterm'
local colors = require 'utils.colors' ---@class CachedColors
local fun = require 'utils.fun' ---@class Fun

-- This is the module table that we will export
local module = {}

-- define a function in the module table.
-- Only functions defined in `module` will be exported to
-- code that imports this module.
-- The suggested convention for making modules that update
-- the config is for them to export an `apply_to_config`
-- function that accepts the config object, like this:
function module.apply_to_config(config)
  config.default_cursor_style = 'SteadyBar'

  -- Define your color scheme here. I am a big fan of:
  --   - 'Snazzy (Gogh)'
  --   - 'Catppuccin Mocha'
  --   - 'Nordic'
  -- This setup is overly complicated to avoid hardcoding
  -- colors or expensive operations.
  -- The actual color scheme is defined by `fun.get_scheme`.
  config.color_schemes = { ['Nordic'] = colors['Nordic'] }
  config.color_scheme = fun.get_scheme()
  local theme = colors[fun.get_scheme()]

  config.command_palette_bg_color = theme.brights[7]
  config.command_palette_fg_color = theme.background
  config.command_palette_font_size = 16
  config.command_palette_rows = 20

  -- Doesn't have to be a specifically patched font.
  -- Wezterm comes with nerd fonts built in.
  config.font = wezterm.font_with_fallback {
    { family = 'Iosevka Term SS14', stretch = 'Expanded' },
    'Hack Nerd Font Mono',
    'MesloLGS NF',
  }
  config.font_size = 16

  config.window_decorations = 'RESIZE'
  config.window_padding = { top = 3, bottom = 0 }

  -- Tab bar settings
  config.enable_tab_bar = true
  config.hide_tab_bar_if_only_one_tab = false
  config.tab_bar_at_bottom = true
  config.use_fancy_tab_bar = false
  config.tab_max_width = 20

  -- Apple macOS style symbols
  config.ui_key_cap_rendering = 'AppleSymbols'

  config.pane_focus_follows_mouse = true
end

-- return our module table
return module
