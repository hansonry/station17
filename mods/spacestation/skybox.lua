

minetest.register_on_joinplayer(function(player)
   local skyTexBase = "spacestation_sky_"
   player:set_sky("#000000", "skybox", {
               skyTexBase .. "top.png",
               skyTexBase .. "bottom.png",
               skyTexBase .. "west.png",
               skyTexBase .. "east.png",
               skyTexBase .. "north.png",
               skyTexBase .. "south.png",
      }, false)
end)

