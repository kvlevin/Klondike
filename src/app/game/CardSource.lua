local CardSource={}
local num=0
local cap=24
local cards={}
local current=0
local currentFace=nil
function CardSource:put(card)
	
	num=num+1
	cards[current]=card
	card:setContainer(self)
	current=current+1
	if current==cap then
		current=0
	end
end


function CardSource:nextValid()
	while cards[current]==nil do
		print("current_"..current)
		current=current+1
		if current==cap then 
			current=0
		end
	end	
end

function   CardSource:next()
	print("-------next")
	if num==0 then 
		return nil 
	end
	current=current+1
	if current==cap then 
			current=0
		end
	self:nextValid()
	currentFace=current
	print("current_face_"..current)
	local card=cards[currentFace]

	print(card:toString())
	return card
end


function CardSource:isEmpty()
	return num==0
end

function CardSource:getNum()
	return  num
end


function  CardSource:getFace()
	if currentFace== nil then
		return nil
	end
	return cards[currentFace]
end


function CardSource:tryPush(card)
	return false
end

function CardSource:pop()
	num=num-1
	local temp=cards[currentFace]
	cards[currentFace]=nil
	currentFace=nil
	return temp
end

return CardSource






 