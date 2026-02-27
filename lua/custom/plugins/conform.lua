local util = require 'conform.util'

local function local_node_executable(bin)
  return util.find_executable({ 'node_modules/.bin/' .. bin }, '__local_' .. bin .. '_not_found__')
end

local prettier_root_files = {
  '.prettierrc',
  '.prettierrc.json',
  '.prettierrc.yml',
  '.prettierrc.yaml',
  '.prettierrc.json5',
  '.prettierrc.js',
  '.prettierrc.cjs',
  '.prettierrc.mjs',
  '.prettierrc.toml',
  'prettier.config.js',
  'prettier.config.cjs',
  'prettier.config.mjs',
  'prettier.config.ts',
  'prettier.config.cts',
  'prettier.config.mts',
}

local eslint_root_files = {
  'eslint.config.js',
  'eslint.config.cjs',
  'eslint.config.mjs',
  'eslint.config.ts',
  'eslint.config.cts',
  'eslint.config.mts',
  '.eslintrc',
  '.eslintrc.js',
  '.eslintrc.cjs',
  '.eslintrc.yaml',
  '.eslintrc.yml',
  '.eslintrc.json',
}

local eslint_legacy_files = {
  '.eslintrc',
  '.eslintrc.js',
  '.eslintrc.cjs',
  '.eslintrc.yaml',
  '.eslintrc.yml',
  '.eslintrc.json',
}

local eslint_flat_files = {
  'eslint.config.js',
  'eslint.config.cjs',
  'eslint.config.mjs',
  'eslint.config.ts',
  'eslint.config.cts',
  'eslint.config.mts',
}

local function read_json(file)
  local handle = io.open(file, 'r')
  if not handle then
    return nil
  end

  local content = handle:read '*a'
  handle:close()
  if not content then
    return nil
  end

  local ok, decoded = pcall(vim.json.decode, content)
  if not ok then
    return nil
  end

  return decoded
end

local function root_with_package_field(root_files, package_field)
  return function(_, ctx)
    return vim.fs.root(ctx.dirname, function(name, dir)
      if name == 'package.json' then
        local package_json = read_json(vim.fs.joinpath(dir, name))
        return package_json and package_json[package_field] ~= nil or false
      end

      return vim.tbl_contains(root_files, name)
    end)
  end
end

local function has_any_file(dir, names)
  for _, name in ipairs(names) do
    if vim.uv.fs_stat(vim.fs.joinpath(dir, name)) then
      return true
    end
  end

  return false
end

local eslint_cwd = root_with_package_field(eslint_root_files, 'eslintConfig')

return {
  'stevearc/conform.nvim',
  opts = {
    format_on_save = function()
      return {
        timeout_ms = 2000,
        lsp_format = 'fallback',
      }
    end,
    formatters_by_ft = {
      javascript = { 'eslint_local' },
      typescript = { 'eslint_local' },
      javascriptreact = { 'eslint_local' },
      typescriptreact = { 'eslint_local' },
      json = { 'prettier' },
      yaml = { 'prettier' },
      markdown = { 'prettier' },
      html = { 'prettier' },
      css = { 'prettier' },
      scss = { 'prettier' },
      lua = { 'stylua' },
      gherkin = { 'reformat_gherkin' },
      cucumber = { 'reformat_gherkin' },
    },
    formatters = {
      eslint_local = {
        command = local_node_executable 'eslint',
        args = { '--fix', '$FILENAME' },
        stdin = false,
        tmpfile_format = 'conform.$RANDOM.$FILENAME',
        exit_codes = { 0, 1 },
        cwd = eslint_cwd,
        env = function(_, ctx)
          local cwd = eslint_cwd(nil, ctx)
          if not cwd then
            return nil
          end

          local has_flat_config = has_any_file(cwd, eslint_flat_files)
          local has_legacy_config = has_any_file(cwd, eslint_legacy_files)
          if has_legacy_config and not has_flat_config then
            return { ESLINT_USE_FLAT_CONFIG = 'false' }
          end

          return nil
        end,
        require_cwd = true,
      },
      prettier = {
        command = local_node_executable 'prettier',
        args = { '--stdin-filepath', '$FILENAME' },
        cwd = root_with_package_field(prettier_root_files, 'prettier'),
        require_cwd = true,
      },
      reformat_gherkin = {
        command = 'reformat-gherkin',
        args = { '--multi-line-tags', '-' },
        stdin = true,
      },
    },
  },
}
