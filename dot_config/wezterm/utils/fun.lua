local wez = require 'wezterm' ---@class WezTerm

---User defined utility functions
---@class Fun
local M = {}

---Rounds the given number to the nearest multiple given.
---@param number number Any number.
---@param multiple number Any number.
---@return number result floating point number rounded to the closest multiple.
M.mround = function(number, multiple)
  local remainder = number % multiple
  return number - remainder + (remainder > multiple / 2 and multiple or 0)
end

---Converts a float into an integer.
---@param number number
---@param increment? number
---@return integer result
M.toint = function(number, increment)
  if increment then
    return math.floor(number / increment) * increment
  end
  return number >= 0 and math.floor(number + 0.5) or math.ceil(number - 0.5)
end

---User home directory
---@return string home path to the suer home directory.
M.home = (os.getenv 'USERPROFILE' or os.getenv 'HOME' or wez.home_dir or ''):gsub('\\', '/')

---Equivalent to POSIX `basename(3)`
---@param path string Any string representing a path.
---@return string str The basename string.
---
---```lua
----- Example usage
---local name = fn.basename("/foo/bar") -- will be "bar"
---local name = fn.basename("C:\\foo\\bar") -- will be "bar"
---```
M.basename = function(path)
  local trimmed_path = path:gsub('[/\\]*$', '') ---Remove trailing slashes from the path
  local index = trimmed_path:find '[^/\\]*$' ---Find the last occurrence of '/' in the path

  return index and trimmed_path:sub(index) or trimmed_path
end

--- Returns the name of the color scheme
---@return string scheme name
M.get_scheme = function()
  -- return 'Snazzy (Gogh)'
  return 'Catppuccin Mocha'
  -- return 'Nordic'
end

return M
