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

vim.treesitter.language.register('markdown', 'mdx')
