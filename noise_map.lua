noise_map = class()

function noise_map:init(c)
    self.width = c.width
    self.chunk = c
end

function noise_map:gen_smooth_noise(xs)
    local l = noise_layer
    self.map = {}
    for i = 1 , l do
        
        for x = 0 , self.width-1 do
            self.map[x] = (self.map[x] or 0)+noise((x+xs)*noise_x_scale+noise_seeds[i])/l*noise_y_scale
        end
    end
    self:map_add(world.middle)
end

function noise_map:map_add(v)
    for x = 0 , self.width-1 do
        self.map[x] = self.map[x]+v
    end
end

function noise_map:map_extra_more(ys,is)
    for x = 0 , self.width-1 do
        if self.map[x] >= ys then
            self.map[x] = self.map[x]
        end
    end
end
