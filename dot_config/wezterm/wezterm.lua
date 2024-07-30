-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
local appearance = require 'appearance'
local hyperlink = require 'hyperlink'

appearance.apply_to_config(config)
hyperlink.apply_to_config(config)

-- and finally, return the configuration to wezterm
return config
