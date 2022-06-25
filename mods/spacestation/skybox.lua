

minetest.register_on_joinplayer(function(player)
   local skyTexBase = "spacestation_sky_"
   player:set_sky({
      type = "skybox",
      base_color = "#000000", 
      textures = {
         skyTexBase .. "top.png",
         skyTexBase .. "bottom.png",
         skyTexBase .. "west.png",
         skyTexBase .. "east.png",
         skyTexBase .. "north.png",
         skyTexBase .. "south.png",
      }, 
      clouds = false
   })
   player:set_sun({
      visible = false
   })
   player:set_moon({
      visible = false
   })
   player:set_stars({
      visible = false
   })
end)

