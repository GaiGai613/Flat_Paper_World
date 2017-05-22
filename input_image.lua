local image_info = {
{name = "block_1",code = {width = 1,height = 1,colors = {{c = color(60.0,138.0,30.0,255.0),tiles = {vec2(1,1)}}}}},
{name = "block_2",code = {width = 1,height = 1,colors = {{c = color(120.0,80.0,30.0,255.0),tiles = {vec2(1,1)}}}}},
{name = "block_3",code = {width = 1,height = 1,colors = {{c = color(127.0,127.0,127.0,255.0),tiles = {vec2(1,1)}}}}},
{name = "player",code = {width = 16,height = 24,colors = {{c = color(240.0,240.0,240.0,255.0),tiles = {vec2(1,1),vec2(2,1),vec2(3,1),vec2(4,1),vec2(5,1),vec2(6,1),vec2(7,1),vec2(8,1),vec2(9,1),vec2(10,1),vec2(11,1),vec2(12,1),vec2(13,1),vec2(14,1),vec2(15,1),vec2(16,1),vec2(1,2),vec2(16,2),vec2(1,3),vec2(16,3),vec2(1,4),vec2(16,4),vec2(1,5),vec2(16,5),vec2(1,6),vec2(16,6),vec2(1,7),vec2(16,7),vec2(1,8),vec2(16,8),vec2(1,9),vec2(16,9),vec2(1,10),vec2(16,10),vec2(1,11),vec2(16,11),vec2(1,12),vec2(16,12),vec2(1,13),vec2(16,13),vec2(1,14),vec2(16,14),vec2(1,15),vec2(16,15),vec2(1,16),vec2(16,16),vec2(1,17),vec2(16,17),vec2(1,18),vec2(16,18),vec2(1,19),vec2(16,19),vec2(1,20),vec2(16,20),vec2(1,21),vec2(16,21),vec2(1,22),vec2(16,22),vec2(1,23),vec2(16,23),vec2(1,24),vec2(2,24),vec2(3,24),vec2(4,24),vec2(5,24),vec2(6,24),vec2(7,24),vec2(8,24),vec2(9,24),vec2(10,24),vec2(11,24),vec2(12,24),vec2(13,24),vec2(14,24),vec2(15,24),vec2(16,24)}}}}}
}
sprites = {}
for k , one_image in pairs(image_info) do
    local i = one_image
    oi = image(i.code.width,i.code.height)
        
    for l , one_color in pairs(i.code.colors) do
        for m , one_tile in pairs(one_color.tiles) do
            oi:set(one_tile.x,one_tile.y,one_color.c)
        end
    end
    sprites[i.name] = oi
end

function input_image()
    local tw,th = 8,8
    local i = readImage("Project:block_tiles")
    if (i.width/tw)%1 ~= 0 or (i.height/th)%1 ~= 0 then displayMode(OVERLAY) print("Texture Not Support") close() end
    for x = 1 , i.width/tw do
        for y = 1 , 1--[[i.height/th]] do
            local ni = i:copy((x-1)*8+1,(y-1)*8+1,tw,th)
            sprites["block_"..(x+(y-1)*8)] = ni
        end
    end
    
    local ui_info = {
    {name = "block_select",x = 1,y = 1,w = 8,h = 8}
    }
    local i = readImage("Project:ui")
    for k , oi in pairs(ui_info) do
        local ni = i:copy(oi.x,oi.y,oi.w,oi.h)
        sprites[oi.name] = ni
    end
end
