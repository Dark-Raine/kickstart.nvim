local M = {}

local Terminal = require('toggleterm.terminal').Terminal
local terminals = {} -- cache: key -> Terminal
local last_key = nil -- remember last terminal opened

local function get_local_shell_cmd()
  -- Respect Neovim shell first
  local shell = vim.o.shell
  if shell and #shell > 0 then
    return shell
  end

  -- Cross-platform fallbacks
  if jit and jit.os == 'Windows' then
    return (os.getenv 'COMSPEC' or 'cmd.exe')
  end
  return (os.getenv 'SHELL' or '/bin/sh')
end

local function get_or_create_term(key, cmd, direction)
  if terminals[key] and terminals[key].id then
    return terminals[key]
  end
  local term = Terminal:new {
    cmd = cmd,
    direction = direction or 'float',
    close_on_exit = false,
    hidden = true,
  }
  terminals[key] = term
  return term
end

local function list_docker_containers(callback)
  local handle = io.popen "docker ps --format '{{.Names}}'"
  local containers = {}

  if handle then
    local result = handle:read '*a'
    handle:close()
    for name in result:gmatch '[^\r\n]+' do
      table.insert(containers, name)
    end
  end

  -- Always offer local shell
  local choices = { 'Local machine' }
  for _, c in ipairs(containers) do
    table.insert(choices, c)
  end

  local prompt = (#containers == 0) and 'No containers running. Open a local shell?' or 'Choose where to open a shell:'

  vim.ui.select(choices, { prompt = prompt }, function(choice)
    if not choice then
      return
    end
    callback(choice)
  end)
end

--- Public: open picker (reuses terminals by target)
---@param opts table|nil { direction = "float"|"horizontal"|"vertical"|"tab" }
function M.open(opts)
  opts = opts or {}
  local direction = opts.direction or 'float'

  list_docker_containers(function(choice)
    if choice == 'Local machine' then
      local key = '__local__'
      local cmd = get_local_shell_cmd()
      local term = get_or_create_term(key, cmd, direction)
      last_key = key
      term:toggle()
      return
    end

    -- Container shell: try bash, then sh (handled by outer shell with ||)
    local container = choice
    local key = 'container:' .. container
    local cmd = string.format('docker exec -it %s bash -l || docker exec -it %s sh -l', container, container)
    local term = get_or_create_term(key, cmd, direction)
    last_key = key
    term:toggle()
  end)
end

--- Public: quickly toggle the *last* terminal you opened (local or a container)
function M.toggle_last()
  if last_key and terminals[last_key] then
    terminals[last_key]:toggle()
  else
    vim.notify('No terminal opened yet', vim.log.levels.INFO)
  end
end

return M
