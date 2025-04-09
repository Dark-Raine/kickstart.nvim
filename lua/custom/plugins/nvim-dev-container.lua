return {
  'esensar/nvim-dev-container',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  config = function()
    require('devcontainer').setup {
      mounts = {},
      attach_mounts = {
        neovim_config = {
          enabled = true,
          options = { 'readonly' },
        },
        -- Ensures your dotfiles (like .gitconfig) aren't missing
        -- home = {
        --   enabled = true,
        --   options = { "readonly" }
        -- },
      },
      log_level = 'debug', -- helpful while debugging
    }
  end,
}
