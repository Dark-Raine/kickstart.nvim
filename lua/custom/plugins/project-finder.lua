return {
  'ahmedkhalf/project.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim' },
  config = function()
    require('project_nvim').setup {
      detection_methods = { 'pattern', 'lsp' }, -- Detect projects using `.git` or custom patterns
      patterns = { '.git', 'Makefile', 'package.json' }, -- Add custom project markers
      manual_mode = false,
    }
    require('telescope').load_extension 'projects'
  end,
}
