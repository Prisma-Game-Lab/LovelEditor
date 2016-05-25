local DAO = {}

local function loadImages(dir)
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

function DAO.getData()
	return loadImages('Tiles')
end

function DAO.saveLevel(level)
	(require 'lib/tableIO').save(level,'test.lua',fuckThis)
  
end

return DAO