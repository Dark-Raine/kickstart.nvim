return {
  'nvim-tree/nvim-tree.lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('nvim-tree').setup {
      view = {
        width = 30,
        side = 'left',
        relativenumber = true, -- Show relative line numbers
      },
      renderer = {
        group_empty = true, -- Group empty folders
        icons = {
          show = {
            git = true,
            folder = true,
            file = true,
            folder_arrow = true,
          },
        },
      },
      filters = {
        dotfiles = false, -- Show dotfiles
        custom = { '.git', 'node_modules', 'dist' },
      },
    }

    -- Keybinding to toggle file tree
    vim.keymap.set('n', '<leader>eo', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle file explorer' })
    vim.keymap.set('n', '<leader>ef', '<cmd>NvimTreeFindFile<CR>', { desc = 'Toggle file explorer to open file' })
  end,
}
