local ui = require 'lib.LoveUIView'
local Button = ui.Button
local View = ui.View
local ObjectCollection = ui.extends(View,"ObjectCollection")

local unselect, select

function ObjectCollection.new(nRow,nCol,x,y,width,height)
  local self = ObjectCollection.newObject(x,y,width,height)
  self.nRow = nRow
  self.nCol = nCol
  self.q = nRow*nCol
  self.borderColor = {0,0,0,0}
  return self
end

function ObjectCollection:prepareButtons(images,target)
  self.pages = {{}}
  local lastPage = self.pages[#self.pages]
  local q
  local ew = self.width/self.nCol
  local eh = ew
  --local eh = self.height/self.nRow
  for i,v in pairs(images) do
    q = #lastPage
    if q>=self.q then
      lastPage = {}
      table.insert(self.pages,lastPage)
      q=0
    end
    --print(q, self.nRow, self.nCol)
    local b = Button.new(5+(q%self.nCol)*ew,5+math.floor((q+self.q*(#self.pages-1))/self.nCol)*eh,ew-10,eh-10)
    b.image = v
    b.id = i
    b.borderColor = {150,150,150}
    b.borderWidth = 2
    b:addTarget(function (button)
      if self.selected then
        local s = self.selected
        unselect(self)
        if s~=button then
          select(self,button)
        end
      else
        select(self,button)
      end
      target(button)
    end)
    table.insert(lastPage,b)
  end
  self.content = {width = ew*self.nCol, height = eh*((#self.pages-1)*self.nRow+math.floor(#lastPage/self.nCol))}
  self.point = 0
  self.contentView = View.new(0,0,self.content.width,self.content.height)
  self.contentView.borderColor = {0,0,255}
  self:addSubView(self.contentView)
  --
  for i,v in ipairs(self.pages) do
    for j,w in ipairs(v) do
      self.contentView:addSubView(w)
    end
  end
end

function ObjectCollection:cancelSelection()
  unselect(self)
end

function unselect(self)
  self.selected.borderColor = {150,150,150}
  self.selected = nil
end

function select(self,but)
  self.selected = but
  self.selected:bringToFront()
  self.selected.borderColor = {255,0,0}
end

function ObjectCollection:target(button)
  
end

function ObjectCollection:mousemoved(x,y,dx,dy)
  --self.super:mousemoved(x-self.x,y-self.y,dx,dy)
  self.super:mousemoved(x,y,dx,dy)
  --if self:containsPoint(x,y) then
    if love.mouse.isDown(1) then
      self:scroll(1.5*dy)
    end
  --end
end

function ObjectCollection:wheelmoved(dx,dy,x,y)
  if self:containsPoint(x,y) then
    self:scroll(10*dy)
  end
end

function ObjectCollection:scroll(v)
  self.point = math.min(math.max(self.point+v,self.height-self.content.height),0)
  self.contentView.y = self.point
end

return ObjectCollection