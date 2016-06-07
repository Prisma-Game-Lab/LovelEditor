local ui = require 'lib.LoveUIView'

local MyTextField = ui.extends(ui.TextField,'MyTextField')

function MyTextField.new(x,y,width,height)
	local self = MyTextField.newObject(x,y,width,height)
	self._text = self.text
	return self
end

function MyTextField:endResponder()
	self.super:endResponder()
	self._save = self.text
	self.text = self._text
end

function MyTextField:confirmText()
	if self._save then
		self.text = math.floor(tonumber(self._save))
	end
end

function MyTextField:mousepressed(...)
	self:becomeResponder()
end
function MyTextField:becomeResponder()
	if self.screen ~= nil then
    self.screen:becomeResponder(self)
  end
  self._text = self.text
end

return MyTextField