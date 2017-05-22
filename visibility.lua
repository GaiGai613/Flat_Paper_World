visibility = class()

function visibility:init()
    game.max_visibility = 8
end

function visibility:update(x1,y1,x2,y2)
    -- if true then return end
    local mv = game.max_visibility
    for x = x1 , x2 do
        for y = y1 , y2 do
            -- If block not exist.
            local b = game:check_if_block_exist(vec2(x,y))
            if not b or b.id == 0 then
                goto vi_up_next
            end

            --Get visiblity of blocks near by.
            local mbv = visibility_round_blocks(vec2(x,y))

            world.blocks[y][x].visibility = mbv
            
            ::vi_up_next::
        end
    end

    for x = x1 , x2 do
        for y = y1 , y2 do
            local x,y = x2-(x-x1),y2-(y-y1)
            -- If block not exist.
            local b = game:check_if_block_exist(vec2(x,y))
            if not b or b.id == 0 then
                goto vi_up_next
            end

            --Get visiblity of blocks near by.
            local mbv = visibility_round_blocks(vec2(x,y))

            world.blocks[y][x].visibility = mbv
            
            ::vi_up_next::
        end
    end
end


function visibility_round_blocks(p)
    local t = {vec2(1,0),vec2(-1,0),vec2(0,1),vec2(0,-1)}
    local mv = game.max_visibility
    local mbv = 0

    for k , one_vec in pairs(t) do
        local pos = one_vec+p
        local b = game:check_if_block_exist(pos)

        if not b or b.id == 0 then return mv-1 end
        
        mbv = math.max(mbv,b.visibility)
    end

    mbv = math.min(0,mbv-1)
    return mbv
end
