-- [[ vim.pack hooks ]]
--  Replaces lazy.nvim's `build = ...`. Runs on PackChanged for kind = install | update | delete.
--  See `:help vim.pack-events`

vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('pack-hooks', { clear = true }),
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind

    -- Keep installed parsers in sync with the plugin's queries.
    if name == 'nvim-treesitter' and kind == 'update' then
      if not ev.data.active then
        vim.cmd.packadd 'nvim-treesitter'
      end
      vim.cmd 'TSUpdate'
    end
  end,
})

-- vim: ts=2 sts=2 sw=2 et
