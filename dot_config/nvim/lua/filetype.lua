-- Recognize some files known to have JSON with comments.
vim.filetype.add {
  filename = {
    ['.eslintrc.json'] = 'jsonc',
  },
  pattern = {
    ['tsconfig*.json'] = 'jsonc',
  },
  extension = {
    ['http'] = 'http',
    ['mdx'] = 'markdown.mdx',
  },
}

-- `.mdx` gets the compound `markdown.mdx` filetype above, but Neovim has no
-- `mdx` Treesitter parser. Point the `mdx` language at the `markdown` parser
-- so highlighting/parsing (and markview) work.
vim.treesitter.language.register('markdown', 'mdx')
