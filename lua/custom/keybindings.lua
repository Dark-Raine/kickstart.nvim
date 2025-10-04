-- local map = vim.keymap.setting
-- exit insert mode
vim.keymap.set('i', 'jj', '<Esc>', { noremap = true, silent = true })
-- cycle through buffers/tabs
vim.keymap.set('n', '<Tab>', '<cmd>BufferLineCycleNext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<CR>', { desc = 'Previous buffer' })
-- close current buffer
vim.keymap.set('n', '<leader>bx', '<cmd>bdelete<CR>', { desc = 'Close current buffer' })
vim.keymap.set('n', '<leader>gb', function()
  require('gitsigns').blame_line { full = true }
end, { desc = 'Git blame line' })
-- search for highlighted selection
vim.keymap.set('v', '//', [[y/\V<C-r>"<CR>]], { desc = 'Search for visual selection' })
-- Open picker (creates/reuses floating)
vim.keymap.set('n', '<leader>do', function()
  require('custom.docker-terminal').open()
end, { desc = 'Docker/local shell' })

-- Flip back to the *same* terminal you last used
vim.keymap.set('n', '<leader>dt', function()
  require('custom.docker-terminal').toggle_last()
end, { desc = 'Toggle last shell' })
-- Close terminal from inside (works in any mode, but especially insert)
vim.keymap.set('t', 'xx', function()
  require('custom.docker-terminal').toggle_last()
end, { desc = 'Close terminal from inside' })
