minetest.register_craftitem("spacestation:multitool", {
   description = "Multitool",
   inventory_image = "spacestation_tool_multitool.png",
   stack_max = 1
})

minetest.register_node("spacestation:apc", {
	description = "Area Power Controller (APC)",
   drawtype = "signlike",
   tiles = {"spacestation_apc.png"},
	paramtype = "light",
	paramtype2 = "wallmounted",
   sunlight_propagates = true,
   walkable = false,
	groups = {cracky=3},
	sounds = default.node_sound_metal_defaults(),
   selection_box = {
		type = "wallmounted",
	},
})
