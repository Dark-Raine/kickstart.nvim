local M = {}

-- Icon mappings by node type
local icons = {
  class = '', -- class icon
  method = '󰊕', -- method icon (good for Ruby, JS)
  ['function'] = '󰊕', -- function icon (JS, Lua, etc.)
  module = '', -- module or namespace
  interface = '',
  struct = '',
  constructor = '',
  file = '',
}

-- Format context with icons
local function get_code_context()
  local ok, context = pcall(require, 'nvim-treesitter.context')
  if not ok or not context or not context.get_cursor_context then
    return ''
  end

  local lines = context.get_cursor_context()
  if type(lines) ~= 'table' or #lines == 0 then
    return ''
  end

  -- Try to parse structure like "class User", "def name", etc.
  local formatted = vim.tbl_map(function(line)
    local type, name = line:match '^(%w+)%s+(.+)'
    if type and icons[type:lower()] then
      return string.format('%s %s', icons[type:lower()], name)
    else
      return line
    end
  end, lines)

  return table.concat(formatted, ' › ')
end

function M.build()
  local filepath = vim.fn.expand '%:~:.' -- relative path from cwd
  local ctx = get_code_context()
  local icon = icons.file or ''

  if ctx ~= '' then
    return string.format('%s %s — %s', icon, filepath, ctx)
  else
    return string.format('%s %s', icon, filepath)
  end
end

return M
