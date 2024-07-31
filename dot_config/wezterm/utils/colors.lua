local wezterm = require 'wezterm'

local M = {}

-- Enhances Snazzy with tab bar colors.
local enhanced_snazzy = wezterm.get_builtin_color_schemes()['Snazzy (Gogh)']
enhanced_snazzy.tab_bar = {
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
}
M.enhanced_snazzy = enhanced_snazzy

-- Defines color schemes to use for styling custom elements in the terminal.
-- The names must match a color scheme defined by Wezterm.
M.color_extras = {
  ['Snazzy (Gogh)'] = {
    status_bg = '#9aedfe',
    status_fill_active = '#57c7ff',
    status_fill_inactive = '#282a36',
  },
  ['Catppuccin Mocha'] = {
    status_bg = '#b7bdf8',
    status_fill_active = '#c6a0f6',
    status_fill_inactive = '#1e2030',
  },
}

return M
