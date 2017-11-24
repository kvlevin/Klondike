local PlayStack=class("PlayStack")
 function PlayStack:ctor()
 	self.list={}
 	self.top=0
 	self.unVeiled=-1
  end

function PlayStack:put(card)
	self.top=self.top+1
	self.list[self.top]=card
	card:setContainer(self)
	self.unVeiled=self.unVeiled+1
end

function PlayStack:getUnveilList()
	local i=self.unVeiled
	-- print("play_stack-"..i)
	-- print(type(self.list[i+1]))
	return function ()
		i=i+1
		if i>self.top then 
			return nil 
		end
	--	print(self.list[i]:toString())
		return self.list[i]
	end
end


function PlayStack:getTops(count)
	local i=self.top -count
	-- print("play_stack-"..i)
	-- print(type(self.list[i+1]))
	local list={}
	local j=0
	while  i<=self.top do
		i=i+1
		j=j+1
		list[j]=self.list[i]
	end
	return  list
end

function  PlayStack:getNum()
	return self.top
end


function PlayStack:getShowNum()
	return self.top-self.unVeiled
end

function PlayStack:getVeiledNum()
	if self.unVeiled<0 then return 0 else return self.unVeiled end
end

function PlayStack:pop()
	if self.top>0 then 
		self.top=self.top-1
		if not (self.top>self.unVeiled) then 
			self.unVeiled=self.top-1
		end
		return self.list[self.top+1]
	else
		return nil
	end
end

function PlayStack:getFace()
	if self.top>0 then 
		return self.list[self.top]
	else
		return nil
	end
end

function PlayStack:push(card)
	if self.top==0 then 
		if card:getSerialNum()==13 then
			self.unVeiled=0
			self.top=1
			self.list[self.top]=card
			card:setContainer(self)
			print("---------")
			print(card:toString())
			return true
		else
			return false
		end
	else
		local current=self.list[self.top] 
		if current:isRed()==card:isBlack() and current:getSerialNum() -card:getSerialNum()==1 then
			self.top=self.top+1
			self.list[self.top]=card
			card:setContainer(self)
			return true
		else
			return false
		end
	end
end


function PlayStack:tryPush(card)
	if self.top==0 then 
		if card:getSerialNum()==13 then
			return true
		else
			return false
		end
	else
		local current=self.list[self.top] 
		-- print("compare------")
		-- print(current:toString())
		-- print(card:toString())
		if current:isRed()==card:isBlack() and current:getSerialNum() -card:getSerialNum()==1 then
			return true
		else
			return false
		end
	end
end
return PlayStack