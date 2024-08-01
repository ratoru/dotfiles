---@class WezTerm
local wez = require 'wezterm'

---Nerd fonts aggregated by type/class/etc.
---@class Icons
local M = {}

M.leader = '🌊'

M.Nvim = ''

M.Bash = wez.nerdfonts.md_bash

M.Zsh = ''

M.Git = ''

M.Docker = ''

M.Node = ''

M.Admin = wez.nerdfonts.md_lightning_bolt

M.UnseenNotification = wez.nerdfonts.cod_circle_small_filled

M.Water = '󰆫'

M.Stretch = ''

---@class BatteryIcons: table, table
---@field charging table Icons for charging battery in increments of 10
---@field normal   table Icons for non-charging battery in increments of 10
M.Battery = {
  Full = {
    ['100'] = wez.nerdfonts.md_battery,
  },
  Charging = {
    ['00'] = wez.nerdfonts.md_battery_alert,
    ['10'] = wez.nerdfonts.md_battery_charging_10,
    ['20'] = wez.nerdfonts.md_battery_charging_20,
    ['30'] = wez.nerdfonts.md_battery_charging_30,
    ['40'] = wez.nerdfonts.md_battery_charging_40,
    ['50'] = wez.nerdfonts.md_battery_charging_50,
    ['60'] = wez.nerdfonts.md_battery_charging_60,
    ['70'] = wez.nerdfonts.md_battery_charging_70,
    ['80'] = wez.nerdfonts.md_battery_charging_80,
    ['90'] = wez.nerdfonts.md_battery_charging_90,
    ['100'] = wez.nerdfonts.md_battery_charging_100,
  },

  Discharging = {
    ['00'] = wez.nerdfonts.md_battery_outline,
    ['10'] = wez.nerdfonts.md_battery_10,
    ['20'] = wez.nerdfonts.md_battery_20,
    ['30'] = wez.nerdfonts.md_battery_30,
    ['40'] = wez.nerdfonts.md_battery_40,
    ['50'] = wez.nerdfonts.md_battery_50,
    ['60'] = wez.nerdfonts.md_battery_60,
    ['70'] = wez.nerdfonts.md_battery_70,
    ['80'] = wez.nerdfonts.md_battery_80,
    ['90'] = wez.nerdfonts.md_battery_90,
    ['100'] = wez.nerdfonts.md_battery,
  },
}

M.Time = {
  [00] = wez.nerdfonts.fa_code,
  [01] = wez.nerdfonts.fa_bed,
  [02] = wez.nerdfonts.fa_bed,
  [03] = wez.nerdfonts.fa_bed,
  [04] = wez.nerdfonts.fa_bed,
  [05] = wez.nerdfonts.fa_bed,
  [06] = wez.nerdfonts.fa_bed,
  [07] = wez.nerdfonts.fa_bed,
  [08] = wez.nerdfonts.fa_bed,
  [09] = wez.nerdfonts.fa_bed,
  [10] = wez.nerdfonts.md_food_fork_drink,
  [11] = wez.nerdfonts.fa_code,
  [12] = wez.nerdfonts.fa_code,
  [13] = wez.nerdfonts.md_cup_water,
  [14] = wez.nerdfonts.fa_code,
  [15] = wez.nerdfonts.fa_code,
  [16] = wez.nerdfonts.md_cup_water,
  [17] = wez.nerdfonts.fa_code,
  [18] = wez.nerdfonts.fa_code,
  [19] = wez.nerdfonts.md_food_fork_drink,
  [20] = '󰖛',
  [21] = wez.nerdfonts.fa_code,
  [22] = wez.nerdfonts.fa_code,
  [23] = wez.nerdfonts.fa_code,
}

return M
