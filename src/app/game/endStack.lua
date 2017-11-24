local EndStack=class("EndStack")

function EndStack:ctor()
	self.top=0
	self.list={}
end

--return
--true done
--false err 
function EndStack:push(card)
	if self.top==0 then 
		if card:getSerialNum()==1 then
			self.top=self.top+1;
			self.list[self.top]=card
			card:setContainer(self)
			return true
		else 
			return false
		end
	else
		local current =self.list[self.top]
		if current:getKind()== card:getKind() and (current:getSerialNum()-card:getSerialNum())==-1 then
			self.top=self.top+1;
			self.list[self.top]=card
			card:setContainer(self)
			return true
		else
			return false
		end

	end
end


function EndStack:tryPush(card)
	if self.top==0 then 
		if card:getSerialNum()==1 then
			return true
		else 
			return false
		end
	else
		local current =self.list[self.top]
		if current:getKind()== card:getKind() and (current:getSerialNum()-card:getSerialNum())==-1 then
			return true
		else
			return false
		end
	end
end

function EndStack:pop()
	if self.top==0 then return nil end
	self.top=self.top-1
	return self.list[self.top+1]
end


function EndStack:getFace()
	if self.top==0 then return nil end
	return self.list[self.top]
end


function EndStack:getSecondFace()
	if self.top<2 then return nil end
	return self.list[self.top-1]
end

function EndStack:isFull()
	return top>=14
end




return EndStack