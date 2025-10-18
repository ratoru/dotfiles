---@module 'lazy'
---@type LazySpec
return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  event = 'VeryLazy',
  branch = 'main',
  opts = {
    textobjects = {
      select = {
        enable = true,
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
      },
      swap = {
        enable = true,
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
      },
    },
  },
  keys = {
    -- Select keymaps
    {
      'i=',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@assignment.inner', 'textobjects') end,
      mode = { 'x', 'o' },
      desc = 'Select inner part of an assignment',
    },
    {
      'l=',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@assignment.lhs', 'textobjects') end,
      mode = { 'x', 'o' },
      desc = 'Select left hand side of an assignment',
    },
    {
      'r=',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@assignment.rhs', 'textobjects') end,
      mode = { 'x', 'o' },
      desc = 'Select right hand side of an assignment',
    },
    {
      'aa',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@parameter.outer', 'textobjects') end,
      mode = { 'x', 'o' },
      desc = 'Select outer part of a parameter/argument',
    },
    {
      'ia',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@parameter.inner', 'textobjects') end,
      mode = { 'x', 'o' },
      desc = 'Select inner part of a parameter/argument',
    },
    {
      'ai',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@conditional.outer', 'textobjects') end,
      mode = { 'x', 'o' },
      desc = 'Select outer part of a conditional',
    },
    {
      'ii',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@conditional.inner', 'textobjects') end,
      mode = { 'x', 'o' },
      desc = 'Select inner part of a conditional',
    },
    {
      'al',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@loop.outer', 'textobjects') end,
      mode = { 'x', 'o' },
      desc = 'Select outer part of a loop',
    },
    {
      'il',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@loop.inner', 'textobjects') end,
      mode = { 'x', 'o' },
      desc = 'Select inner part of a loop',
    },
    {
      'af',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@call.outer', 'textobjects') end,
      mode = { 'x', 'o' },
      desc = 'Select outer part of a function call',
    },
    {
      'if',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@call.inner', 'textobjects') end,
      mode = { 'x', 'o' },
      desc = 'Select inner part of a function call',
    },
    {
      'am',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects') end,
      mode = { 'x', 'o' },
      desc = 'Select outer part of a method/function definition',
    },
    {
      'im',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects') end,
      mode = { 'x', 'o' },
      desc = 'Select inner part of a method/function definition',
    },
    {
      'ac',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects') end,
      mode = { 'x', 'o' },
      desc = 'Select outer part of a class',
    },
    {
      'ic',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects') end,
      mode = { 'x', 'o' },
      desc = 'Select inner part of a class',
    },
    {
      'a=',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@assignment.outer', 'textobjects') end,
      mode = { 'x', 'o' },
      desc = 'Select outer part of an assignment',
    },
    -- Swap keymaps
    {
      '<leader>cp',
      function() require('nvim-treesitter-textobjects.swap').swap_next '@parameter.inner' end,
      desc = 'Swap parameters/argument with next',
    },
    {
      '<leader>cf',
      function() require('nvim-treesitter-textobjects.swap').swap_next '@function.outer' end,
      desc = 'Swap function with next',
    },
    {
      '<leader>cP',
      function() require('nvim-treesitter-textobjects.swap').swap_previous '@parameter.inner' end,
      desc = 'Swap parameters/argument with previous',
    },
    {
      '<leader>cF',
      function() require('nvim-treesitter-textobjects.swap').swap_previous '@function.outer' end,
      desc = 'Swap function with previous',
    },
    -- Move keymaps - goto_next_start
    {
      ']f',
      function() require('nvim-treesitter-textobjects.move').goto_next_start('@call.outer', 'textobjects') end,
      desc = 'Next function call start',
    },
    {
      ']m',
      function() require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects') end,
      desc = 'Next method/function def start',
    },
    {
      ']]',
      function() require('nvim-treesitter-textobjects.move').goto_next_start('@class.outer', 'textobjects') end,
      desc = 'Next class start',
    },
    {
      ']i',
      function() require('nvim-treesitter-textobjects.move').goto_next_start('@conditional.outer', 'textobjects') end,
      desc = 'Next conditional start',
    },
    {
      ']o',
      function() require('nvim-treesitter-textobjects.move').goto_next_start('@loop.outer', 'textobjects') end,
      desc = 'Next loop start',
    },
    {
      ']s',
      function() require('nvim-treesitter-textobjects.move').goto_next_start('@local.scope', 'textobjects', 'locals') end,
      desc = 'Next scope',
    },
    {
      ']z',
      function() require('nvim-treesitter-textobjects.move').goto_next_start('@fold', 'textobjects', 'folds') end,
      desc = 'Next fold',
    },
    -- Move keymaps - goto_next_end
    {
      ']F',
      function() require('nvim-treesitter-textobjects.move').goto_next_end('@call.outer', 'textobjects') end,
      desc = 'Next function call end',
    },
    {
      ']M',
      function() require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects') end,
      desc = 'Next method/function def end',
    },
    {
      '][',
      function() require('nvim-treesitter-textobjects.move').goto_next_end('@class.outer', 'textobjects') end,
      desc = 'Next class end',
    },
    {
      ']I',
      function() require('nvim-treesitter-textobjects.move').goto_next_end('@conditional.outer', 'textobjects') end,
      desc = 'Next conditional end',
    },
    {
      ']O',
      function() require('nvim-treesitter-textobjects.move').goto_next_end('@loop.outer', 'textobjects') end,
      desc = 'Next loop end',
    },
    -- Move keymaps - goto_previous_start
    {
      '[f',
      function() require('nvim-treesitter-textobjects.move').goto_previous_start('@call.outer', 'textobjects') end,
      desc = 'Prev function call start',
    },
    {
      '[m',
      function() require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects') end,
      desc = 'Prev method/function def start',
    },
    {
      '[[',
      function() require('nvim-treesitter-textobjects.move').goto_previous_start('@class.outer', 'textobjects') end,
      desc = 'Prev class start',
    },
    {
      '[i',
      function() require('nvim-treesitter-textobjects.move').goto_previous_start('@conditional.outer', 'textobjects') end,
      desc = 'Prev conditional start',
    },
    {
      '[o',
      function() require('nvim-treesitter-textobjects.move').goto_previous_start('@loop.outer', 'textobjects') end,
      desc = 'Prev loop start',
    },
    -- Move keymaps - goto_previous_end
    {
      '[F',
      function() require('nvim-treesitter-textobjects.move').goto_previous_end('@call.outer', 'textobjects') end,
      desc = 'Prev function call end',
    },
    {
      '[M',
      function() require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects') end,
      desc = 'Prev method/function def end',
    },
    {
      '[]',
      function() require('nvim-treesitter-textobjects.move').goto_previous_end('@class.outer', 'textobjects') end,
      desc = 'Prev class end',
    },
    {
      '[I',
      function() require('nvim-treesitter-textobjects.move').goto_previous_end('@conditional.outer', 'textobjects') end,
      desc = 'Prev conditional end',
    },
    {
      '[O',
      function() require('nvim-treesitter-textobjects.move').goto_previous_end('@loop.outer', 'textobjects') end,
      desc = 'Prev loop end',
    },
  },
}
