io.stdout:setvbuf("no")
local screen

local str

function love.load()
	screen = require ('src.MainScreen')
	--love.keyboard.setKeyRepeat(true)
	local img = love.graphics.newImage('bil1.png')
	love.mouse.setCursor(love.mouse.newCursor(img:getData(), img:getWidth()/2,img:getHeight()/2))
	str = love.filesystem.getSourceBaseDirectory()
	--str = require('src.saveUtils').getFolderPath()
end

function love.update(dt)
	screen:update(dt)
end

function love.draw()
	screen:draw()
	--[[
	local x, y = love.mouse.getPosition()
	love.graphics.setColor(0,0,0)
	love.graphics.print(x..'\n'..y,x,y-28)
	]]
	
	love.graphics.rectangle('fill',0,0,200,100)
	love.graphics.setColor(0,255,0)
	love.graphics.print(str)
	
end

function love.wheelmoved(x,y)
  screen:wheelmoved(x,y)
end

function love.mousepressed(x,y,b)
  screen:mousepressed(x,y,b)
end

function love.mousemoved(x,y,dx,dy)
  screen:mousemoved(x,y,dx,dy)
end

function love.mousereleased(x,y,b)
  screen:mousereleased(x,y,b)
end

function love.keypressed(key)
	print('key = '..key)
  screen:keypressed(key)
end