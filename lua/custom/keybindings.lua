-- local map = vim.keymap.setting
-- exit insert mode
vim.keymap.set('i', 'jj', '<Esc>', { noremap = true, silent = true })
-- cycle through buffers/tabs
vim.keymap.set('n', '<Tab>', '<cmd>BufferLineCycleNext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<CR>', { desc = 'Previous buffer' })
-- close current buffer
vim.keymap.set('n', '<leader>bx', '<cmd>bdelete<CR>', { desc = 'Close current buffer' })
