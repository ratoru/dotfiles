-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
local appearance = require 'appearance'
local hyperlink = require 'hyperlink'
local keymaps = require 'keymaps'

appearance.apply_to_config(config)
hyperlink.apply_to_config(config)
-- This sets up tmux like functionality and other keybindings.
keymaps.apply_to_config(config)

-- Events
local update = require 'events.update-status'
local tab_title = require 'events.format-tab-title'
wezterm.on('update-status', update.fancy_status)
wezterm.on('format-tab-title', tab_title.format_tab_title)

-- and finally, return the configuration to wezterm
return config
