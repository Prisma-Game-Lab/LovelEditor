local ui = require 'lib.LoveUIView'

local TileImageView = ui.extends(ui.View,'TileImgView')

local overlayAlpha = 128
local drawImg

function TileImageView.new(x,y,width,height)
	local self = TileImageView.newObject(x,y,width,height)
  self.shouldFill = true
  return self
end

function TileImageView:draw()
  self:pre_draw()
  self:during_draw()
  self:pos_draw()
end

function TileImageView:during_draw()
  self.super:during_draw()
  drawImg(self,'image',255)
  drawImg(self,'overlayImg',overlayAlpha)
end

function drawImg(self,img,alpha)
	img = self[img]
	if img ~= nil then
		love.graphics.setColor(255,255,255,alpha)
    	local w,h = img:getDimensions()
    	local sx,sy = self.width/w,self.height/h
    	if not self.shouldFill then
        if sx>sy then sx = sy else sy = sx end
      end
    	love.graphics.draw(img,(self.width-sx*w)/2,(self.height-sy*h)/2,0,sx,sy)
    end
 end

return TileImageView