
local ScreenObject = Class.new('so')

function ScreenObject.new(id)
	local self = ScreenObject.newObject()
	self.id = id
	self.img = nil
	self.quad = nil
	return self
end