-- Inspired by https://github.com/theopn/dotfiles/blob/main/wezterm/wezterm.lua
local wezterm = require 'wezterm'

local module = {}

function module.apply_to_config(config)
  local act = wezterm.action
  -- Keys
  -- Configure this as you like. A common one is ctrl+a.
  config.leader = { key = 'phys:Space', mods = 'SHIFT', timeout_milliseconds = 2500 }
  config.keys = {
    -- Send Shift-Space when pressing Shift-Space twice
    { key = 'phys:Space', mods = 'LEADER|SHIFT', action = act.SendKey { key = 'Space' } },
    { key = 'c', mods = 'LEADER', action = act.ActivateCopyMode },
    { key = 'phys:Space', mods = 'LEADER', action = act.ActivateCommandPalette },

    -- Search case insensitive by default
    { key = 'f', mods = 'CMD', action = act.Search { CaseInSensitiveString = '' } },

    -- Pane keybindings
    { key = 's', mods = 'LEADER', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = 'v', mods = 'LEADER', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
    { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
    { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
    { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
    { key = 'q', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },
    { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },
    { key = 'o', mods = 'LEADER', action = act.RotatePanes 'Clockwise' },

    -- We can make separate keybindings for resizing panes
    -- But Wezterm offers custom "mode" in the name of "KeyTable"
    { key = 'r', mods = 'LEADER', action = act.ActivateKeyTable { name = 'resize_pane', one_shot = false } },

    -- Tab keybindings
    { key = 't', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
    { key = '[', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
    { key = ']', mods = 'LEADER', action = act.ActivateTabRelative(1) },
    { key = 'n', mods = 'LEADER', action = act.ShowTabNavigator },
    {
      key = 'e',
      mods = 'LEADER',
      action = act.PromptInputLine {
        description = wezterm.format {
          { Attribute = { Intensity = 'Bold' } },
          { Foreground = { AnsiColor = 'Fuchsia' } },
          { Text = 'Renaming Tab Title...:' },
        },
        action = wezterm.action_callback(function(window, _, line)
          if line then
            window:active_tab():set_title(line)
          end
        end),
      },
    },
    -- Key table for moving tabs around
    { key = 'm', mods = 'LEADER', action = act.ActivateKeyTable { name = 'move_tab', one_shot = false } },
    -- Or shortcuts to move tab w/o move_tab table. SHIFT is for when caps lock is on
    { key = '{', mods = 'LEADER|SHIFT', action = act.MoveTabRelative(-1) },
    { key = '}', mods = 'LEADER|SHIFT', action = act.MoveTabRelative(1) },

    -- Workspace
    { key = 'w', mods = 'LEADER', action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' } },
    { key = 'Tab', mods = 'LEADER', action = act.SwitchWorkspaceRelative(1) },
    { key = 'Tab', mods = 'LEADER|SHIFT', action = act.SwitchWorkspaceRelative(-1) },

    -- Open config in the default system editor with Cmd+, (the Apple way)
    {
      key = ',',
      mods = 'SUPER',
      domain = { DomainName = 'local' },
      action = wezterm.action.SpawnCommandInNewWindow {
        label = 'Edit Wezterm Config',
        cwd = os.getenv 'WEZTERM_CONFIG_DIR',
        args = { '/opt/homebrew/bin/nvim', 'wezterm.lua' },
      },
    },
  }
  -- I can use the tab navigator (Leader t), but I also want to quickly navigate tabs with index
  for i = 1, 9 do
    table.insert(config.keys, {
      key = tostring(i),
      mods = 'LEADER',
      action = act.ActivateTab(i - 1),
    })
  end

  config.key_tables = {
    resize_pane = {
      { key = 'h', action = act.AdjustPaneSize { 'Left', 1 } },
      { key = 'j', action = act.AdjustPaneSize { 'Down', 1 } },
      { key = 'k', action = act.AdjustPaneSize { 'Up', 1 } },
      { key = 'l', action = act.AdjustPaneSize { 'Right', 1 } },
      { key = 'h', mods = 'SHIFT', action = act.AdjustPaneSize { 'Left', 5 } },
      { key = 'j', mods = 'SHIFT', action = act.AdjustPaneSize { 'Down', 5 } },
      { key = 'k', mods = 'SHIFT', action = act.AdjustPaneSize { 'Up', 5 } },
      { key = 'l', mods = 'SHIFT', action = act.AdjustPaneSize { 'Right', 5 } },
      { key = 'Escape', action = 'PopKeyTable' },
      { key = 'Enter', action = 'PopKeyTable' },
    },
    move_tab = {
      { key = 'h', action = act.MoveTabRelative(-1) },
      { key = 'j', action = act.MoveTabRelative(-1) },
      { key = 'k', action = act.MoveTabRelative(1) },
      { key = 'l', action = act.MoveTabRelative(1) },
      { key = 'Escape', action = 'PopKeyTable' },
      { key = 'Enter', action = 'PopKeyTable' },
    },
  }
end

return module
