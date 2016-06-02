local ui = require 'lib.LoveUIView'
local Screen = ui.Screen
local View = ui.View
local MyTextField = require 'src.MyTextField'

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
	self.toolUpperArea:addSubView(b)

	local fileTF = ui.TextField.new(b.x-100,b.y,100,50)
	fileTF.textAlignment = 'center'
	fileTF.text = 'fase'
	self.toolUpperArea:addSubView(fileTF)
	b:addTarget(function(b) dao.saveLevel(self.levelCanvas:exportLevelData(),fileTF.text) end)
	local fileLabel = ui.TextLabel.new(fileTF.x-50,fileTF.y,50,25)
	fileLabel.textAlignment = 'center'
	fileLabel.text = 'Name:'
	self.toolUpperArea:addSubView(fileLabel)

	local s = {w=0,y=50}
	local bImg = love.graphics.newImage('tick.png')
	local tl1 = ui.TextLabel.new(400,0,60,s.y/2)
	tl1.textAlignment = 'center'
	tl1.text = 'Lines:'
	self.toolUpperArea:addSubView(tl1)
	local tf1 = MyTextField.new(tl1:maxX(),tl1.y,50,tl1.height)
	tf1.textAlignment = 'center'
	tf1.text = self.levelCanvas.cell_line
	self.toolUpperArea:addSubView(tf1)
	local bt1 = ui.Button.new(tf1:maxX(),tl1.y,tl1.height,tl1.height)
	bt1.image = bImg
	bt1:addTarget(function(...) tf1:confirmText() self.levelCanvas:changeLines(tonumber(tf1.text)) end)
	self.toolUpperArea:addSubView(bt1)

	local tl2 = ui.TextLabel.new(tl1.x,tl1:maxY(),tl1.width,tl1.height)
	tl2.textAlignment = 'center'
	tl2.text = 'Columns:'
	self.toolUpperArea:addSubView(tl2)
	local tf2 = MyTextField.new(tl2:maxX(),tl2.y,tf1.width,tl2.y)
	tf2.textAlignment = 'center'
	tf2.text = self.levelCanvas.cell_col
	self.toolUpperArea:addSubView(tf2)
	local bt2 = ui.Button.new(tf2:maxX(),tl2.y,tl2.height,tl2.height)
	bt2.image = bImg
	bt2:addTarget(function(...) tf2:confirmText() self.levelCanvas:changeColums(tonumber(tf2.text)) end)
	self.toolUpperArea:addSubView(bt2)

	local tl3 = ui.TextLabel.new(bt1:maxX()+10,tl1.y,70,tl1.height)
	tl3.textAlignment = 'center'
	tl3.text = 'CellWidth:'
	self.toolUpperArea:addSubView(tl3)
	local tf3 = MyTextField.new(tl3:maxX(),tl3.y,50,tl3.height)
	tf3.textAlignment = 'center'
	tf3.text = self.levelCanvas.cell_size.width
	self.toolUpperArea:addSubView(tf3)
	local bt3 = ui.Button.new(tf3:maxX(),tl3.y,tl3.height,tl3.height)
	bt3.image = bImg
	bt3:addTarget(function(...) tf3:confirmText() self.levelCanvas:changeCellWidth(tonumber(tf3.text)) end)
	self.toolUpperArea:addSubView(bt3)

	local tl4 = ui.TextLabel.new(tl3.x,tl3:maxY(),tl3.width,tl3.height)
	tl4.textAlignment = 'center'
	tl4.text = 'CellHeight:'
	self.toolUpperArea:addSubView(tl4)
	local tf4 = MyTextField.new(tl4:maxX(),tl4.y,tf3.width,tl4.y)
	tf4.textAlignment = 'center'
	tf4.text = self.levelCanvas.cell_size.height
	self.toolUpperArea:addSubView(tf4)
	local bt4 = ui.Button.new(tf4:maxX(),tl4.y,tl4.height,tl4.height)
	bt4.image = bImg
	bt4:addTarget(function(...) tf4:confirmText() self.levelCanvas:changeCellHeight(tonumber(tf4.text)) end)
	self.toolUpperArea:addSubView(bt4)

	return self
end

function selectImage(button)
	inst.levelCanvas:selectTile(button.id,button.image)
end

function MainScreen:keypressed(key)
	if not self.levelCanvas.selection and self.toolRightArea.selected then
		self.toolRightArea:cancelSelection()
	end
	self.super:keypressed(key)
end

inst = MainScreen.new()
return inst