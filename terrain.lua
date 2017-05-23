terrain = class()

function terrain:init()
    world.seed = os.time()
    math.randomseed(world.seed)
    print(world.seed)

    chunk_count = 5 -- Total amount = chunk_count*2-1
    chunk_count = chunk_count*2-1
    
    -- Noise varibles.
    noise_layer = 8
    noise_x_scale = 0.03
    noise_y_scale = 0.12
    
    -- World
    world.chunk_size = 32
    world.width,world.height = world.chunk_size*chunk_count,200
    world.chunks = {}
    world.middle = 0.62
    
    terrain:create_noise_seeds(noise_layer)
    terrain:new_world_setup()
end

function terrain:array_setup_y() -- Use only once, at the began of create world.
    for y = 0 , world.height do
        world.blocks[y] = {}
        for x = 0 , world.width do
            world.blocks[y][x] = block(y,x)
        end
    end
end

function terrain:create_new_chunk(id)
    world.chunks[id] = chunk(id*world.chunk_size,1)
    world.chunks[id]:create_terrain()
end

function terrain:new_world_setup()
    self:array_setup_y()
    
    local cc = (chunk_count+1)/2
    for i = -math.ceil(cc/2) , math.floor(cc/2+1) do -- Create every chunk.
        world.chunks[i] = chunk(i*world.chunk_size,1)
    end
    
    for i , one_chunk in pairs(world.chunks) do
        one_chunk:create_terrain()
    end
    
    --Visibility
    local mv = game.max_visibility
    local x1,x2 = (-cc+1)*world.chunk_size+mv,cc*world.chunk_size-1-mv
    local y1,y2 = 0,world.height
    if x1 < x2 then
        visibility:update(x1,y1,x2,y2)
    end


end

function terrain:create_noise_seeds(l)
    noise_seeds = {}
    for i = 1 , l do
        noise_seeds[i] = math.random(0,10000)
    end
end
