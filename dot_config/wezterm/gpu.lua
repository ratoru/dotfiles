local wezterm = require 'wezterm'

local M = {}

function M.apply_to_config(config)
  config.front_end = 'WebGpu'
end

return M
