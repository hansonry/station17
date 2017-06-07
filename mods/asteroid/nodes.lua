-- Nodes

minetest.register_node("asteroid:stone", {
	description = "Asteroid Stone",
	tiles = {"asteroid_stone.png"},
	is_ground_content = false,
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("asteroid:cobble", {
	description = "Asteroid Cobble",
	tiles = {"asteroid_cobble.png"},
	is_ground_content = false,
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("asteroid:gravel", {
	description = "Asteroid gravel",
	tiles = {"asteroid_gravel.png"},
	is_ground_content = false,
	groups = {crumbly = 2},
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_gravel_footstep", gain = 0.2},
	}),
})

minetest.register_node("asteroid:dust", {
	description = "Asteroid Dust",
	tiles = {"asteroid_dust.png"},
	is_ground_content = false,
	groups = {crumbly = 3},
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_gravel_footstep", gain = 0.1},
	}),
})

minetest.register_node("asteroid:ironore", {
	description = "Asteroid Iron Ore",
	tiles = {"asteroid_stone.png^default_mineral_iron.png"},
	is_ground_content = false,
	groups = {cracky = 2},
	drop = "default:iron_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("asteroid:copperore", {
	description = "Asteroid Copper Ore",
	tiles = {"asteroid_stone.png^default_mineral_copper.png"},
	is_ground_content = false,
	groups = {cracky = 2},
	drop = "default:copper_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("asteroid:goldore", {
	description = "Asteroid Gold Ore",
	tiles = {"asteroid_stone.png^default_mineral_gold.png"},
	is_ground_content = false,
	groups = {cracky = 2},
	drop = "default:gold_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("asteroid:diamondore", {
	description = "Asteroid Diamond Ore",
	tiles = {"asteroid_stone.png^default_mineral_diamond.png"},
	is_ground_content = false,
	groups = {cracky = 1},
	drop = "default:diamond",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("asteroid:meseore", {
	description = "Asteroid Mese Ore",
	tiles = {"asteroid_stone.png^default_mineral_mese.png"},
	is_ground_content = false,
	groups = {cracky = 1},
	drop = "default:mese_crystal",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("asteroid:waterice", {
	description = "Comet Water Ice",
	tiles = {"default_ice.png"},
	is_ground_content = false,
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("asteroid:atmos", {
	description = "Comet Atmosphere",
	drawtype = "glasslike",
	tiles = {"asteroid_atmos.png"},
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	post_effect_color = {a = 31, r = 241, g = 248, b = 255},
	groups = {not_in_creative_inventory = 1},
})

minetest.register_node("asteroid:snowblock", {
	description = "Comet Snow Block",
	tiles = {"default_snow.png"},
	is_ground_content = false,
	groups = {crumbly = 3},
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_snow_footstep", gain = 0.15},
		dug = {name = "default_snow_footstep", gain = 0.2},
		dig = {name = "default_snow_footstep", gain = 0.2}
	}),
})

minetest.register_node("asteroid:stonebrick", {
	description = "Asteroid Stone Brick",
	tiles = {"asteroid_stonebricktop.png", "asteroid_stonebrickbot.png",
			"asteroid_stonebrick.png"},
	is_ground_content = false,
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
})


minetest.register_node("asteroid:stonestair", {
	description = "Asteroid Stone Stair",
	tiles = {"asteroid_stonebricktop.png", "asteroid_stonebrickbot.png",
			"asteroid_stonebrick.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {cracky = 3},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
			{-0.5, 0, 0, 0.5, 0.5, 0.5},
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
			{-0.5, 0, 0, 0.5, 0.5, 0.5},
		},
	},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("asteroid:stoneslab", {
	description = "Asteroid Stone Slab",
	tiles = {"asteroid_stonebricktop.png", "asteroid_stonebrickbot.png",
			"asteroid_stonebrick.png"},
	drawtype = "nodebox",
	paramtype = "light",
	sunlight_propagates = true,
	buildable_to = true,
	is_ground_content = false,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0, 0.5}
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0, 0.5}
		},
	},
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
})

-- Crafting

minetest.register_craft({
	output = "asteroid:cobble",
	recipe = {
		{"asteroid:stone"},
	},
})

minetest.register_craft({
	output = "asteroid:gravel",
	recipe = {
		{"asteroid:cobble"},
	},
})

minetest.register_craft({
	output = "asteroid:dust",
	recipe = {
		{"asteroid:gravel"},
	},
})

minetest.register_craft({
	output = "asteroid:stonebrick 4",
	recipe = {
		{"asteroid:stone", "asteroid:stone"},
		{"asteroid:stone", "asteroid:stone"},
	}
})

minetest.register_craft({
	output = "asteroid:stonestair 4",
	recipe = {
		{"asteroid:stone", ""},
		{"asteroid:stone", "asteroid:stone"},
	}
})

minetest.register_craft({
	output = "asteroid:stoneslab 4",
	recipe = {
		{"asteroid:stone", "asteroid:stone"},
	}
})

minetest.register_craft({
	output = "default:water_source",
	recipe = {
		{"asteroid:waterice"},
	},
})

minetest.register_craft({
	output = "default:water_source",
	recipe = {
		{"asteroid:snowblock"},
	},
})
