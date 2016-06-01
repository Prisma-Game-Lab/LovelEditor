local ui = require 'lib.LoveUIView'
local Screen = ui.Screen
local View = ui.View

local MainScreen = ui.extends(Screen,'MainScreen')

local selectImage
local inst
local highlight

function MainScreen.new()
	local self = MainScreen.newObject()

	self.levelCanvas = (require 'src/LevelCanvas').new(0,50,1100,570)
	self.view:addSubView(self.levelCanvas)
	--self.levelCanvas.delegate = self

	self.toolUpperArea = View.new(0,0,1100,50)
	--self.toolUpperArea.backgroundColor = {255,0,0}
	self.view:addSubView(self.toolUpperArea)

	self.toolRightArea = (require 'src/ObjectCollection').new(4,2,1100,0,self.view.width-1100,self.view.height)
	--self.toolRightArea.backgroundColor = {0,255,0}
	self.view:addSubView(self.toolRightArea)

	local py = self.levelCanvas.y+self.levelCanvas.height
	self.toolBottomArea = View.new(0,py,self.toolRightArea.x,self.view.height-py)
	--self.toolBottomArea.backgroundColor = {0,0,255}
	self.view:addSubView(self.toolBottomArea)

	local dao = require 'src/DAO'
	local imgs = dao.getData()
	self.toolRightArea:prepareButtons(imgs,selectImage)

	local b = ui.Button.new(1100-50,0,50,50)
	b.image = love.graphics.newImage('save-icon.png')
	b:addTarget(function(b) dao.saveLevel(self.levelCanvas:exportLevelData()) end)
	self.toolUpperArea:addSubView(b)

	local bImg = love.graphics.newImage('tick.png')
	local tl1 = ui.TextLabel.new(0,0,60,25)
	tl1.textAlignment = 'center'
	tl1.text = 'Lines:'
	self.toolUpperArea:addSubView(tl1)
	local tf1 = ui.TextField.new(60,0,50,25)
	tf1.textAlignment = 'center'
	self.toolUpperArea:addSubView(tf1)
	local bt1 = ui.Button.new(110,0,25,25)
	bt1.image = bImg
	self.toolUpperArea:addSubView(bt1)

	local tl2 = ui.TextLabel.new(0,25,60,25)
	tl2.textAlignment = 'center'
	tl2.text = 'Columns: asasas'
	self.toolUpperArea:addSubView(tl2)
	local tf2 = ui.TextField.new(60,25,50,25)
	tf2.textAlignment = 'center'
	self.toolUpperArea:addSubView(tf2)
	local bt2 = ui.Button.new(110,25,25,25)
	bt2.image = bImg
	self.toolUpperArea:addSubView(bt2)

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