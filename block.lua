block = class()

function block:init(y,x,id)
    local self_info = blocks_info[(id or 0)+1]
    self.id = self_info.id
    self.width,self.height = 1,1
    self.x,self.y = x,y
    self.pos_id = x*world.height+y
    self.name = self_info.name
    self.chunk_belong = math.floor((x-1)/world.chunk_size)
    self.info = self_info
    self.visibility = game.max_visibility
    self:special_setup()
    self.aabb = aabb(self)
    self.size = vec2(self.width,self.height)
end

function block:special_setup()
    local cb = self.info.cb
    if cb then
        self.x1,self.y1 = (cb.cb1/2+vec2(self.x,self.y)):unpack()
        self.x2,self.y2 = (cb.cb2/2+vec2(self.x,self.y)):unpack()
        self.width,self.height = self.x2-self.x1,self.y2-self.y1
    end
end

function block:draw(p)
    if self.id == blocks_info[1].id then return end -- No need for air blocks.
    local max_vis = game.max_visibility
    if self.visibility ~= 0 then
        local sc = math.round((255/max_vis)*self.visibility)
        if sc ~= (game.block_tint or -1) then tint(math.round((255/max_vis)*self.visibility)) end
    else
        return
    end
    sprite(sprites["block_"..self.id],p.x,p.y,game.block_size)
end

function block:update()
    local cb = self.info.cb
    if cb then
        self.x1,self.y1 = (cb.cb1/2+vec2(self.x,self.y)):unpack()
        self.x2,self.y2 = (cb.cb2/2+vec2(self.x,self.y)):unpack()
    else
        self.x1,self.y1 = self.x-self.width/2,self.y-self.height/2
        self.x2,self.y2 = self.x+self.width/2,self.y+self.height/2
    end
    self.width,self.height = self.x2-self.x1,self.y2-self.y1
    if self.tree then if self.tree.destory then self:destory() end end
end

function block:change(id)
    local b = blocks_info[id+1]
    self.id = id
    self.name = b.name
    self.info = b
end

function block:destory()
    self = nil
end
