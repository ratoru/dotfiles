-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Quickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- This remap allows you to paste text over a highlighted text
-- while keeping the original text in the yanked register.
vim.keymap.set({ 'n', 'v' }, '<leader>D', [["_d]], { desc = 'Delete without register' })

-- System Clipboard Management
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]], { desc = 'yank to system clipboard' })
vim.keymap.set('n', '<leader>Y', [["+Y]], { desc = 'Yank to system clipboard' })

-- Duplicate and comment the first line. Takes a count.
vim.keymap.set('n', 'ycc', '"yy" . v:count1 . "gcc\']p"', { remap = true, expr = true })

-- Indent while remaining in visual mode.
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- Move selected line / block of text in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- Execute macro over visual region.
vim.keymap.set('x', '@', function() return ':norm @' .. vim.fn.getcharstr() .. '<cr>' end, { expr = true })

-- Quitting.
vim.keymap.set('n', '<leader>Q', '<cmd>qa<cr>', { desc = 'Quit all' })

-- Keeping the cursor centered.
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll downwards' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll upwards' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next result' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous result' })

-- Window management
vim.keymap.set('n', '<leader>be', '<C-w>=', { desc = 'Make windows Equal size' })

-- Paste linewise before/after current line
-- Usage: `yiw` to yank a word and `]p` to put it on the next line.
vim.keymap.set('n', '[p', '<Cmd>exe "put! " . v:register<CR>', { desc = 'Paste Above' })
vim.keymap.set('n', ']p', '<Cmd>exe "put "  . v:register<CR>', { desc = 'Paste Below' })

-- vim: ts=2 sts=2 sw=2 et
