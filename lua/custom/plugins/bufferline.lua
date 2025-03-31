-- lua/plugins/bufferline.lua
return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  event = 'VeryLazy',
  config = function()
    require('bufferline').setup {
      options = {
        mode = 'buffers',
        diagnostics = 'nvim_lsp',
        show_close_icon = false,
        show_buffer_close_icons = false,
        always_show_bufferline = true,
      },
    }
  end,
}
