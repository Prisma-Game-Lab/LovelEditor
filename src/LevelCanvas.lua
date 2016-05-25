local ui = require 'lib.LoveUIView'
local View = ui.View
local ImgView = require 'src/TileImageView'

local drawGrid,updateSelection,unselect,endSelection
local showGrid, hideGrid, scrollGrid
local checkCornerScroll

local LevelCanvas = ui.extends(View,'LevelCanvas')

local img = nil
local id = nil
local moveTime = 0.8

local color = {
	selected = {255,0,0},
	gridOn = {0,0,0,170},
	gridOff = {0,0,0,0}
}

function LevelCanvas.new(x,y,width,height)
	local self = LevelCanvas.newObject(x,y,width,height)
	self.maxWidth = width
	self.maxHeight = height
	self.gridOn = true
	self.cell_size = 64
	self.cell_line = math.floor(height/self.cell_size)+5
	self.cell_col = math.floor(width/self.cell_size)+5
	self.backgroundColor = {128,128,128,128}
	self.grid = {}
	self.world_size = {width=self.cell_size*self.cell_col,height = self.cell_size*self.cell_line}
	self.contentView = View.new(0,0,self.world_size.width,self.world_size.height)
	for i=0,self.cell_line-1 do
		local lin = {}
		local y = i*self.cell_size
		for j=0,self.cell_col-1 do
			local vw = ImgView.new(j*self.cell_size,y,self.cell_size,self.cell_size)
			lin[j]=vw
			vw.borderColor = {0,0,0,170}
			self.contentView:addSubView(vw)
		end
		self.grid[i]=lin
	end
	self.contentView.borderColor={255,255,255,255}
	self:addSubView(self.contentView)
	self.lastX=0
	self.lastY=0
	self.timer=moveTime
	return self
end

function LevelCanvas:selectTile(id2,img2)
	id = id2
	img = img2
end

function LevelCanvas:draw()
	self:pre_draw()
  	self:during_draw()
  	self:pos_draw()
end

function LevelCanvas:during_draw()
	self.super:during_draw()
	if self.mouse_over then
		local x,y = self.contentView:convertPoint(self.lastX,self.lastY)
		love.graphics.setColor(0,0,0)
		local px,py = self.lastX,self.lastY
		if px+30>self.width then
			px = px-30
		end
		if py-28>0 then
			py = py-28
		else  py=py+4 end
		love.graphics.print(x..'\n'..y,px,py)
	end
	--love.graphics.print(tostring(self.mouse_over), 0,0)
end

function LevelCanvas:clearMouse()
	self.super:clearMouse()
	if self.selection then endSelection(self) end
end

function LevelCanvas:mousepressed(x,y,b)
	self.super:mousepressed(x,y,b)
	x,y = self.contentView:convertPoint(x,y)
	local box = View.new(x,y,0,0)
	box.backgroundColor = {135,206,250,60}
	box.borderColor = {0,0,255}
	self.contentView:addSubView(box)
	self.selection = {ori={x=x,y=y},box=box,selected={}}
	updateSelection(self)
end

function LevelCanvas:mousemoved(x,y,dx,dy)
	self.super:mousemoved(x,y,dx,dy)
	self.lastX = x
	self.lastY = y
	x,y = self.contentView:convertPoint(x,y)

	if self.selection then
		local box = self.selection.box
		local ori = self.selection.ori
		if x>ori.x then
			box.width = x-ori.x
		else
			box.x = x
			box.width = ori.x-x
		end
		if y>ori.y then
			box.height = y-ori.y
		else
			box.y = y
			box.height = ori.y-y
		end
		updateSelection(self)
	end
end

function LevelCanvas:mousereleased(x,y,b)
	self.super:mousereleased(x,y,b)
	x,y = self.contentView:convertPoint(x,y)
	if self.selection then
		--do something
		if img~=nil then
			for _,v in pairs(self.selection.selected) do
				v.image = img
				v.id = id
			end
		end
		endSelection(self)
	end
end

function LevelCanvas:update(dt)
	self.super:update(dt)
	checkCornerScroll(self,dt)
end

function checkCornerScroll(self,dt)
	if self.mouse_over then
		local dx = self.width-self.lastX
		local dy = self.height-self.lastY
		local dist = self.cell_size*dt*4
		if self.width-self.lastX<self.cell_size/2 then
			dx = dist
		elseif self.lastX<self.cell_size/2 then
			dx = -dist
		else dx = 0 end
		if self.height-self.lastY<self.cell_size/2 then
			dy = dist
		elseif self.lastY<self.cell_size/2 then
			dy = -dist
		else dy = 0 end
		if dx~=0 or dy~=0 then
			if self.timer<0 then
				scrollGrid(self,dx,dy)
			else
				self.timer = self.timer-dt
			end
		else
			self.timer = moveTime
		end
	else
		self.timer = moveTime
	end
end

function LevelCanvas:wheelmoved(x,y)
	self.super:wheelmoved(x,y)
	scrollGrid(self,5*x,-5*y)
end

function LevelCanvas:exportLevelData()
	local t = {
		cellSize = self.cell_size,
		worldSize = {
			width = self.contentView.width,
			height = self.contentView.height
		},
		cellsQuant = {
			n_lines = 3,
			n_cols = 4
		},
		layers = {
			{
				name = 'default',
				objects = {

				}
			}
		}
	}
	for _,v in pairs(self.grid) do for _,w in pairs(v) do if w.image~=nil then
		table.insert(t.layers[1].objects,{
			name=w.id,
			position= { x=w.x, y=w.y },
			size= { width=w.width, height=w.height }
		})
	end end end
	return t
end

function LevelCanvas:keypressed(key)
	if key=='escape' then
		if self.selection then
			endSelection(self)
		else
			img = nil
		end
	elseif key=='g' then
		self:toggleGrid()
	--[[TO DO
	elseif key=='right' then
		scrollGrid(self,self.cell_size/2,0)
	elseif key=='left' then
	]]
	end
end

function LevelCanvas:toggleGrid()
	self.gridOn = not self.gridOn
	if self.gridOn then showGrid(self) else hideGrid(self) end
end

function scrollGrid(self,x,y)
	self.contentView.x = math.max(math.min(self.contentView.x-x,0),self.width-self.world_size.width)
	self.contentView.y = math.max(math.min(self.contentView.y-y,0),self.height-self.world_size.height)
end

function hideGrid(self)
	for _,v in pairs(self.grid) do
		for _,w in pairs(v) do
			w.borderColor = {0,0,0,0}
		end
	end
end

function showGrid(self)
	for _,v in pairs(self.grid) do
		for _,w in pairs(v) do
			w.borderColor = {0,0,0,255}
		end
	end
end

function updateSelection(self)
	local b = self.selection.box
	local sel = self.selection.selected
	unselect(self)
	local view
	for i=math.floor(b.x/self.cell_size),math.floor((b.x+b.width)/self.cell_size) do
		for j=math.floor(b.y/self.cell_size),math.floor((b.y+b.height)/self.cell_size) do
			view = self.grid[j][i]
			view.overlayImg = img
			view.borderColor = {255,0,0}
			table.insert(sel,view)
			view:bringToFront()
		end
	end
	self.selection.box:bringToFront()
end

function unselect(self)
	local view
	local sel = self.selection.selected
	for i=#sel,1,-1 do
		view = table.remove(sel,i)
		view.overlayImg = nil
		if self.gridOn then view.borderColor = color.gridOn
		else view.borderColor = color.gridOff end
	end
end

function endSelection(self)
	unselect(self)
	self.selection.box:removeFromSuperView()
	self.selection = nil
end

return LevelCanvas