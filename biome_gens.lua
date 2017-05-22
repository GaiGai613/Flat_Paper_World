function plain_gen(c)
    local bm = c.noise_map.map
    for x = c.start_x, c.end_x do
        local y = math.round(bm[x-c.start_x]*world.height)
        local yn = noise(x*noise_x_scale+noise_seeds[1])+1
        world.blocks[y][x] = block(y,x,1) -- Grass
        if math.random(1,4) == 1 then -- Tree, CB
            if not world.trees[x] then world.trees[x] = {} end
            table.insert(world.trees[x],tree(x,y+1))
        end
        for ya = 0 , y do
            world.blocks[y-ya][x] = block(y-ya,x,3) -- Stone
        end
        for ya = 0 , yn*20 do -- Dirt block height. CB
            world.blocks[y-ya][x] = block(y-ya,x,2)
        end
        for ya = 0 , yn*5 do -- Grass block height. CB
            world.blocks[y-ya][x] = block(y-ya,x,1)
        end
    end
    
end
