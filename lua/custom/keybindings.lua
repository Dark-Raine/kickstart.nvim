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
-- open terminal with docker exec
vim.keymap.set('n', '<leader>dt', function()
  require('custom.docker-terminal').open()
end, { desc = 'Open Docker terminal' })
