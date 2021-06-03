
vector = {}
vector.__index = vector;
 
--构造函数
function vector.new()
	local ret = {}
	setmetatable(ret, vector)
	ret.tempVec = {}
	return ret
end
 
function vector:at(index)
	return self.tempVec[index]
end
 
function vector:push_back(val)
	table.insert(self.tempVec,val)
end

function vector:insert(index,val)
	--在index后面插入
	table.insert(self.tempVec,index+1,val)
end

function vector:find(val)
    for i=1,#self.tempVec do
		if self.tempVec[i] == val then
			return i
		end
	end
	return nil
end

function vector:delete(val)
    local index = self:find(val)
    if index ~= nil then
        self:erase(index)
    end
end
 
function vector:erase(index)
	table.remove(self.tempVec,index)
end


function vector:size()
    return #self.tempVec;
end

 
function vector:iter()
	local i = 0
	return function ()
        i = i + 1
        return self.tempVec[i]
    end
end


function vector:print()
	for i=1,#self.tempVec do
		LOG(self.tempVec[i])
	end
end
