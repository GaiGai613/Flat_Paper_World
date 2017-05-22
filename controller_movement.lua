controller_movement = class()

function controller_movement:init(x,y,w,h,p)
    self.x,self.y,self.width,self.height = x,y,w,h
    self.player = p
    self.player.walk_speed = 10
    self.walking = 0
end

function controller_movement:update()
    local t = flat_ui:touch_check_rect(self.x,self.y,self.width,self.height,TOUCH)
    if t then
        if t.state == BEGAN or not self.cx then self.cx,self.cy = t.x,t.y end
        if t.x-self.cx > 30 then
            self.walking = 1
        elseif t.x-self.cx < -30 then
            self.walking = -1
        end
    else
        self.walking = 0
        self.cx,self.cy = nil,nil
        return
    end
    local m = flat_ui:touch_check_move()
    if not move then return end
    if m.y >= 10 then self.player:jump(8,0.3) end
    self:walk(self.walking)
    self:auto_jump()
end

function controller_movement:auto_jump()
    if self.player.floating then return end
    local xa = -1
    local jh = 0
    if self.walking > 0 then xa = math.ceil(self.player.width) end
    for y = 0 , 4 do
        if not game:check_if_block_exist(vec2(self.player.xb+xa,self.player.yb+y)) then
            if y == 0 then return end
            goto ajn
        end
        if world.blocks[self.player.yb+y][self.player.xb+xa].size == vec2(0,0) then
            if y == 0 then return end
            goto ajn
        end
        jh = jh+1
    end
    
    ::ajn::
    -- print(jh)
    self.player.floating = true
    local jump_time = 0.1*jh
    self.player:move_to(vec2(self.walking,jh),jump_time,true)
end

function controller_movement:walk(dir)
    self.player:move(vec2(dir*self.player.walk_speed*DeltaTime/game.block_size_to_meter,0))
end

function controller_movement:touched(touch)
    
end