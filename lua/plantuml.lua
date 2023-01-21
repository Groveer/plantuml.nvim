local text = require('plantuml.text')
local imv = require('plantuml.imv')

local M = {}

local function create_renderer(type)
  local renderer
  if type == 'text' then
    renderer = text.Renderer:new()
  elseif type == 'imv' then
    renderer = imv.Renderer:new()
  else
    print(string.format('[plantuml.nvim] Invalid renderer type: %s', type))
  end

  return renderer
end

function M.setup()
  local group = vim.api.nvim_create_augroup('PlantUMLGroup', {})

  local renderer = create_renderer('text')
  if renderer then
    vim.api.nvim_create_autocmd('BufWritePost', {
      pattern = '*.puml',
      callback = function(args)
        renderer:render(args.file)
      end,
      group = group,
    })
  end
end

return M
