return {
  'stevearc/conform.nvim',
  opts = {
    format_on_save = {
      lsp_fallback = true,
      timeout_ms = 250,
    },
    formatters_by_ft = {
      javascript = { 'eslint_d', 'prettier' },
      typescript = { 'eslint_d', 'prettier' },
      javascriptreact = { 'eslint_d', 'prettier' },
      typescriptreact = { 'eslint_d', 'prettier' },
      json = { 'prettier' },
      yaml = { 'prettier' },
      markdown = { 'prettier' },
      html = { 'prettier' },
      css = { 'prettier' },
      scss = { 'prettier' },
      lua = { 'stylua' },
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
    },
  },
}
