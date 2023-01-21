local M = {}

M.Renderer = {}

function M.Renderer:new()
  local buf = vim.api.nvim_create_buf(false, true)
  assert(buf ~= 0, string.format('[plantuml.nvim] Failed to create buffer'))

  self.__index = self
  return setmetatable({ buf = buf, win = nil }, self)
end

function M.Renderer:render(file)
  local command = string.format('plantuml -pipe -tutxt < %s', file)

  local id = vim.fn.jobstart(command, {
    on_exit = function(_, code, _)
      assert(code == 0, string.format('[plantuml.nvim] Failed to execute "%s", code %d', command, code))
      self:_create_split()
    end,
    on_stdout = function(_, output, _) self:_write_output(output) end,
    stdout_buffered = true,
  })
  assert(id > 0, string.format('[plantuml.nvim] Failed to start job for command "%s"', command))
end

function M.Renderer:_write_output(output)
  vim.api.nvim_buf_set_lines(self.buf, 0, -1, true, output)
end

function M.Renderer:_create_split()
  -- Only create the window if it's not already created.
  if not (self.win and vim.api.nvim_win_is_valid(self.win)) then
    vim.cmd('split')
    self.win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(self.win, self.buf)
  end
end

return M
