game = class()

game = game()

function game:init(x,y)
    self.current_scene = "in game"
    self.x,self.y = x,y
    self.block_size = math.round(WIDTH/64)
    self.frame_past = 0
    
    visibility = visibility()
    world = world()
    terrain = terrain()
    self.camera = _camera()
    self.block_size_to_meter = 0.62
    world:setup()
end

function game:draw()
    if self.current_scene == "in game" then
        world:update()
        self.camera:draw()
        world:draw()
    end
    self.frame_past = self.frame_past+1 
end

function game:touched(t)
    
end

function game:check_if_entity_on_block(x,y)
    for i , one_entity in pairs(world.entities) do
        local cab = aabb(block(y,x,1))
        cab.x_collision(one_entity.aabb,0)
    end
end

