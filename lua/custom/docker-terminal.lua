local M = {}
local Terminal = require('toggleterm.terminal').Terminal

local function list_docker_containers(callback)
  -- List running containers (name only)
  local handle = io.popen "docker ps --format '{{.Names}}'"
  if handle then
    local result = handle:read '*a'
    handle:close()

    local containers = {}
    for name in result:gmatch '[^\r\n]+' do
      table.insert(containers, name)
    end

    if #containers == 0 then
      vim.notify('No running Docker containers found', vim.log.levels.WARN)
      return
    end

    vim.ui.select(containers, { prompt = 'Choose container to open shell:' }, function(choice)
      if choice then
        callback(choice)
      end
    end)
  else
    vim.notify('Failed to run docker ps', vim.log.levels.ERROR)
  end
end

function M.open()
  list_docker_containers(function(container_name)
    local term = Terminal:new {
      cmd = 'docker exec -it ' .. container_name .. ' bash', -- or sh/zsh
      direction = 'float',
      close_on_exit = false,
      hidden = true,
    }
    term:toggle()
  end)
end

return M
