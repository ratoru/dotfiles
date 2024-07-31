-- This file contains the color schemes that I set up for Wezterm.
-- Since my status bar uses these colors, I decided to cache them
-- to increase performance.
local mocha = {
  rosewater = '#f5e0dc',
  flamingo = '#f2cdcd',
  pink = '#f5c2e7',
  mauve = '#cba6f7',
  red = '#f38ba8',
  maroon = '#eba0ac',
  peach = '#fab387',
  yellow = '#f9e2af',
  green = '#a6e3a1',
  teal = '#94e2d5',
  sky = '#89dceb',
  sapphire = '#74c7ec',
  blue = '#89b4fa',
  lavender = '#b4befe',
  text = '#cdd6f4',
  subtext1 = '#bac2de',
  subtext0 = '#a6adc8',
  overlay2 = '#9399b2',
  overlay1 = '#7f849c',
  overlay0 = '#6c7086',
  surface2 = '#585b70',
  surface1 = '#45475a',
  surface0 = '#313244',
  base = '#1e1e2e',
  mantle = '#181825',
  crust = '#11111b',
}

local nordic = {
  none = 'NONE',
  black0 = '#191D24',
  black1 = '#1E222A',
  black2 = '#222630',
  gray0 = '#242933',
  gray1 = '#2E3440',
  gray2 = '#3B4252',
  gray3 = '#434C5E',
  gray4 = '#4C566A',
  gray5 = '#60728A',
  white0_normal = '#BBC3D4',
  white0_reduce_blue = '#C0C8D8',
  white1 = '#D8DEE9',
  white2 = '#E5E9F0',
  white3 = '#ECEFF4',
  blue0 = '#5E81AC',
  blue1 = '#81A1C1',
  blue2 = '#88C0D0',
  cyan = '#8FBCBB',
  cyan_bright = '#9FC6C5',
  cyan_dim = '#80B3B2',
  red = '#BF616A',
  red_bright = '#C5727A',
  red_dim = '#B74E58',
  orange = '#D08770',
  orange_bright = '#D79784',
  orange_dim = '#CB775D',
  yellow = '#EBCB8B',
  yellow_bright = '#EFD49F',
  yellow_dim = '#E7C173',
  green = '#A3BE8C',
  green_bright = '#B1C89D',
  green_dim = '#97B67C',
  magenta = '#B48EAD',
  magenta_bright = '#BE9DB8',
  magenta_dim = '#A97EA1',
}

--- @class CachedColors
local cached_colors = {
  ['Catppuccin Mocha'] = {
    foreground = mocha.text,
    background = mocha.base,

    cursor_fg = mocha.crust,
    cursor_bg = mocha.rosewater,
    cursor_border = mocha.rosewater,

    selection_fg = mocha.text,
    selection_bg = mocha.surface2,

    scrollbar_thumb = mocha.surface2,

    split = mocha.overlay0,

    ansi = {
      mocha.surface1,
      mocha.red,
      mocha.green,
      mocha.yellow,
      mocha.blue,
      mocha.pink,
      mocha.teal,
      mocha.subtext1,
    },

    brights = {
      mocha.surface2,
      mocha.red,
      mocha.green,
      mocha.yellow,
      mocha.blue,
      mocha.pink,
      mocha.teal,
      mocha.subtext0,
    },

    indexed = { [16] = mocha.peach, [17] = mocha.rosewater },

    -- nightbuild only
    compose_cursor = mocha.flamingo,

    tab_bar = {
      background = mocha.crust,
      active_tab = {
        bg_color = mocha.mauve,
        fg_color = mocha.crust,
      },
      inactive_tab = {
        bg_color = mocha.mantle,
        fg_color = mocha.text,
      },
      inactive_tab_hover = {
        bg_color = mocha.base,
        fg_color = mocha.text,
      },
      new_tab = {
        bg_color = mocha.surface0,
        fg_color = mocha.text,
      },
      new_tab_hover = {
        bg_color = mocha.surface1,
        fg_color = mocha.text,
      },
      -- fancy tab bar
      inactive_tab_edge = mocha.surface0,
    },

    visual_bell = mocha.surface0,

    -- Leader key indicator
    leader_bg = mocha.lavender,
  },
  ['Snazzy (Gogh)'] = {
    foreground = '#eff0eb',
    background = '#282a36',

    cursor_fg = '#97979b',

    selection_fg = '#282a36',
    selection_bg = '#feffff',

    ansi = {
      '#282a36', -- black
      '#ff5c57', -- red
      '#5af78e', -- green
      '#f3f99d', -- yellow
      '#57c7ff', -- blue
      '#ff6ac1', -- magenta
      '#9aedfe', -- cyan
      '#f1f1f0', -- white
    },

    brights = {
      '#686868', -- black
      '#ff5c57', -- red
      '#5af78e', -- green
      '#f3f99d', -- yellow
      '#57c7ff', -- blue
      '#ff6ac1', -- magenta
      '#9aedfe', -- cyan
      '#eff0eb', -- white
    },

    tab_bar = {
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
    },
    leader_bg = '#9aedfe',
  },
}

return cached_colors
