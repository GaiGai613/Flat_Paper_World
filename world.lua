world = class()

function world:init()
    self.blocks = {}
    self.load_chunks = {}
    self.player = player(0,150)
    self.entities = {self.player}
    self.trees = {}
end

function world:setup()
    self.player:setup()
end

function world:draw()
    local game_color = color(176,233,252,255)
    background(game_color)
    pushMatrix()
    translate(-game.camera.x,-game.camera.y)
    local b = game.block_size
    for y = math.floor(game.camera.y/b) , math.ceil(game.camera.y/b+HEIGHT/b) do
        for x = math.floor(game.camera.x/b) , math.ceil(game.camera.x/b+WIDTH/b) do
            if game:check_if_block_exist(vec2(x,y)) then
                world.blocks[y][x]:draw(vec2(x*b,y*b))
            end
        end
    end
    noTint()
    game.block_tint = nil
    
    for i , one_entity in pairs(self.entities) do
        one_entity:draw()
    end
    popMatrix()
end

function world:chunk_manager(m)
    local load_range = 1
    local pc = math.floor(self.player.x/world.chunk_size)
    if not self.load_chunks[0] or self.load_chunks[0].id ~= pc then
        for x = -load_range , load_range do
            -- if not self.chunks[pc+x] then terrain:create_new_chunk(pc+x) end
            self.load_chunks[x] = self.chunks[pc+x]
        end
    end
    return
end

function world:update()
    self:chunk_manager()
    for i , one_chunk in pairs(self.load_chunks) do
        one_chunk:update()
    end
end

function world:touched(touch)
    
end

function check_biome_by_block(p)
    return check_chunk_by_block(p).biome_info.id
end

function check_chunk_by_block(p)
    return world.chunks[math.floor(p.x/world.chunk_size)]
end