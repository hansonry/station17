-- outerspace (Minetest 0.4 mod)

minetest.register_on_joinplayer(function(player)
    minetest.setting_set("time_speed", 2.635431918)
end)
minetest.register_on_shutdown(function(player)
    minetest.setting_set("time_speed", 72)
end)

-- Disable clouds and enable them again when player leaves the game. (Experimental)
minetest.register_on_joinplayer(function(player)
    minetest.setting_set("enable_clouds", 0)
end)
minetest.register_on_shutdown(function(player)
    minetest.setting_set("enable_clouds", 1)
end)

local skytextures = {
	"outerspace_pos_y.png",
	"outerspace_neg_y.png",
	"outerspace_pos_z.png",
	"outerspace_neg_z.png",	
	"outerspace_neg_x.png",
	"outerspace_pos_x.png",
}

--Sky textures
minetest.register_on_joinplayer(function(player)
	minetest.after(0, function()
		player:set_sky({r=0, g=0, b=0, a=0},"skybox", skytextures)
	end)
end)



