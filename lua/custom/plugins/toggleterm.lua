-- lua/plugins/toggleterm.lua
return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    require('toggleterm').setup {
      direction = 'float',
      close_on_exit = true,
      shell = vim.o.shell, -- or override if needed
    }
  end,
}
