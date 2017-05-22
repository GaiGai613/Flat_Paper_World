player = class()

function player:init(x,y)
    self.x,self.y = x,y
    self.width,self.height = 1.23,2.9
    self.xb,self.yb = math.round(self.x),math.round(self.y)
    self.gravity = 0
    self.speed = vec2(0,0)
    self.jump_height = {h = 0} 
    
    self.movement_controller = controller_movement(WIDTH/4,HEIGHT/4,WIDTH/2,HEIGHT/2,self)
    self.action_controller = controller_action(WIDTH/4*3,HEIGHT/4,WIDTH/2,HEIGHT/2,self)
    
    self.x1,self.y1 = self.x-0.5,self.y-0.5
    self.aabb = aabb(self)
end

function player:draw()
    sprite(sprites["player"],(self.x+self.width/2-0.5)*game.block_size,(self.y+self.height/2-0.5)*game.block_size,game.block_size*self.width,game.block_size*self.height)
    self.action_controller:draw_with_player()
end

function player:update()
    if self.floating then self:check_floating() end
    self.xb,self.yb = math.round(self.x),math.round(self.y)
    self.aabb:update(self)
    self.movement_controller:update()
    self.action_controller:update()
    
    if self.jump_height.h == 0 then self:free_fall(self.gravity) else
    if self:move(vec2(0,self.jump_height.h*DeltaTime)) then self.jump_height.h = 0 end end
    if self.speed.x ~= 0 or self.speed.y ~= 0 then self:move(self.speed*DeltaTime) end
end

function player:free_fall()
    if self.no_gravity then self.gravity = 0 return end
    local s = 9.8/game.block_size_to_meter
    local max_fall_speed = 15/game.block_size_to_meter
    if self.gravity > max_fall_speed then self.gravity = max_fall_speed
    else self.gravity = self.gravity+s end
    self:move(vec2(0,-self.gravity*DeltaTime))
end

function player:move(move_pos,s,r)
    local nb = {}
    local mp = vec2(move_pos.x,move_pos.y)
    
    if math.type(r) or r == nil then
        local r = r or math.ceil(math.max(math.abs(move_pos.x),math.abs(move_pos.y))+math.ceil(self.height))
        nb = get_near_blocks(vec2(self.xb,self.yb),r)
    else
        nb = r
    end
    
    for i , one_block in pairs(nb) do
        mp.x = one_block.aabb:x_collision(self.aabb,mp.x)
    end
    if not s then self.x = self.x+mp.x self.aabb:update(self) end
    for i , one_block in pairs(nb) do
        mp.y = one_block.aabb:y_collision(self.aabb,mp.y)
    end
    if not s then self.y = self.y+mp.y self.aabb:update(self) end
    
    if mp == move_pos then mp = false end
    return mp
end

function player:jump(f,d)
    -- Check air block.
    if self.floating then return end
    self.floating = true
    self.jump_height.h = f/(d or 0.2)
    tween(d or 0.2,self.jump_height,{h = 0},tween.easing.quadInOut)
end

function player:touched(t)
    
end

function player:setup()
    -- self:move(vec2(0,-100))
    self.chunk_belong = world.chunks[math.floor(self.x/world.chunk_size)]
    table.insert(self.chunk_belong.entities,self)
    self.chunk_belong_id = #self.chunk_belong.entities
end

function player:move_to(dir,d,no_gravity)
    self.speed = self.speed+dir/d
    if no_gravity then self.no_gravity = true end
    tween.delay(d,function ()
        self.speed = self.speed-dir/d
        self.no_gravity = false
    end)
end

function player:check_floating()
    self.floating = self:move(vec2(0,-1),true) == false
    return self.floating    
end
