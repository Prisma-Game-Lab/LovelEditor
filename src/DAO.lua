local DAO = {}
local DEBUG = true
local isW

local function getDir(...)
  return require('src.saveUtils').getFolderPath(...)
end

local function debugLoadImages(dir)
  local imgs = {}
  dir = '/'..dir
  local wholeDir = love.filesystem.getSaveDirectory() .. dir
  if not DEBUG then DAO.log('searching tiles at "'..wholeDir ..'"') end
  if not love.filesystem.exists(dir) then
    love.filesystem.createDirectory(dir)
  end
  local files = love.filesystem.getDirectoryItems(dir)
  for i,v in pairs(files) do
    if string.sub(v,#v-3) == ".png" then
      local id = string.sub(v,1,#v-4)
      imgs[id] = love.graphics.newImage(dir ..'/'.. v)
    end
  end
  if not DEBUG then DAO.log('sucessfully opened '..#imgs ..' files') end
  return imgs, wholeDir
end

local function isWindows()
  if isWindows == nil then isW = require('src.saveUtils').is_windows() end
  return isW
end


local function loadImages(dir,look)
	local imgs = {}
  local file
  DAO.log('searching tiles at "'..dir ..'"')
  local files = look(dir)--dirLookup(dir,look)
  for i,v in pairs(files) do
    DAO.log('file: '..v)
  end
  for i,v in pairs(files) do
    if string.sub(v,#v-3) == ".png" then
      --print(v)
    	local id = string.sub(v,1,#v-4):match('[^/]+$')
      --print(id)
      file = io.open(v)
    	imgs[id] = love.graphics.newImage(love.filesystem.newFileData(file:read('*all'),'tile.png')) --Problemas em SOs windows. Apesar do path estar correto e o arquivo ser corretamento aberto pelo io.
      file:close()
    end
  end
  DAO.log('sucessfully opened '..#files ..' files')
  return imgs,dir
end


function DAO.getData()
  if DEBUG then return debugLoadImages('TilesDemo')--loadImages('/Users/Piupas/Desktop/LOVE/LovelEditor/TilesDemo')
  else
    if isWindows() then--Medida provisória para windows
      return debugLoadImages('Tiles')
    else
      local path,look = getDir(DAO.log)
      return loadImages(path ..'Tiles',look)
    end
  end
end

local function log(message,mode)
  local time = os.date("*t")
  local file = io.open(getDir() ..'log.txt',mode or 'a')
  file:write('['..time.year ..':'..time.month ..':'..time.day ..':'..time.hour ..':'..time.min ..':'..time.sec ..'] - '..message ..';\n')
  file:close()
end

function DAO.log(message)
  if not DEBUG then log(message) end
end

function DAO.start()
  if not DEBUG then
    log('starting editor. work directory: '..getDir(),'w')
  end
end

function DAO.saveLevel(level,name)
  local t = require 'lib/tableIO'
  local p
  if not DEBUG then
    p = getDir()..name ..'.lua'
    DAO.log('trying to save level data at: "'..p ..'"...')
  else p = name ..'.lua' end
  local suc,err = t.save(level,p)
  if not DEBUG then
    if suc then
      DAO.log('level data successfully saved')
    else
      DAO.log('error saving: tableIO: '..err)
    end
  end
end

function DAO.loadLevel(name)
  --beta, not ready for here yet
end

return DAO