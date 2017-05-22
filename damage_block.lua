damage_block = class()

function damage_block:init(b,damage,range)
    self.block = b
    self.damage = damage
    self.range = range
end

function damage_block:update(entity)
    local e = entity
    local b = self.block
    
end
