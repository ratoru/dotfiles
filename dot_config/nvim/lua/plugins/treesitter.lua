---@module 'lazy'
---@type LazySpec
return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    branch = 'main',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter-intro`
    config = function()
      ---@param buf integer
      ---@param language string
      local function treesitter_attach(buf, language)
        -- check if parser exists before starting highlighter
        if not vim.treesitter.language.add(language) then
          return
        end
        -- enables syntax highlighting and other treesitter features
        vim.treesitter.start(buf, language)

        -- enables treesitter based folds
        -- for more info on folds see `:help folds`
        -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

        -- enables treesitter based indentation
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end

      local available_parsers = require('nvim-treesitter.config').get_available()
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local buf, filetype = args.buf, args.match
          local language = vim.treesitter.language.get_lang(filetype)
          if not language then
            return
          end

          local installed = require('nvim-treesitter').get_installed 'parsers'
          if vim.tbl_contains(installed, language) then
            -- parser is already installed attach
            treesitter_attach(buf, language)
          elseif vim.tbl_contains(available_parsers, language) then
            -- parser is not installed but available install it first then attach
            require('nvim-treesitter').install(language):await(function() treesitter_attach(buf, language) end)
          end
        end,
      })

      -- ensure basic parser are installed
      local parsers = { 'bash', 'c', 'diff', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'toml', 'vim', 'vimdoc', 'yaml' }
      require('nvim-treesitter').install(parsers)
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
