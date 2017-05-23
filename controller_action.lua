controller_action = class()

function controller_action:init(x,y,w,h,p)
    self.x,self.y,self.width,self.height = x,y,w,h
    self.player = p
    self.player.reach_range = 7
    self.player.select = 0
end

function controller_action:draw()
    
end

function controller_action:draw_with_player()
    local b = game.block_size
    if self.select_block_x then
        sprite(sprites["block_select"],self.select_block_x*b,self.select_block_y*b,b)
        if self.player.select ~= 0 then
            self:build_block(self.select_block_x,self.select_block_y,self.player.select)
        else
            self:destory_block(self.select_block_x,self.select_block_y)
        end
    end
end

function controller_action:update()
    local t = flat_ui:touch_check_rect(self.x,self.y,self.width,self.height,TOUCH)
    if t then
        if t.state == BEGAN or not self.cx then
            self.cx,self.cy = t.x,t.y 
            self:get_near_blocks()
        end
        local a = vec2(1,0):angleBetween(vec2(t.x,t.y)-vec2(self.cx,self.cy))
        local r = vec2(t.x,t.y):dist(vec2(self.cx,self.cy))/game.block_size*0.8
        if r > self.player.reach_range then r = self.player.reach_range end
        
        self.select_block_x,self.select_block_y = ((vec2(r,0):rotate(a))+vec2(self.player.x,self.player.y)):unpack()
        self.select_block_x = math.round(self.select_block_x)
        self.select_block_y = math.round(self.select_block_y)
    else
        -- self.select_block_x = nil
        self.walking = 0
        self.cx,self.cy = nil,nil
        return
    end
end

function controller_action:get_near_blocks()
    self.near_blocks = get_near_blocks(vec2(self.player.x,self.player.y),self.player.reach_range)
    return self.near_blocks
end

function controller_action:build_block(x,y,id)
    local b = game:check_if_block_exist(vec2(x,y))
    if b then
        if b.id == id then return end
    end
    local mv = game.max_visibility
    world.blocks[y][x] = block(y,x,id)
    visibility:update(x-mv,y-mv,x+mv,y+mv)
end

function controller_action:destory_block(x,y)
    local b = game:check_if_block_exist(vec2(x,y))
    if b then
        if b.id == id then return end
    end
    local mv = game.max_visibility    
    world.blocks[y][x]:destory()
    visibility:update(x-mv,y-mv,x+mv,y+mv)
end

function controller_action:touched(touch)
    
end