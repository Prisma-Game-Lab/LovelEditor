local DAO = {}
local DEBUG = true

local function dirLookup(dir)
   local p = io.popen('find "'..dir..'" -type f')  --Open directory look for files, save data in p. By giving '-type f' as parameter, it returns all files.     
   local files = {}
   for file in p:lines() do                         --Loop through all files
       table.insert(files,file)      
   end
   return files
end

local function getDir()
  return require('src.saveUtils').getFolderPath()
end

local function debugLoadImages(dir)
  local imgs = {}
  dir = '/'..dir
  if not love.filesystem.exists(dir) then
    love.filesystem.createDirectory(dir)
    --[[
    for i,v in pairs(love.filesystem.getDirectoryItems("/SpritesDemo")) do
          if string.sub(v,#v-3) == ".png" then
            local img = love.graphics.newImage("/SpritesDemo/"..v)
            img:getData():encode("png","/Sprites/"..v)
            table.insert(canvas.sheets,img)
          end
        end]]
    end
    local files = love.filesystem.getDirectoryItems(dir)
    for i,v in pairs(files) do
      if string.sub(v,#v-3) == ".png" then
        local id = string.sub(v,1,#v-4)
        imgs[id] = love.graphics.newImage(dir ..'/'.. v)
      end
    end
    return imgs
end


local function loadImages(dir)
	local imgs = {}
  --[[
  local file = assert(io.open("/path/to/pig.png", "r"))
  local filedata = love.file.newFileData(file:read("*a"), "pig.png")
  file:close()
  image = love.graphics.newImage(filedata)
  ]]
  local file
  DAO.log('searching tiles at "'..dir ..'"')
  local files = dirLookup(dir)
  for i,v in pairs(files) do
    if string.sub(v,#v-3) == ".png" then
      --print(v)
    	local id = string.sub(v,1,#v-4):match('[^/]+$')
      --print(id)
      file = io.open(v)
    	imgs[id] = love.graphics.newImage(love.filesystem.newFileData(file:read('*a'),'tile.png'))
      file:close()
    end
  end
  DAO.log('sucessfully opened '..#files ..' files')
  return imgs
end


function DAO.getData()
  if DEBUG then return debugLoadImages('TilesDemo')--loadImages('/Users/Piupas/Desktop/LOVE/LovelEditor/TilesDemo')
  else return loadImages(require('src.saveUtils').getFolderPath()..'Tiles')
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

function DAO.saveLevel(level)
  local t = require 'lib/tableIO'
  local p
  if not DEBUG then
    p = getDir()..'test.lua'
    DAO.log('trying to save level data at: "'..p ..'"...')
  else p = 'test.lua' end
  local suc,err = t.save(level,p)
  if not DEBUG then
    if suc then
      DAO.log('level data successfully saved')
    else
      DAO.log('error saving: tableIO: '..err)
    end
  end
end

return DAO