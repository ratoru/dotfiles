---@class WezTerm
local wez = require 'wezterm'

---@class Fun
local fun = require 'utils.fun'

---@class Icons
local icons = require 'utils.icons'

---@class Layout
local StatusBar = require 'utils.layout'

local color_extras = require('utils.colors').color_extras

local M = {}

-- Shows a fancy status line with mode indicators, leader indicator, battery, water reminder and time icon.
function M.fancy_status(window, _)
  local extra_colors = color_extras['Catppuccin Mocha']
  local theme = wez.color.get_builtin_schemes()['Catppuccin Mocha']
  local modes = {
    copy_mode = { text = ' 󰆏 COPY ', bg = theme.brights[3] },
    search_mode = { text = ' 󰍉 SEARCH ', bg = theme.brights[4] },
    window_mode = { text = ' 󱂬 WINDOW ', bg = theme.ansi[6] },
    font_mode = { text = ' 󰛖 FONT ', bg = theme.indexed[16] or theme.ansi[8] },
    lock_mode = { text = '  LOCK ', bg = theme.ansi[8] },
  }

  local bg = theme.ansi[5]

  -- {{{1 LEFT STATUS
  local LeftStatus = StatusBar:new() ---@class Layout
  local name = window:active_key_table()
  -- Add leader key indicator
  if window:leader_is_active() then
    local leader = ' ' .. '🌊' -- utf8.char(0x1f30a) -- ocean wave
    local leader_fill = '' -- utf9.char(0xe0b2)
    local leader_fill_color = extra_colors.status_fill_active
    if window:active_tab():tab_id() ~= 0 then
      leader_fill_color = extra_colors.status_fill_inactive
    end
    LeftStatus:push(extra_colors.status_bg, theme.background, leader)
    LeftStatus:push(extra_colors.status_bg, leader_fill_color, leader_fill)
  end
  -- Add mode indicator
  if name and modes[name] then
    local txt = modes[name].text or ''
    bg = modes[name].bg
    LeftStatus:push(bg, theme.background, txt, { 'Bold' })
  end

  window:set_left_status(wez.format(LeftStatus))
  -- }}}

  -- {{{1 RIGHT STATUS
  local RightStatus = StatusBar:new() ---@class Layout

  bg = wez.color.parse(bg)
  local colors = { bg:darken(0.15), bg, bg:lighten(0.15), bg:lighten(0.25) }

  -- Battery symbols
  local battery = wez.battery_info()[1]
  battery.charge = battery.state_of_charge * 100
  battery.lvl_round = fun.toint(fun.mround(battery.charge, 10))
  battery.ico = icons.Battery[battery.state][tostring(battery.lvl_round)]

  -- Time icon
  local current_hour = tonumber(wez.strftime '%H')
  local time_icon = icons.Time[current_hour]

  -- Drink water reminder
  local current_minute = tonumber(wez.strftime '%M')
  if current_minute <= 5 or current_minute == 30 then
    RightStatus:push(colors[3], theme.tab_bar.background, ' ' .. icons.Water .. ' ')
  end

  RightStatus:push(colors[2], theme.tab_bar.background, ' ' .. time_icon .. ' ')
  RightStatus:push(colors[1], theme.tab_bar.background, ' ' .. battery.ico .. ' ')

  window:set_right_status(wez.format(RightStatus))
  -- }}}
end

-- Only shows a leader key indicator.
function M.simple_status(window, _)
  local extra_colors = color_extras['Snazzy (Gogh)']
  local solid_left_arrow = ''
  local arrow_foreground = { Foreground = { Color = extra_colors.status_fill_active } }
  local prefix = ''

  if window:leader_is_active() then
    prefix = ' ' .. '🌊' -- utf8.char(0x1f30a) -- ocean wave
    solid_left_arrow = '' -- utf9.char(0xe0b2)
  end

  if window:active_tab():tab_id() ~= 0 then
    arrow_foreground = { Foreground = { Color = extra_colors.status_fill_inactive } }
  end -- arrow color based on if tab is first pane

  window:set_left_status(wez.format {
    { Background = { Color = extra_colors.status_bg } },
    { Text = prefix },
    arrow_foreground,
    { Text = solid_left_arrow },
  })
end

return M
