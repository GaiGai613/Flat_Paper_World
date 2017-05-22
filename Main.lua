supportedOrientations(LANDSCAPE_ANY)
displayMode(OVERLAY) displayMode(FULLSCREEN)
parameter.watch("fps")
parameter.boolean("move",true)
sprite()

TRYUPDATE = false

function setup()
    if TRYUPDATE then download() end -- Only for vsc develop mode.
    -- math.randomseed(1)
    rectMode(CENTER)
    input_image()
    flat_ui = flat_ui()
    game:init(WIDTH/2,HEIGHT/2)
    font("GillSans-Light")
end

function draw()
    if game.frame_past == 0 then game.camera:reset() end
    flat_ui:draw()
    game:draw()
    fps = 1/DeltaTime
    -- print(world.player.y)
    if not move then
        if CurrentTouch.state == BEGAN or CurrentTouch.state == MOVING then
            local t = CurrentTouch
            local x,y = math.round((game.camera.x+t.x)/game.block_size),math.round((game.camera.y+t.y)/game.block_size)
            world.blocks[y][x] = block(y,x,2)
            -- world.blocks[y][x] = nil
        end
    end
    fill(0, 0, 0, 255)
    fontSize(WIDTH/30)
    text((math.roundTo(world.player.x,2))..","..(math.roundTo(world.player.y,2)),WIDTH/6,HEIGHT*0.80)
end

function touched(t)
    flat_ui:touched(t)
    -- jump height = 50
    -- if move and t.state == BEGAN then world.player:jump(50) end
    -- world.player.movement_controller:auto_jump()
end


-- Useful functions.
function next_var(t,p,m)
    local i = 0
    while not t[p-i] do
        i = i+1
        if i > m then goto next_l end
    end
    l = p-i
    ::next_l::
    local i = 0
    while not t[p+i] do
        i = i+1
        if i > m then goto next_r end
    end
    r = p+i
    ::next_r::
    return l,r
end

function math.randomFloat(min,max,b)
    local b = 10^b
    return math.random(min*b,max*b)/b
end

function calc_table(t,v,type)
    local o = {}
    for i , one_value in pairs(t) do
        if math.type(one_value) == nil then goto next end
        if type == "+" then o[i] = one_value+v
        elseif type == "*" then o[i] = one_value*v
        elseif type == "%" then o[i] = one_value%v
        elseif type == "^" then o[i] = one_value^v end
        ::next::
    end
    return t
end

function game:check_if_block_exist(p)
    if world.blocks then
        if world.blocks[p.y] then
            if world.blocks[p.y][p.x] then
                return world.blocks[p.y][p.x]
            end
        end
    end
    return false
end 

function tp(x,y)
    local p = vec2(x,y)
    world.player.x,world.player.y = p:unpack()
end

function ttb() -- Tp player to one block
    for y = 0 , world.height do
        for x , b in pairs(world.blocks[y]) do
            if b then 
                print("tp player to "..(b.pos.x)..","..(b.pos.y).."\nchunk "..b.chunk_belong)
                tp(b.pos.x,b.pos.y) 
                return
            end
        end
    end
end

function get_near_blocks(p,l)
    local nb = {}
    for x = -l , l do
        for y = -l , l do
            if vec2(x,y):dist(vec2(0,0)) <= l then
                local b = game:check_if_block_exist(p+vec2(x,y))
                if b then
                    table.insert(nb,b)
                end
            end
        end
    end
    return nb
end

function math.roundTo(n,d)
    return math.round(n*(10^d))/(10^d)
end
