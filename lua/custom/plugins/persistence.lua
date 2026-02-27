return {
  'folke/persistence.nvim',
  event = 'BufReadPre',
  opts = {},
  keys = {
    {
      '<leader>qs',
      function()
        require('persistence').load()
      end,
      desc = 'Session restore',
    },
    {
      '<leader>qS',
      function()
        require('persistence').select()
      end,
      desc = 'Session select',
    },
    {
      '<leader>ql',
      function()
        require('persistence').load { last = true }
      end,
      desc = 'Session restore last',
    },
    {
      '<leader>qd',
      function()
        require('persistence').stop()
      end,
      desc = 'Session disable save',
    },
  },
}
