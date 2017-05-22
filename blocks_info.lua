blocks_info = {
{id = 0,name = "air",transparent_block = true,
cb = {cb1 = vec2(0,0),cb2 = vec2(0,0)}
},
{id = 1,name = "grass",transparent_block = false
},
{id = 2,name = "dirt",transparent_block = false
},
{id = 3,name = "stone",transparent_block = false
},
{id = 3,name = "stone",transparent_block = false
},
{id = 5,name = "log",transparent_block = false,
cb = {cb1 = vec2(0,0),cb2 = vec2(0,0)},tree_block = true
},
{id = 6,name = "leaf",transparent_block = 4,
cb = {cb1 = vec2(0,0),cb2 = vec2(0,0)},tree_block = true
},
}
sprite("Project:block_tiles")
for i , one_block in pairs(blocks_info) do
    one_block.sec_id = 0
end
