chunk = class()

function chunk:init(x,b)
    self.start_x,self.end_x = x,x+world.chunk_size-1
    self.width = world.chunk_size
    self.id = x/world.chunk_size
    self.entities = {}
    self:set(b)
    
    self.noise_map = noise_map(self)
    self.noise_map:gen_smooth_noise(self.start_x)
end

function chunk:set()
    if b then self.biome_info = biome_info[b] return end
    local lc,rc = world.chunks[self.id-1],world.chunks[self.id+1]
    local nc = lc or rc
    if nc then
        if math.random(1,nc.biome_info.change_biome) ~= 1 then
            self.biome_info = biome_info[nc.biome_info.id]
            return
        end
    end
    self.biome_info = biome_info[math.random(1,#biome_info)]
end

function chunk:update()
    for i , one_entity in pairs(self.entities) do
        one_entity:update()
        if math.floor(one_entity.x/world.chunk_size) ~= self.id then
            one_entity.chunk_belong = world.chunks[math.floor(one_entity.x/world.chunk_size)]
            table.insert(one_entity.chunk_belong.entities,one_entity)
            table.remove(self.entities,one_entity.chunk_belong_id)
            one_entity.chunk_belong_id = #one_entity.chunk_belong.entities
        end
    end
end

function chunk:create_terrain()
    self.biome_info.func(self)
end
