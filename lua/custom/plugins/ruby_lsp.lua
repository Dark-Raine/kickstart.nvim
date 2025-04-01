return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      local lspconfig = require 'lspconfig'
      local configs = require 'lspconfig.configs'

      if not configs.ruby_lsp then
        configs.ruby_lsp = {
          default_config = {
            name = 'ruby_lsp',
            cmd = { vim.fn.expand '~/.local/bin/ruby-lsp-docker-wrapper.sh' },
            filetypes = { 'ruby' },
            root_dir = lspconfig.util.root_pattern 'Gemfile',
          },
        }
      end

      lspconfig.ruby_lsp.setup {}
    end,
  },
}
