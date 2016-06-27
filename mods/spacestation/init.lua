-- spacestation (Minetest 0.4 mod)
-- Space Station parts

-- Register nodes

minetest.register_node("spacestation:light", {
	description = "Light",
	drawtype = "signlike",
	tiles ={"spacestation_light.png"},
	inventory_image = "spacestation_light.png",
	wield_image = "spacestation_light.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	is_ground_content = false,
	walkable = false,
	light_source = LIGHT_MAX-1,
	selection_box = {
		type = "wallmounted",
		--wall_top = {-0.1, 0.5-0.6, -0.1, 0.1, 0.5, 0.1},
		--wall_bottom = {-0.1, -0.5, -0.1, 0.1, -0.5+0.6, 0.1},
		--wall_side = {-0.5, -0.3, -0.1, -0.5+0.3, 0.3, 0.1},
	},
	groups = {choppy=2,dig_immediate=3,attached_node=1},
	--legacy_wallmounted = true,
	sounds = default.node_sound_defaults(),
})

function doortoggle(pos, node, clicker)
   local newname
   if node.name == "spacestation:door_open" then
      newname = "spacestation:door"
   else
      newname = "spacestation:door_open"
   end
   minetest.swap_node(pos, { 
      name = newname, 
      param1 = node.param1, 
      param2 = node.param2
      })
   -- param2 should be facing dir
   -- 0 = z; 1 = x; 2 = -z; 3 = -x
   if node.param2 == 0 then
      local newpos = { x = pos.x - 1, y = pos.y, z = pos.z }
      local checknode = minetest.get_node(newpos)
      if (checknode.name == "spacestation:door" or 
          checknode.name == "spacestation:door_open") and
         checknode.param2 == 2 then
         minetest.swap_node(newpos, { 
            name = newname, 
            param1 = checknode.param1, 
            param2 = checknode.param2
            })
      end
   elseif node.param2 == 1 then
      local newpos = { x = pos.x, y = pos.y, z = pos.z + 1 }
      local checknode = minetest.get_node(newpos)
      if (checknode.name == "spacestation:door" or 
          checknode.name == "spacestation:door_open") and
         checknode.param2 == 3 then
         minetest.swap_node(newpos, { 
            name = newname, 
            param1 = checknode.param1, 
            param2 = checknode.param2
            })
      end
   elseif node.param2 == 2 then
      local newpos = { x = pos.x + 1, y = pos.y, z = pos.z }
      local checknode = minetest.get_node(newpos)
      if (checknode.name == "spacestation:door" or 
          checknode.name == "spacestation:door_open") and
         checknode.param2 == 0 then
         minetest.swap_node(newpos, { 
            name = newname, 
            param1 = checknode.param1, 
            param2 = checknode.param2
            })
      end
   elseif node.param2 == 3 then
      local newpos = { x = pos.x, y = pos.y, z = pos.z - 1 }
      local checknode = minetest.get_node(newpos)
      if (checknode.name == "spacestation:door" or 
          checknode.name == "spacestation:door_open") and
         checknode.param2 == 1 then
         minetest.swap_node(newpos, { 
            name = newname, 
            param1 = checknode.param1, 
            param2 = checknode.param2
            })
      end
   end



end


minetest.register_node("spacestation:door", {
	description = "Space Station Interal Door",
	tiles = {{ name = "spacestation_door.png", backface_culling = true }},
	--inventory_image = "spacestation_door.png",	
	groups = {cracky=3},
	drop = 'spacestation:door',
	drawtype = "mesh",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	use_texture_alpha = true,
	walkable = true,
	is_ground_content = false,
	buildable_to = false,
	selection_box = { type = "fixed", fixed = { -1/2,-1/2,-1/16,1/2,3/2,1/16} },
	collision_box = { type = "fixed", fixed = { -1/2,-1/2,-1/16,1/2,3/2,1/16} },
	mesh = "door_c.obj",
	sounds = default.node_sound_stone_defaults(),
   on_rightclick = doortoggle,
})

minetest.register_node("spacestation:door_open", {
	description = "Space Station Interal Door",
	tiles = {{ name = "spacestation_door.png", backface_culling = true }},
	--inventory_image = "spacestation_door.png",	
	groups = {cracky=3},
	drop = 'spacestation:door',
	drawtype = "mesh",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	use_texture_alpha = true,
	walkable = false,
	is_ground_content = false,
	buildable_to = false,
	selection_box = { type = "fixed", fixed = { -1/2,-1/2,-1/16,1/2,3/2,1/16} },
	--collision_box = { type = "fixed", fixed = { -1/2,-1/2,-1/16,1/2,3/2,1/16} },
	mesh = "door_c_open.obj",
	sounds = default.node_sound_stone_defaults(),
   on_rightclick = doortoggle,
})

minetest.register_node("spacestation:locker", {
	description = "Space Station Locker",
	tiles = { 
      "spacestation_locker_top.png",  
      "spacestation_locker_top.png",  
      "spacestation_locker_side.png",  
      "spacestation_locker_side.png",  
      "spacestation_locker_top.png",  
      "spacestation_locker_front.png",  
      },
	paramtype2 = "facedir",
	groups = {cracky=3},
	drop = 'spacestation:locker',
	sounds = default.node_sound_stone_defaults(),
   on_construct = function(pos)
      local meta = minetest.get_meta(pos)
      meta:set_string("formspec",
         "size[8,9]"..
         "list[current_name;main;0,0;4,1;]"..
         "list[current_player;main;0,5;8,4;]"..
         "listring[]")
      meta:set_string("infotext", "Locker")
      local inv = meta:get_inventory()
      inv:set_size("main", 4 * 1)
   end,
   can_dig = function(pos, player)
      local meta = minetest.get_meta(pos)
      local inv = meta:get_inventory()
      return inv:is_empty("main")
   end,
})

minetest.register_craftitem("spacestation:idcard", {
   description = "ID",
   inventory_image = "spacestation_idcard.png",
})


