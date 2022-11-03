-- Station Parts

minetest.register_node("spacestation:floor", {
	description = "Space Station Floor",
	tiles = {"spacestation_floor.png"},
	groups = {pryable = 1},
	drop = 'spacestation:floor',
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("spacestation:wall", {
	description = "Space Station Wall",
	tiles = {"spacestation_wall.png"},
	groups = {cracky=3},
	drop = 'spacestation:wall',
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("spacestation:roof", {
	description = "Space Station Roof",
	tiles = {"spacestation_roof.png"},
	groups = {cracky=3},
	drop = 'spacestation:roof',
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("spacestation:light", {
	description = "Light",
	drawtype = "signlike",
	tiles = {"spacestation_light.png"},
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

-- Tools

minetest.register_craftitem("spacestation:crowbar", {
   description = "Crowbar",
   inventory_image = "spacestation_tool_crowbar.png",
   stack_max = 1,
   tool_capabilities = {
      groupcaps = {
         pryable = { maxlevel = 1, times = {[1] = 0} }
      }
   }
})

