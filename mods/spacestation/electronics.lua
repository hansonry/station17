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

local node_size = 0.5
local function MakeWireBoxes(node_size, wire_percent)
   local boxes = {}
   local unit = node_size * wire_percent
   local u = unit
   local n = node_size
   boxes.center  = { -u, -u, -u,  u,  u,  u }
   boxes.top     = { -u,  u, -u,  u,  n,  u }
   boxes.bottom  = { -u, -n, -u,  u, -u,  u }
   boxes.left    = { -n, -u, -u, -u,  u,  u }
   boxes.right   = {  u, -u, -u,  n,  u,  u }
   boxes.front   = { -u, -u, -n,  u,  u, -u }
   boxes.back    = { -u, -u,  u,  u,  u,  n }
   return boxes
end

local wire_boxes = MakeWireBoxes(node_size, 0.25);

minetest.register_node("spacestation:wirelv", {
	description = "Low Voltage Wire",
   drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			wire_boxes.center, 
         wire_boxes.top, 
         wire_boxes.bottom,
         wire_boxes.left,
         wire_boxes.right,
         wire_boxes.front,
         wire_boxes.back
		},
	},
   paramtype = "light",
   tiles = {"spacestation_uvgrid.png"},
   sunlight_propagates = true,
	groups = {cracky=3},
	sounds = default.node_sound_wood_defaults(),
})
