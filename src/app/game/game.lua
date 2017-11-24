local Game=class("Game")

local Card=require "app.game.card"
local CardSource=require "app.game.CardSource"
local EndStack=require "app.game.endStack"
local PlayStack=require "app.game.playStack"
local spaceHeight=display.height/3.5

local fact=Card.getFact()

local endStack={EndStack:new(),EndStack:new(),EndStack:new(),EndStack:new()}

local gameLayer

local  playStacks={}

local initList={}
local run=false

function Game:ctor()
	for i=0,53 do
	initList[i]=true
	end

	 math.randomseed(os.time())
	local function next()
		local i=math.floor(math.random()*52)
		for inc=0,51 do
			local t=(i+inc)%52
			--print("t------"..t)
			if  initList[t] then 
				initList[t]=false
				return t
			end
		end
	end
	for i=0,23 do
		CardSource:put(Card:new(next()))
	end

	for i=1,7 do
		playStacks[i]=PlayStack:new()
		for j=1,i do
			playStacks[i]:put(Card:new(next()))
		end 
	end
end

function Game:restart()
	endStack={EndStack:new(),EndStack:new(),EndStack:new(),EndStack:new()}
	self:ctor()
	self:draw()
end

function Game:start()
	run=true
end

function Game:pause()
	run=false
end


function Game:getSourceNum()
	return CardSource:getNum()
end
--bool
function Game:ShowSourceSatck()
	return CardSource:getNum()<1 or CardSource:getNum()==1 and CardSource:getFace() end
function Game:GetSourceFace()
	return  CardSource:getFace()
end



function Game:initGraphic()
	gameLayer=cc.Layer:create()

 local touched=false
    local function selectSprite(x,y)
	local spaceHeight=display.height/3.5
	local spaceWidth=spaceHeight* 240 /374
	local firstRow = display.height-spaceHeight*0.5
	local firstLine= display.cx-spaceWidth*3
	local secondRow = display.height-spaceHeight*1.8

	local nx=math.floor((x+spaceWidth*0.5-firstLine)/spaceWidth)
	local ny=-math.floor((y+spaceHeight*0.5-firstRow)/spaceHeight)


	print(string.format("selected x_%d,y_%d",nx ,ny))

	if nx==0 and ny==0 then 
		return 2
	end
	if ny ==0 then

		if  nx ==1 then --cardsource face
			return CardSource:getFace()
		elseif  nx>2 and nx<7 then
			return endStack[nx-2]:getFace()
		else  
			return  nil
		end
	else
		if  nx<7 and nx >-1 then 

			local stack =playStacks[nx+1]
			local lowest=secondRow-(stack:getNum()-1)*spaceHeight/7-spaceHeight*0.415
			if   y-lowest<0   then 
				return nil
			elseif  y-lowest <spaceHeight*0.83 then

				return stack:getFace()
			elseif  y-lowest< spaceHeight*0.83 +(stack:getNum()-1)*spaceHeight/7 then
				if stack:getShowNum() <2 then return stack:getFace()end
				local card={}
				local rd=math.floor((y-lowest-spaceHeight*0.7)/(spaceHeight/7))+1
				 card.hasList=stack:getTops(rd)
				 return card
			else
				return nil
			end
		else	
			return nil
		end

	end


	--print("distance to firstRow"..((y-firstRow)/spaceHeight))--
	--print("distance to firsLine"..((x-firstLine)/spaceHeight))
end


local function pickDistance(x,y)
	local spaceHeight=display.height/3.5
	local spaceWidth=spaceHeight* 240 /374
	local firstRow = display.height-spaceHeight*0.5
	local firstLine= display.cx-spaceWidth*3
	local secondRow = display.height-spaceHeight*1.8

	local nx=math.floor((x+spaceWidth*0.5-firstLine)/spaceWidth)
	local ny=-math.floor((y+spaceHeight*0.5-firstRow)/spaceHeight)
	if ny ==0 then

		
		if  nx>2 and nx<7 then
			return endStack[nx-2]
		else  
			return  nil
		end
	else
		if  nx<7 and nx >-1 then 
			local stack =playStacks[nx+1]
			if  (math.abs(y-(secondRow-(stack:getNum()-1)*spaceHeight/7))%spaceHeight )/spaceHeight <0.3  then 
				return stack
			else
				return nil
			end
		else	
			return nil
		end
	end
end



local selectedCard=nil 

   local function onTouchBegan(touch, event)
   	if not run then return false end
        local location = touch:getLocation()
        	--print(string.format("onTouchBegan: %0.2f, %0.2f", location.x, location.y))
        	local r=selectSprite(location.x,location.y)
        	if r==2 then
        		touched=true
        	end
        	if r~=nil then
        		selectedCard=r
        	end
        return true
end
    local function doList(list,fun)
    	for k,v in pairs(list) do
    		fun(v)
    	end 
    end


local scaled=false
    local function onTouchMoved(touch, event)
        local location = touch:getLocation()
        --selectSprite()
        if selectedCard~=nil and selectedCard~=2 then 
        	local tmp
        	if selectedCard.hasList then 
        		local inc=0
        		for k,v in pairs(selectedCard.hasList) do
        			v:getSprite():move(location.x,location.y-inc):setLocalZOrder(100)
        			inc=inc+spaceHeight/7
        		end
        		tmp=selectedCard.hasList[1]
        	else
        		selectedCard:getSprite():move(location.x,location.y):setLocalZOrder(100)
        		tmp=selectedCard
        	end

	local distance=pickDistance(location.x,location.y)
        	local able=distance and distance:tryPush(tmp)
        	 if  able and not scaled then 

        	 		scaled=true
        	 		if selectedCard.hasList then 
        	 			doList(selectedCard.hasList,function (v)
        	 				v:getSprite():setScale(fact*1.2)
        	 				end)
	        	 	else
	        	 		selectedCard:getSprite():setScale(fact*1.2)
	        	 	end
        	 		print("scale")
        	 elseif  not able and scaled then  
        	 		if selectedCard.hasList then 
        	 			doList(selectedCard.hasList,function (v)
        	 				v:getSprite():setScale(fact)
        	 				end)
	        	 	else
	        	 		selectedCard:getSprite():setScale(fact)
	        	 	end
        	 		scaled=false
        	 		print("unscale")
        	 end

        end

        --print(string.format("onTouchMoved: %0.2f, %0.2f", location.x, location.y))
    end



    local function onTouchEnded(touch, event)
        local location = touch:getLocation()
	print(string.format("onTouchEnded: %0.2f, %0.2f", location.x, location.y))
	local r=selectSprite(location.x,location.y)
        	if r==2 and touched==true then
        		CardSource:next()
        	end

        	r=pickDistance(location.x,location.y)
        	if selectedCard~=nil and r~=nil   and selectedCard~=2 then
        		if selectedCard.hasList then
        			if r:tryPush(selectedCard.hasList[1]) then 
        				local lenth=#(selectedCard.hasList)
        				for i=1, lenth do
        					selectedCard.hasList[lenth]:popFromContainer()
        					print("push   ---"..tostring(r:push(selectedCard.hasList[i])))
        				end


        			end
        		else
        			if r:tryPush(selectedCard) then 
        			        	selectedCard:popFromContainer()
        				print("push   ---"..tostring(r:push(selectedCard)))
        			end

        		end
        	end

        		self:draw()
        		touched=false
        		selectedCard=nil
        		scaled=false
    end


    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
	listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )

    gameLayer:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener,gameLayer)
	return  gameLayer
end



function Game:draw()
	gameLayer:removeAllChildren()
	local spaceHeight=display.height/3.5
	local spaceWidth=spaceHeight* 240 /374
	local firstRow = display.height-spaceHeight*0.5
	local firstLine= display.cx-spaceWidth*3
	if CardSource:isEmpty() then
		Card.getEmptySprite()
		:move(firstLine,firstRow)
		:addTo(gameLayer)
		firstLine=firstLine+spaceWidth
	else
		Card.getBackSprite()
		-- :registerScriptTaphandler(function (psend)
		-- 	CardSource:next()
		-- 	self:draw()
		-- 	end)
		:move(firstLine,firstRow)
		:addTo(gameLayer)
		firstLine=firstLine+spaceWidth

	end

	if CardSource:getFace()==nil then 
		firstLine=firstLine+spaceWidth
	else
		CardSource:getFace():createSprite()
		:move(firstLine,firstRow)
		:addTo(gameLayer)
		firstLine=firstLine+spaceWidth
	end

	firstLine=firstLine+spaceWidth
	for i=1,4 do
			Card.getEmptySprite()
			:move(firstLine,firstRow)
			:addTo(gameLayer)
		if endStack[i]:getSecondFace()~=nil then 
			endStack[i]:getSecondFace():createSprite()
			:move(firstLine,firstRow)
			:addTo(gameLayer)
		end
		if endStack[i]:getFace()~=nil then 
			endStack[i]:getFace():createSprite()
			:move(firstLine,firstRow)
			:addTo(gameLayer)

		end
		firstLine=firstLine+spaceWidth
	end

	local firstRow = display.height-spaceHeight*1.8
	local firstLine= display.cx-spaceWidth*3
	for i=1,7 do

		local inc=0
		if playStacks[i]:getVeiledNum()>0 then
			for  k=1,playStacks[i]:getVeiledNum() do
				Card.getBackSprite()
				:move(firstLine,firstRow-inc)
				:addTo(gameLayer)
				inc=inc +spaceHeight/7
			end
		else
			Card.getEmptySprite()
			:move(firstLine,firstRow)
			:addTo(gameLayer)

		end

		local ite=playStacks[i]:getUnveilList()
		local card=ite()
		while card  ~=nil  do
			card:createSprite()
			:move(firstLine,firstRow-inc)
			:addTo(gameLayer)
			inc=inc +spaceHeight/7
			card=ite()
		end
		firstLine=firstLine+spaceWidth
	end
end



local function  ontouchListener(sender,eventType)
 if eventType == ccui.TouchEventType.began then  
        print("touchbegin")  
    elseif eventType == ccui.TouchEventType.moved then  
        print("Touch Move")  
    elseif eventType == ccui.TouchEventType.ended then  
        print("Touch Up")  
    elseif eventType == ccui.TouchEventType.canceled then  
        print("Touch Cancelled")  
    end  
end


return Game