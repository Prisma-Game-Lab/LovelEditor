local path = (...):match("(.-)[^%.]+$")
local class = require (path.."class")
local View = require (path.."View")

local TextField = class.extends(View,"TextField")

local keys = {space = ' '}
local blinkTime = 0.5

------------------------------------------
-- Public functions
------------------------------------------

function TextField.new(x,y,width,height)
	local self = TextField.newObject(x,y,width,height)
	self.text = "Cmon"
	self.textColor = {0,0,0}
	self.textAlignment = 'left'
	self.isSelected = false
	self.blinkOn = false
	return self
end

--[[
function TextField:mousepressed(x,y,b)
	self.super:mousepressed(x,y,b)
	self.isSelected = true
end
]]

function TextField:mousemoved(x,y,dx,dy)
	self.isSelected = true
end

function TextField:clearMouse()
	self.super:clearMouse()
	--[[
	if love.mouse.isDown(1) then
		self.isSelected = false
	end]]
	self.isSelected = false
end

function TextField:keypressed(key)
	self:becomeResponder()
end

function TextField:respondKey()
	if keys[key] then
		self.text = self.text .. keys[key]
	elseif key=='return' then
		self.text = self.text .. '\n'
	elseif key=='backspace' then
		local l = string.len(self.text)
		if l>0 then
			self.text = string.sub(self.text,0,l-1)
		end
	elseif string.len(key)==1 then
		--[[
		if love.keyboard.isDown('Caps-on') then
			key = string.upper(key)
		end]]
		self.text = self.text .. key
	end
end

function TextField:becomeResponder()
	if self.screen ~= nil then
    self.screen:becomeResponder(self)
  end
end

function TextField:becameResponder()
	self.isSelected = true
end

function TextField:endResponder()
	self.isSelected = false
end

function TextField:draw()
	self:pre_draw()
	self:during_draw()
	self:pos_draw()
end

function TextField:during_draw()
	self.super:during_draw()
	love.graphics.setColor(self.textColor)
	local t = self.text
	if self.isSelected and self.blinkOn then t=self.text .. "|" end
	love.graphics.printf(t,0,0,self.width,self.textAlignment)
end

return TextField