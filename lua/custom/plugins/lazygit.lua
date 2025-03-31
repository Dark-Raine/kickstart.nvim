return {
  'kdheepak/lazygit.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' }, -- Required dependency
  config = function()
    vim.keymap.set('n', '<leader>lg', '<cmd>LazyGit<CR>', { desc = 'Open LazyGit' })
  end,
}
