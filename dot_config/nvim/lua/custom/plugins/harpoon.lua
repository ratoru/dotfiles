return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'

    -- REQUIRED
    harpoon:setup()
    -- REQUIRED

    vim.keymap.set('n', '<leader>a', function()
      harpoon:list():add()
    end, { desc = '[A]dd hot key file' })

    vim.keymap.set('n', ';a', function()
      harpoon:list():select(1)
    end, { desc = 'Switch to 1st file' })
    vim.keymap.set('n', ';s', function()
      harpoon:list():select(2)
    end, { desc = 'Switch to 2nd file' })
    vim.keymap.set('n', ';d', function()
      harpoon:list():select(3)
    end, { desc = 'Switch to 3rd file' })
    vim.keymap.set('n', ';f', function()
      harpoon:list():select(4)
    end, { desc = 'Switch to 4th file' })

    -- basic telescope configuration
    local conf = require('telescope.config').values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require('telescope.pickers')
        .new({}, {
          prompt_title = 'Harpoon',
          finder = require('telescope.finders').new_table {
            results = file_paths,
          },
          previewer = conf.file_previewer {},
          sorter = conf.generic_sorter {},
        })
        :find()
    end

    vim.keymap.set('n', '<C-e>', function()
      toggle_telescope(harpoon:list())
    end, { desc = 'Open harpoon window' })

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set('n', '<C-S-P>', function()
      harpoon:list():prev()
    end)
    vim.keymap.set('n', '<C-S-N>', function()
      harpoon:list():next()
    end)
  end,
}
