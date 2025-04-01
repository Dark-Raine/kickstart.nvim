return {
  'stevearc/conform.nvim',
  opts = {
    format_on_save = {
      lsp_fallback = true,
      timeout_ms = 250,
    },
    formatters_by_ft = {
      javascript = { 'prettier' },
      typescript = { 'prettier' },
      javascriptreact = { 'prettier' },
      typescriptreact = { 'prettier' },
      json = { 'prettier' },
      yaml = { 'prettier' },
      markdown = { 'prettier' },
      html = { 'prettier' },
      css = { 'prettier' },
      scss = { 'prettier' },
      lua = { 'stylua' },
      ruby = { 'rubocop' },
    },
    formatters = {
      prettier = {
        command = 'prettier',
        args = { '--stdin-filepath', '$FILENAME' },
        cwd = require('conform.util').root_file {
          '.prettierrc',
          '.prettierrc.js',
          '.prettierrc.json',
          'package.json',
        },
      },
      rubocop = {
        command = '~/.local/bin/rubocop-docker-wrapper.sh',
        args = { '--auto-correct', '--stdin', '$FILENAME', '-f', 'quiet' },
        stdin = true,
        cwd = require('conform.util').root_file {
          '.rubocop.yml',
          '.rubocop_todo.yml',
          'Gemfile',
        },
      },
    },
  },
}
