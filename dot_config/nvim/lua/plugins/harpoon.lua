return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'

    -- REQUIRED
    harpoon:setup()
    -- REQUIRED

    vim.keymap.set('n', '<leader>jm', function()
      harpoon:list():add()
    end, { desc = 'Add hot key file' })

    vim.keymap.set('n', '<leader>ja', function()
      harpoon:list():select(1)
    end, { desc = 'Switch to 1st file' })
    vim.keymap.set('n', '<leader>js', function()
      harpoon:list():select(2)
    end, { desc = 'Switch to 2nd file' })
    vim.keymap.set('n', '<leader>jd', function()
      harpoon:list():select(3)
    end, { desc = 'Switch to 3rd file' })
    vim.keymap.set('n', '<leader>jf', function()
      harpoon:list():select(4)
    end, { desc = 'Switch to 4th file' })

    -- basic telescope configuration
    -- local conf = require('telescope.config').values
    -- local function toggle_telescope(harpoon_files)
    --   local file_paths = {}
    --   for _, item in ipairs(harpoon_files.items) do
    --     table.insert(file_paths, item.value)
    --   end
    --
    --   local make_finder = function()
    --     local paths = {}
    --
    --     for _, item in ipairs(harpoon_files.items) do
    --       table.insert(paths, item.value)
    --     end
    --
    --     return require('telescope.finders').new_table {
    --       results = paths,
    --     }
    --   end
    --
    --   require('telescope.pickers')
    --     .new({}, {
    --       prompt_title = 'Harpoon',
    --       finder = require('telescope.finders').new_table {
    --         results = file_paths,
    --       },
    --       previewer = conf.file_previewer {},
    --       sorter = conf.generic_sorter {},
    --       -- Use control-d to remove selected entry
    --       attach_mappings = function(prompt_buffer_number, map)
    --         map('i', '<c-d>', function()
    --           local state = require 'telescope.actions.state'
    --           local selected_entry = state.get_selected_entry()
    --           local current_picker = state.get_current_picker(prompt_buffer_number)
    --
    --           harpoon:list():remove(selected_entry)
    --           current_picker:refresh(make_finder())
    --         end)
    --
    --         return true
    --       end,
    --     })
    --     :find()
    -- end

    -- vim.keymap.set('n', '<C-e>', function()
    --   toggle_telescope(harpoon:list())
    -- end, { desc = 'Open harpoon window' })
    -- vim.keymap.set('n', '<leader>jo', function()
    --   toggle_telescope(harpoon:list())
    -- end, { desc = 'Open harpoon window' })

    -- Toggle previous & next buffers stored within Harpoon list
    -- vim.keymap.set('n', '<C-S-P>', function()
    --   harpoon:list():prev()
    -- end, { desc = 'Switch to prev harpoon file' })
    -- vim.keymap.set('n', '<C-S-N>', function()
    --   harpoon:list():next()
    -- end, { desc = 'Switch to next harpoon file' })
    vim.keymap.set('n', '<leader>jp', function()
      harpoon:list():prev()
    end, { desc = 'Switch to [p]rev harpoon file' })
    vim.keymap.set('n', '<leader>jn', function()
      harpoon:list():next()
    end, { desc = 'Switch to [n]ext harpoon file' })

    -- Removing marks
    vim.keymap.set('n', '<leader>jc', function()
      harpoon:list():clear()
    end, { desc = '[C]lear all harpoon marks' })

    -- vim.keymap.set('n', ';x', function()
    --   -- Doesn't work if you are removing first mark?
    --   local buf_name = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
    --   local name = require('plenary.path'):new(buf_name):make_relative(vim.loop.cwd())
    --   local _, index = harpoon:list():get_by_value(name)
    --   if index == nil then
    --     return
    --   end
    --   harpoon:list():remove_at(index)
    --   require('mini.bufremove').delete(0, false)
    -- end, { desc = 'Delete cur harpoon window' })
  end,
}
