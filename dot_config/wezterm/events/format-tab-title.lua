local wez = require 'wezterm' ---@class WezTerm
local fun = require 'utils.fun' ---@class Fun
local icons = require 'utils.icons' ---@class Icons

local M = {}

function M.format_tab_title(tab, _, _, config, hover, max_width)
  if config.use_fancy_tab_bar or not config.enable_tab_bar then
    return
  end

  local theme = wez.color.get_builtin_schemes()['Catppuccin Mocha']
  local bg = theme.tab_bar.background
  local fg

  local TabTitle = require('utils.layout'):new() ---@class Layout

  local pane, tab_idx = tab.active_pane, tab.tab_index
  local attributes = {}

  -- set colors based on states
  if tab.is_active then
    fg = theme.tab_bar.active_tab.fg_color
    bg = theme.tab_bar.active_tab.bg_color
  elseif hover then
    fg = theme.tab_bar.inactive_tab_hover.fg_color
    bg = theme.tab_bar.inactive_tab_hover.bg_color
    attributes = { 'Italic' }
  else
    fg = theme.tab_bar.inactive_tab.fg_color
    bg = theme.tab_bar.inactive_tab.bg_color
  end

  -- Check if any pane has unseen output
  local unseen_output = false
  for _, p in ipairs(tab.panes) do
    if p.has_unseen_output then
      unseen_output = true
      break
    end
  end

  -- Add any custom icons you want to use instead of the name here
  local title = pane.title and fun.basename(pane.title) or ''
  title = title
    :gsub('bash', icons.Bash)
    :gsub('Copy mode: ', '')
    :gsub('zsh', icons.Zsh)
    :gsub('nvim', icons.Nvim)
    :gsub('node', icons.Node)
    :gsub('lazygit', icons.Git)
    :gsub('lazydocker', icons.Docker)

  title = title:gsub(fun.basename(fun.home), '󰋜 ')

  -- truncate the tab title when it overflows the maximum available space, then concatenate
  -- some dots to indicate the occurred truncation
  if max_width == config.tab_max_width then
    title = wez.truncate_right(title, max_width - 8) .. '...'
  end

  -- add the tab number. can be substituted by the `has_unseen_output` notification
  TabTitle:push(bg, fg, ' ' .. (unseen_output and icons.UnseenNotification or tab_idx + 1 or '') .. ' ', attributes)

  -- the formatted tab title
  TabTitle:push(bg, fg, title .. ' ', attributes)

  return TabTitle
end

return M
