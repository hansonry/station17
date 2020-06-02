

minetest.register_on_joinplayer(function(player)
   local skyTexBase = ""
   player:set_sky("#000000", "skybox", {
               skyTexBase .. "top.png",
               skyTexBase .. "bot.png",
               skyTexBase .. "front.png",
               skyTexBase .. "back.png",
               skyTexBase .. "right.png",
               skyTexBase .. "left.png",
      }, false)
end)

