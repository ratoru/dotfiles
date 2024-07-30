local wezterm = require 'wezterm'

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

  config.color_scheme = 'Snazzy'
  -- config.color_scheme = 'Catppuccin Mocha'

  -- Doesn't have to be a specifically patched font.
  config.font = wezterm.font_with_fallback {
    { family = 'Iosevka Term SS14', stretch = 'Expanded' },
    'Hack Nerd Font Mono',
    'MesloLGS NF',
  }
  config.font_size = 16

  config.hide_tab_bar_if_only_one_tab = true
  config.use_fancy_tab_bar = true
  config.window_decorations = 'RESIZE'

  config.window_frame = {
    -- The font used in the tab bar.
    -- Roboto Bold is the default; this font is bundled
    -- with wezterm.
    -- Whatever font is selected here, it will have the
    -- main font setting appended to it to pick up any
    -- fallback fonts you may have used there.
    font = wezterm.font { family = 'Iosevka Term SS14', weight = 'Bold', stretch = 'Expanded' },

    -- The size of the font in the tab bar.
    -- Default to 10.0 on Windows but 12.0 on other systems
    font_size = 12.0,

    -- The overall background color of the tab bar when
    -- the window is focused
    active_titlebar_bg = '#1E1F29',

    -- The overall background color of the tab bar when
    -- the window is not focused
    inactive_titlebar_bg = '#1E1F29',
  }
  config.window_padding = { top = 0, bottom = 0 }
end

-- return our module table
return module
