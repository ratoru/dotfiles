---@class WezTerm
local wez = require 'wezterm'

---@class Fun
local fun = require 'utils.fun'

---@class Icons
local icons = require 'utils.icons'

---@class Layout
local StatusBar = require 'utils.layout'

local colors = require 'utils.colors'

local M = {}

-- Shows a fancy status line with mode indicators, leader indicator, battery, water reminder and time icon.
function M.fancy_status(window, _)
  local theme = colors[fun.get_scheme()]
  local modes = {
    copy_mode = { text = ' 󰆏 COPY ', bg = theme.brights[3] },
    search_mode = { text = ' 󰍉 SEARCH ', bg = theme.brights[4] },
    window_mode = { text = ' 󱂬 WINDOW ', bg = theme.ansi[6] },
    font_mode = { text = ' 󰛖 FONT ', bg = theme.indexed[16] or theme.ansi[8] },
    lock_mode = { text = '  LOCK ', bg = theme.ansi[8] },
    resize_pane = { text = ' 󰘕 RESIZE ', bg = theme.brights[5] },
    move_tab = { text = ' 󰁁 MOVE ', bg = theme.brights[7] },
  }

  local bg = theme.ansi[5]

  -- {{{1 LEFT STATUS
  local LeftStatus = StatusBar:new() ---@class Layout
  local name = window:active_key_table()
  -- Add leader key indicator
  if window:leader_is_active() then
    local leader = ' ' .. '🌊' -- utf8.char(0x1f30a) -- ocean wave
    local leader_fill = '' -- utf9.char(0xe0b2)
    local leader_fill_color = theme.tab_bar.active_tab.bg_color
    local tabs = window:mux_window():tabs_with_info()
    if #tabs > 0 and tabs[1].index ~= 0 then
      leader_fill_color = theme.tab_bar.inactive_tab.bg_color
    end
    LeftStatus:push(theme.leader_bg, theme.background, leader)
    LeftStatus:push(theme.leader_bg, leader_fill_color, leader_fill)
  end
  -- Add mode indicator
  if name and modes[name] then
    local txt = modes[name].text or ''
    bg = modes[name].bg
    LeftStatus:push(bg, theme.background, txt, { 'Bold' })
  end
  -- Add zoom indicator
  local is_zoomed = false
  local cur_tab = window:active_tab()
  for _, pane in ipairs(cur_tab:panes_with_info()) do
    if pane.is_zoomed then
      is_zoomed = true
      break
    end
  end
  if is_zoomed then
    LeftStatus:push(theme.brights[6], theme.background, ' 󱅻 ', { 'Bold' })
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

  -- Workspace
  local workspace = window:active_workspace()
  if workspace == 'default' then
    workspace = ''
  elseif #workspace > 5 then
    workspace = wez.truncate_right(workspace, 5)
  end

  -- Drink water reminder
  local current_minute = tonumber(wez.strftime '%M')
  if current_minute <= 5 or current_minute == 30 then
    RightStatus:push(colors[4], theme.tab_bar.background, ' ' .. icons.Water .. ' ')
  end

  -- Stretch reminder
  if current_minute == 20 or current_minute == 40 then
    RightStatus:push(colors[4], theme.tab_bar.background, ' ' .. icons.Stretch .. ' ')
  end

  RightStatus:push(colors[3], theme.tab_bar.background, ' ' .. time_icon .. ' ')
  RightStatus:push(colors[2], theme.tab_bar.background, ' ' .. battery.ico .. ' ')
  RightStatus:push(colors[1], theme.tab_bar.background, ' ' .. workspace .. ' ')

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
