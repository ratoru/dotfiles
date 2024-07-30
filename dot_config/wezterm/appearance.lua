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

  config.window_decorations = 'RESIZE'
  config.window_padding = { top = 0, bottom = 0 }

  -- Tab bar settings
  config.hide_tab_bar_if_only_one_tab = false
  config.tab_bar_at_bottom = true
  config.use_fancy_tab_bar = false
  -- Tab bar colors for Snazzy
  config.colors = {
    tab_bar = {
      -- The color of the strip that goes along the top of the window
      background = '#282a36',
      -- The active tab is the one that has focus in the window
      active_tab = {
        bg_color = '#57c7ff', -- blue
        fg_color = '#282a36', -- background color for contrast
        intensity = 'Normal',
      },
      -- Inactive tabs are the tabs that do not have focus
      inactive_tab = {
        bg_color = '#282a36', -- background
        fg_color = '#f1f1f0', -- white
      },
      -- Alternate styling when the mouse pointer moves over inactive tabs
      inactive_tab_hover = {
        bg_color = '#686868', -- bright black (grey)
        fg_color = '#eff0eb', -- bright white
        italic = true,
      },
      -- The new tab button that lets you create new tabs
      new_tab = {
        bg_color = '#282a36', -- background
        fg_color = '#f1f1f0', -- white
      },
      -- Alternate styling when the mouse pointer moves over the new tab button
      new_tab_hover = {
        bg_color = '#5af78e', -- bright green
        fg_color = '#282a36', -- background color for contrast
        italic = true,
      },
    },
  }
  -- tmux status
  wezterm.on('update-right-status', function(window, _)
    local SOLID_LEFT_ARROW = ''
    -- local ARROW_FOREGROUND = { Foreground = { Color = '#c6a0f6' } } -- Catppuccin
    local ARROW_FOREGROUND = { Foreground = { Color = '#57c7ff' } } -- Snazzy
    local prefix = ''

    if window:leader_is_active() then
      prefix = ' ' .. '🌊' -- utf8.char(0x1f30a) -- ocean wave
      SOLID_LEFT_ARROW = '' -- utf8.char(0xe0b2)
    end

    if window:active_tab():tab_id() ~= 0 then
      -- ARROW_FOREGROUND = { Foreground = { Color = '#1e2030' } } -- Catppuccin
      ARROW_FOREGROUND = { Foreground = { Color = '#282a36' } } -- Snazzy
    end -- arrow color based on if tab is first pane

    window:set_left_status(wezterm.format {
      -- { Background = { Color = '#b7bdf8' } }, -- Catppuccin
      { Background = { Color = '#9aedfe' } }, -- Snazzy
      { Text = prefix },
      ARROW_FOREGROUND,
      { Text = SOLID_LEFT_ARROW },
    })
  end)

  -- Apple macOS style symbols
  config.ui_key_cap_rendering = 'AppleSymbols'
end

-- return our module table
return module
