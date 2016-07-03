--load nodebox parts
dofile(minetest.get_modpath("ss13_construction").."/lattice_nodebox.lua")

--allows certain items to be hooked onto the lattice
function ss13_construction.panelLattice(itemstack, placer, pointed_thing)
    --get the lattice position
    local lattice_pos = pointed_thing.under
    
    --limit to replacing lattice nodes only
    local node_name = minetest.get_node(lattice_pos).name
    local valid = minetest.get_node_group(node_name, "ss13_lattice")
    --make sure pointed at node is valid
    if  valid == 0 then
        return itemstack
    end

    --build floor
    if node_name == "ss13_construction:lattice" and 
       itemstack:get_name() == "ss13_construction:floor_tile" then
        --replace lattice at position with the new paneled lattice node
        minetest.set_node(lattice_pos, {name="ss13_construction:floor_ceiling_node"})

    --build wall
    elseif node_name == "ss13_construction:lattice" and
           itemstack:get_name() == "ss13_construction:wall_tile" then
        minetest.set_node(lattice_pos, {name="ss13_construction:wall_node"})

    --TODO: build reinforced wall/floor
    --elseif
    end

    return itemstack:take_item()
end

--when a tiled lattice node gets removed, it should leave behind a bear lattice node
function ss13_construction.onPry(pos, node, digger)
    minetest.set_node(pos, {name="ss13_construction:lattice"})
end

-- lattice items

--structural rods used to make lattice
minetest.register_craftitem("ss13_construction:rods", {
    description = "Metal Rods",
    inventory_image = "ss13_construction_rods.png",
})


--basic plate used for normal floors and walls
minetest.register_craftitem("ss13_construction:floor_tile", {
    description = "Floor Tile",
    inventory_image = "ss13_construction_floor_tile.png",
    on_place = ss13_construction.panelLattice,
})

--basic plate used for normal floors and walls
minetest.register_craftitem("ss13_construction:wall_tile", {
    description = "Floor Tile",
    inventory_image = "ss13_construction_wall.png",
    on_place = ss13_construction.panelLattice,
})


--lattice node definitions

--hull plating
minetest.register_node("ss13_construction:hull_plating", {
    description = "Spacestation Hull Plating",
    tiles = {"ss13_construction_hull_plating.png"},
    is_ground_content = false,
    groups = {snappy=3, airtight=1, ss13_lattice=1},
    drop = "ss13_construction:hull_plating",
})

--A bare lattice
print(dump2(ss13_construction.nodeboxes.lattice_nodebox))
minetest.register_node("ss13_construction:lattice", {
    description = "Spacestation Lattice",
    drawtype = "nodebox",
    tiles = {"ss13_construction_lattice.png"},
    paramtype = "light",
    is_ground_content = false,
    groups = {snappy=3, pryable=1, ss13_lattice=1},
    drop = "ss13_construction:lattice",
    --see lattice_nodebox.lua.
    node_box = ss13_construction.nodeboxes.lattice_nodebox,
    connects_to = { "group:ss13_lattice" },
    selection_box = {
        type  = "fixed",
        fixed = {.35, .35, .35, -.35, -.35, -.35}
    }
})

--Floor/ceiling plates
minetest.register_node("ss13_construction:floor_ceiling_node", {
    description = "Spacestation Plated Lattice",
    drawtype = "nodebox",
    tiles = {"ss13_construction_floor.png", "ss13_construction_roof.png",
                  "ss13_construction_lattice.png"},
    paramtype = "light",
    is_ground_content = false,
    groups = {pryable=1, ss13_lattice=1},
    on_dig = ss13_construction.onPry,
    drop = "ss13_construction:floor_tile",
    node_box = ss13_construction.nodeboxes.floor_ceiling_nodebox,
    connects_to = { "group:ss13_lattice" },
    selection_box = {
        type  = "fixed",
        fixed = {.5, .5, .5, -.5, -.5, -.5}
    }
})

--Wall plates
minetest.register_node("ss13_construction:wall_node", {
    description = "Spacestation Plated Lattice",
    drawtype = "normal",
    tiles = {"ss13_construction_wall.png"},
    paramtype = "light",
    is_ground_content = false,
    groups = {pryable=1, ss13_lattice=1},
    on_dig = ss13_construction.onPry,
    drop = "ss13_construction:wall_tile",
    connects_to = { "group:ss13_lattice" },
})

