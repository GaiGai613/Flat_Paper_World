aabb = class()

function aabb:init(obj)
    if obj.x1 ~= nil then self.betw_x,self.betw_y = obj.x1-obj.x,obj.y1-obj.y end
    self:update(obj)
end

function aabb:x_collision(_aabb,xm)
    if _aabb.x1-_aabb.x2 == 0 or self.x1-self.x2 == 0 then return xm end
    if _aabb.y2 <= self.y1 or _aabb.y1 >= self.y2 then return xm end
    
    if xm > 0 and _aabb.x2 <= self.x1 then
        local m = self.x1 - _aabb.x2
        if m < xm then xm = m end
    end
    if xm < 0 and _aabb.x1 >= self.x2 then
        local m = self.x2 - _aabb.x1
        if m > xm then xm = m end
    end
    
    return xm
end

function aabb:y_collision(_aabb,ym)
    if _aabb.y1-_aabb.y2 == 0 or self.y1-self.y2 == 0 then return ym  end
    if _aabb.x2 <= self.x1 or _aabb.x1 >= self.x2 then return ym end
    
    if ym > 0 and _aabb.y2 <= self.y1 then
        local m = self.y1 - _aabb.y2
        if m < ym then ym = m end
    end
    if ym < 0 and _aabb.y1 >= self.y2 then
        local m = self.y2 - _aabb.y1
        if m > ym then ym = m end
    end
    
    return ym
end

function aabb:update(obj)
    self.obj = obj
    if self.betw_x == nil then
        self.x1,self.y1 = obj.x-obj.width/2,obj.y-obj.height/2
        self.x2,self.y2 = obj.x+obj.width/2,obj.y+obj.height/2
    else
        self.x1,self.y1 = obj.x+self.betw_x,obj.y+self.betw_y
        self.x2,self.y2 = self.x1+obj.width,self.y1+obj.height
    end
end
