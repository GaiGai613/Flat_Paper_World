tree = class()

function tree:init(x,y)
    self.x,self.y = x,y
    self.biome = check_biome_by_block(vec2(self.x,self.y))
    if not self:check_to_generate() then return end
    self:generate()
end

function tree:generate()
    if self.biome == 1 then
        self.height = math.random(20,25) -- Height of the tree. CB
        self.leaf_width,self.leaf_height = math.random(3,5),math.random(3,5)-- Size of the tree.CB
        for y = 0 , self.height do
            local b = block(y+self.y,self.x,5)
            b.tree = self
            world.blocks[y+self.y][self.x] = b
        end
        for x = -self.leaf_width , self.leaf_width do
            for y = -self.leaf_height , self.leaf_height do
                local b = block(y+self.y,self.x,6)
                b.tree = self
                world.blocks[self.height+self.y+y][self.x+x] = b
            end
        end
    end
end

function tree:check_to_generate()
    local cr = 2 -- Check range. CB
    for x = -cr , cr do
        if world.trees[self.x+x] then
            if math.abs(x) == 1 or math.random(1,3) ~= 1 then
                self = nil
                return false
            end
        end
    end
    return true
end
