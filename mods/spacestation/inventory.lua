
local original_make_formspec = sfinv.make_formspec

local spacestation_theme_inv = [[
      list[current_player;idcard;0,5.2;1,1;]
      list[current_player;main;2,5.2;2,1;]
   ]]


function sfinv.make_formspec(player, context, content, show_inv, size)
   local isCreative = minetest.is_creative_enabled(player:get_player_name())
   if isCreative then
      return original_make_formspec(player, context, content, show_inv, size)
   else
      local tmp = {
         size or "size[8,9.1]",
         sfinv.get_nav_fs(player, context, context.nav_titles, context.nav_idx),
         show_inv and spacestation_theme_inv or "",
         content
      }
      return table.concat(tmp, "")
   end

end

