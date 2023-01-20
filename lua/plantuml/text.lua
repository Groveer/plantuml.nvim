local M = {}

M.Renderer = {}

local function create_split(buf)
  vim.cmd('split')
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, buf)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
end

local function write_output(buf, output)
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, output)
end

function M.Renderer.render(file)
  local buf = vim.api.nvim_create_buf(false, true)
  assert(buf ~= 0, string.format('[plantuml.nvim] Failed to create buffer'))

  local command = string.format('plantuml -pipe -tutxt < %s', file)

  local id = vim.fn.jobstart(command, {
    on_exit = function(_, code, _)
      assert(code == 0, string.format('[plantuml.nvim] Failed to execute "%s", code %d', command, code))
      create_split(buf)
    end,
    on_stdout = function(_, output, _) write_output(buf, output) end,
    stdout_buffered = true,
  })
  assert(id > 0, string.format('[plantuml.nvim] Failed to start job for command "%s"', command))
end

return M
