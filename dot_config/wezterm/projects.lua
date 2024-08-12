local wezterm = require 'wezterm'
local module = {}

local function project_dirs()
  return {
    wezterm.home_dir,
    wezterm.home_dir .. '/programming/web-projects/homepage',
    wezterm.home_dir .. '/.config/nvim',
    wezterm.home_dir .. '/programming/python-projects/interview-practice',
    wezterm.home_dir .. '/programming/web-projects/intouch',
    -- ... keep going, list all your projects
    -- (or create a function that does this automatically)
  }
end

function module.choose_project()
  local choices = {}
  for _, value in ipairs(project_dirs()) do
    table.insert(choices, { label = value })
  end

  -- The InputSelector action presents a modal UI for choosing between a set of options
  -- within WezTerm.
  return wezterm.action.InputSelector {
    title = 'Projects',
    -- The options we wish to choose from
    choices = choices,
    -- Typing "ratoru" will filter down to "~/programming/ratoru.com".
    fuzzy = true,
    action = wezterm.action_callback(function(child_window, child_pane, _, label)
      -- "label" may be empty if nothing was selected.
      if not label then
        return
      end

      wezterm.log_info('Opening project: ', label)
      -- The SwitchToWorkspace action will switch us to a workspace if it already exists,
      -- otherwise it will create it for us.
      child_window:perform_action(
        wezterm.action.SwitchToWorkspace {
          -- Give our new workspace a nice name, like the last path segment
          -- of the directory we're opening up.
          name = label:match '([^/]+)$',
          -- Spawn a new terminal with the current working
          -- directory set to the directory that was picked.
          spawn = { cwd = label },
        },
        child_pane
      )
    end),
  }
end

return module
