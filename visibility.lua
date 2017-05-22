visibility = class()

function visibility:init()
    game.max_visibility = 8
end

function visibility:update(x1,y1,x2,y2)
    -- if true then return end
    displayMode(OVERLAY)
    for x = x1 , x2 do
        -- print(x)
        for y = y1 , y2 do
            -- If block not exist.
            local b = game:check_if_block_exist(vec2(x,y))
            if not b then
                goto vi_up_next
            end
            if b.id == 0 then
                goto vi_up_next
            end

            -- Get nearest air block.
            local dist_to_air = visibility_round_blocks(vec2(x,y),game.max_visibility) or game.max_visibility
            
            world.blocks[y][x].visibility = game.max_visibility-dist_to_air
            
            ::vi_up_next::
        end
    end
end


function visibility_round_blocks(p,r)
    local t = {}
    local d = math.huge
    for x = -r+p.x , r+p.x do
        for y = -r+p.y , r+p.y do
            local b = game:check_if_block_exist(vec2(x,y))
            if b then
                if b.id == 0 then
                    local dc = p-vec2(x,y)
                    dc.x,dc.y = math.abs(dc.x),math.abs(dc.y)
                    d = math.min(math.max(dc.x,dc.y),d)
                end
            end
        end
    end
    
    if d == math.huge then d = nil end
    return d
end
