local text = require('plantuml.text')
local imv = require('plantuml.imv')

local M = {}

local function merge_config(dst, src)
  for key, value in pairs(src) do
    dst[key] = value
  end
end

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

local function create_autocmd(group, renderer)
    vim.api.nvim_create_autocmd('BufWritePost', {
      pattern = '*.puml',
      callback = function(args)
        renderer:render(args.file)
      end,
      group = group,
    })
end

function M.setup(config)
  local _config = { renderer = 'imv' }
  merge_config(_config, config or {})

  local group = vim.api.nvim_create_augroup('PlantUMLGroup', {})

  local renderer = create_renderer(_config.renderer)
  if renderer then
    create_autocmd(group, renderer)
  end
end

return M
