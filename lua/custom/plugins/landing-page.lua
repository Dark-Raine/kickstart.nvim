return {
  'goolord/alpha-nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'

    -- Set Header (ASCII Art)
    dashboard.section.header.val = {
      '      _       _   ',
      '  ___| |_   _| |_ ',
      ' / _ \\ | | | | __|',
      '|  __/ | |_| | |_ ',
      ' \\___|_|\\__,_|\\__|',
      '  Neovim Dashboard ',
    }

    -- Buttons (Shortcuts)
    dashboard.section.buttons.val = {
      dashboard.button('e', '  New File', ':ene <BAR> startinsert <CR>'),
      dashboard.button('f', '  Find File', ':Telescope find_files<CR>'),
      dashboard.button('r', '  Recent Files', ':Telescope oldfiles<CR>'),
      dashboard.button('p', '  Projects', ':Telescope projects<CR>'),
      dashboard.button('q', '  Quit Neovim', ':qa<CR>'),
    }

    -- Footer (Tip or Info)
    dashboard.section.footer.val = { '🚀 Happy Coding!' }

    -- Apply theme and settings
    alpha.setup(dashboard.opts)
  end,
}
