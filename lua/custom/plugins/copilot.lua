return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = function()
    local function parse_semver(version)
      local major, minor, patch = version:match '^(%d+)%.(%d+)%.(%d+)$'
      if not major then
        return nil
      end
      return { tonumber(major), tonumber(minor), tonumber(patch) }
    end

    local function is_gte(a, b)
      for i = 1, 3 do
        if a[i] > b[i] then
          return true
        end
        if a[i] < b[i] then
          return false
        end
      end
      return true
    end

    local function is_gt(a, b)
      for i = 1, 3 do
        if a[i] > b[i] then
          return true
        end
        if a[i] < b[i] then
          return false
        end
      end
      return false
    end

    local function pick_copilot_node()
      local min_required = { 22, 13, 0 }
      local best_path = nil
      local best_version = nil

      local nvm_nodes = vim.fn.glob(vim.fn.expand '~/.nvm/versions/node/v*/bin/node', false, true)
      for _, path in ipairs(nvm_nodes) do
        local version_str = path:match '/v(%d+%.%d+%.%d+)/bin/node$'
        local version = version_str and parse_semver(version_str) or nil
        if version and is_gte(version, min_required) and ((not best_version) or is_gt(version, best_version)) then
          best_path = path
          best_version = version
        end
      end

      if best_path and vim.fn.executable(best_path) == 1 then
        return best_path
      end
      return 'node'
    end

    require('copilot').setup {
      copilot_node_command = pick_copilot_node(),
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = '<C-l>',
          next = '<C-j>',
          prev = '<C-k>',
          dismiss = '<C-]>',
        },
      },
      panel = { enabled = false }, -- you can enable this later
      filetypes = {
        gitcommit = true,
        ['*'] = true,
      },
    }
  end,
}
