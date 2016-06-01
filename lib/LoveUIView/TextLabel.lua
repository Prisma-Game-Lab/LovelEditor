local path = (...):match("(.-)[^%.]+$")
local class = require (path.."class")
local View = require (path.."View")

local TextLabel = class.extends(View,"TextLabel")

------------------------------------------
-- Public functions
------------------------------------------

function TextLabel.new(x,y,width,height)
	local self = TextLabel.newObject(x,y,width,height)
	self.text = ''
	self.textColor = {0,0,0}
	self.textAlignment = 'left'
	self.isSelected = false
	self.blinkOn = false
	return self
end

function TextLabel:draw()
	self:pre_draw()
	self:during_draw()
	self:pos_draw()
end

function TextLabel:during_draw()
	self.super:during_draw()
	love.graphics.setColor(self.textColor)
	love.graphics.printf(self.text,0,0,self.width,self.textAlignment)
end

return TextLabel