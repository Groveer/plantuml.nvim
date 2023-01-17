local M = {}

function M.setup()
  local group = vim.api.nvim_create_augroup('PlantUMLGroup', {})

  vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = '*.puml',
    callback = function(args)
      local command = string.format('plantuml -pipe -tutxt < %s', args.file)
      local buf = vim.api.nvim_create_buf(false, true)

      local id = vim.fn.jobstart(command, {
        on_exit = function(_, code, _)
          if code ~= 0 then
            error(string.format('[plantuml.nvim] Failed to execute "%s", code %d', command, code))
          end

          vim.cmd('split')
          local win = vim.api.nvim_get_current_win()
          vim.api.nvim_win_set_buf(win, buf)
          vim.api.nvim_buf_set_option(buf, 'modifiable', false)
        end,
        on_stdout = function(_, data, _)
          vim.api.nvim_buf_set_lines(buf, 0, -1, true, data)
        end,
        stdout_buffered = true,
      })
      if id <= 0 then
        error(string.format('[plantuml.nvim] Failed to start job for command "%s"', command))
      end
    end,
    group = group,
  })
end

return M
