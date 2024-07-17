return {
  'ggandor/leap.nvim',
  config = function()
    -- require('leap').create_default_mappings()
    -- 's' might lead to conflict with 'mini.surround'.
    -- Calling default mappings might cause conflict with lazy.nvim
    vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap-forward)')
    vim.keymap.set({ 'n', 'x', 'o' }, 'S', '<Plug>(leap-backward)')
    vim.keymap.set({ 'n', 'x', 'o' }, 'gs', '<Plug>(leap-from-window)')
  end,
}
