local ui = require 'lib.LoveUIView'
local Screen = ui.Screen
local View = ui.View

local MainScreen = ui.extends(Screen,'MainScreen')

local selectImage
local inst

function MainScreen.new()
	local self = MainScreen.newObject()

	self.levelCanvas = (require 'src/LevelCanvas').new(0,50,1100,570)
	self.view:addSubView(self.levelCanvas)
	--self.levelCanvas.delegate = self

	self.toolUpperArea = View.new(0,0,1100,50)
	self.toolUpperArea.backgroundColor = {255,0,0}
	self.view:addSubView(self.toolUpperArea)

	self.toolRightArea = (require 'src/ObjectCollection').new(4,2,1100,0,self.view.width-1100,self.view.height)
	self.toolRightArea.backgroundColor = {0,255,0}
	self.view:addSubView(self.toolRightArea)

	local py = self.levelCanvas.y+self.levelCanvas.height
	self.toolBottomArea = View.new(0,py,self.toolRightArea.x,self.view.height-py)
	self.toolBottomArea.backgroundColor = {0,0,255}
	self.view:addSubView(self.toolBottomArea)

	local dao = require 'src/DAO'
	local imgs = dao.getData()
	self.toolRightArea:prepareButtons(imgs,selectImage)

	local b = ui.Button.new(1100-50,0,50,50)
	b.image = love.graphics.newImage('save-icon.png')
	b:addTarget(function(b) dao.saveLevel(self.levelCanvas:exportLevelData()) end)
	self.toolUpperArea:addSubView(b)

	return self
end

function selectImage(button)
	inst.levelCanvas:selectTile(button.id,button.image)
end

function MainScreen:mousepressed(x,y,b)
	self.super:mousepressed(x,y,b)
end

function MainScreen:mousemoved(x,y,dx,dy)
	self.super:mousemoved(x,y,dx,dy)
end

function MainScreen:mousereleased(...)
	self.super:mousereleased(...)
end

function MainScreen:keypressed(key)
	if not self.levelCanvas.selection and self.toolRightArea.selected then
		self.toolRightArea:cancelSelection()
	end
	self.super:keypressed(key)
end

inst = MainScreen.new()
return inst