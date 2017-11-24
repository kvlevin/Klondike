local Card=class("Card")


local cardWidth=3200/13
local  cardHeight = 1914/5
local fact=0.4

function Card:ctor(...)
	print('---------')
	local cls,num=...
	print(num)
	-- if type(...)=="table" then 
	-- 	for k,v in pairs(...) do 
	-- 		print(k..type(v))
	-- 	end
	-- 	return 
	-- end
	self.num=num
	self.kind=math.floor(num/13)
	self.serialNum=num%13+1
	print(self:toString())
end


function  Card:setContainer(container)
	self.container=container
end

function Card:getContainer()
	return self.container
end

function Card:popFromContainer()
	self.container:pop()
end 

function Card:pushNextElement(card)
	return self.container:push(card)
end

function Card:tryPushNextElement(card)
	return self.container:tryPush(card)
end

function Card:getSerialNum()
	return self.serialNum 
end

function Card:getKind()
	return self.kind 
end


function Card:isRed()
	if self.kind==1 or self.kind ==2 then 
		return true
	else
		return false
	end

end
function Card:toString()
	return "kind:"..tostring(self.kind).."_serail:"..tostring(self.serialNum)
end

function Card:isBlack()
	return not self:isRed()
end


function Card.getBackSprite()
	local frameCrop=cc.SpriteFrame:create("anglo.png",cc.rect(       
			(2)*cardWidth,
			(4)*cardHeight ,
			cardWidth,
			cardHeight
			)--rect
		) --create
	return cc.Sprite:createWithSpriteFrame(frameCrop):setScale(fact)
end
function Card.getEmptySprite()
	return cc.Sprite:create("squre.png"):setScale(fact*cardWidth/240)
end


function Card:createSprite()
	--if self.sprite==nil then
		local frameCrop=cc.SpriteFrame:create("anglo.png",cc.rect(       
			(self.serialNum-1)*cardWidth,
			(self.kind)*cardHeight ,
			cardWidth,
			cardHeight
			)--rect
			) --create
		self.sprite=cc.Sprite:createWithSpriteFrame(frameCrop):setScale(fact)
	--end
	print(self:toString())
	return  self.sprite
end


function Card:getSprite()
	return self.sprite
end
--[[
    -- add crop
    local frameCrop = cc.SpriteFrame:create("crop.png", cc.rect(0, 0, 105, 95))
    for i = 0, 3 do
        for j = 0, 1 do
            local spriteCrop = cc.Sprite:createWithSpriteFrame(frameCrop);
            spriteCrop:setPosition(210 + j * 180 - i % 2 * 90, 40 + i * 95 / 2)
            layerFarm:addChild(spriteCrop)
        end
    end

]]

function Card.getFact()
	return fact*cardWidth/240
end

return Card