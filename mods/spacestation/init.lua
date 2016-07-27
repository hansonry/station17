-- spacestation (Minetest 0.4 mod)
-- Space Station parts

-- Register nodes

minetest.register_node("spacestation:floor", {
	description = "Space Station Floor",
	tiles ={"spacestation_floor.png"},
	groups = {cracky=3},
	drop = 'spacestation:floor',
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("spacestation:wall", {
	description = "Space Station Wall",
	tiles ={"spacestation_wall.png"},
	groups = {cracky=3},
	drop = 'spacestation:wall',
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("spacestation:roof", {
	description = "Space Station Roof",
	tiles ={"spacestation_roof.png"},
	groups = {cracky=3},
	drop = 'spacestation:roof',
	sounds = default.node_sound_stone_defaults(),
})

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
   stack_max = 1,
})


minetest.register_craftitem("spacestation:programmer", {
   description = "Programmer",
   inventory_image = "spacestation_programmer.png",
   stack_max = 1,
   on_use = function(itemstack, user, pointed_thing)
      --print(dump(pointed_thing))
      local form = 
         "size[4,2]"..
         "field[0,0;4,1;spacestation:programmer_text;Permission;test]"..
         "button[0,1;4,1;spacestation:programmer_button;Program]"

      print(user:get_player_name())
      minetest.show_formspec(user:get_player_name(), "spacestation:programmer", form)
      minetest.register_on_player_receive_fields(function(player, formname, fields)
         if formname ~= "spacestation:programmer" then
            return false
         end
         print(dump(fields))
         return true
      end)
      return nil
   end,
})


btn_text_add = "Add"
btn_text_remove = "Remove"
btn_text_clear = "Clear Text Field"
btn_text_blank = "Blank Card"

function computer_idcard_build_formspec(item_meta, selected_index, text_box_str)

   local perm_list = table.concat(item_meta.access, ",")

   local checkbox
   if item_meta.active then
      checkbox = "true"
   else
      checkbox = "false"
   end 

   local spec = "size[10,9]"..
                "list[current_name;input;0,1;1,1;]"..
                "tablecolumns[text]"..
                "table[1,0;4,3;spacestation:computer_idcard_table;" .. perm_list .. ";" ..selected_index .. "]"..
                "button[5,0;2,1;spacestation:computer_idcard_button;" .. btn_text_add .. "]"..
                "button[5,1;3,1;spacestation:computer_idcard_button;" .. btn_text_remove .. "]"..
                "button[5,2;3,1;spacestation:computer_idcard_button;" .. btn_text_clear .. "]"..
                "checkbox[5,3;spacestation:computer_idcard_checkbox;Enabled;" .. checkbox .. "]" ..
                "button[5,4;4,1;spacestation:computer_idcard_button;" .. btn_text_blank .. "]"..
                "field[1,4;4,1;spacestation:computer_idcard_text;New Permission;" .. text_box_str .. "]"..
                "list[current_player;main;1,5;8,4;]"..
                "listring[]"
   return spec
end

minetest.register_node("spacestation:computer_idcard", {
	description = "ID Card Computer",
	tiles = {{ name = "spacestation_computer_idcard.png", backface_culling = true }},
	groups = {cracky=3},
	drop = 'spacestation:computer_idcard',
	drawtype = "mesh",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	walkable = true,
	is_ground_content = false,
	buildable_to = false,
	mesh = "spacestation_computer.obj",
	sounds = default.node_sound_stone_defaults(),
   on_construct = function(pos)
      local meta = minetest.get_meta(pos)
      local inv = meta:get_inventory()
      local item_meta = { active = false, access = {} }

      meta:set_string("formspec", computer_idcard_build_formspec(item_meta, 1, ""))
      
      meta:set_string("infotext", "ID Computer")
      meta:set_string("text_field", "")
      meta:set_int("index", 1)
      inv:set_size("input", 1)
   end,
   allow_metadata_inventory_put = function(pos, listname, index, stack, player)
      if stack:get_name() == "spacestation:idcard" then
         return 1
      else
         return 0
      end
   end,
   on_metadata_inventory_put = function(pos, listname, index, stack2, player)
      local meta = minetest.get_meta(pos)
      local inv = meta:get_inventory()
      local stack = inv:get_stack("input", 1)
      local item_meta_str = stack:get_metadata()
      if item_meta_str == "" then
         local new_card_meta = {
            active = false,
            access = {},
         }
         stack:set_metadata(minetest.serialize(new_card_meta))
      end
      local item_meta = minetest.deserialize(stack:get_metadata())

      -- Build list string

      meta:set_string("formspec", computer_idcard_build_formspec(item_meta, 1, ""))
      
   end,
   on_metadata_inventory_take = function(pos, listname, index, stack, player)
      local meta = minetest.get_meta(pos)
      local item_meta = {
         active = false,
         access = {},
      }
      meta:set_string("formspec", computer_idcard_build_formspec(item_meta, 1, ""))
   end,
   on_receive_fields = function(pos, formname, fields, sender)
      local meta = minetest.get_meta(pos)
      local inv = meta:get_inventory()
      local stack = inv:get_stack("input", 1)
      if stack:get_name() ~= "spacestation:idcard" then
         return
      end

      local item_meta_str = stack:get_metadata()
      local item_meta
      --print(dump(fields))
      if item_meta_str == "" then
         item_meta = {
            active = false,
            access = {},
         }
      else
         item_meta = minetest.deserialize(item_meta_str)
      end
      
      local cmp_button   = fields["spacestation:computer_idcard_button"]
      local cmp_text     = fields["spacestation:computer_idcard_text"]
      local cmp_table    = fields["spacestation:computer_idcard_table"]
      local cmp_checkbox = fields["spacestation:computer_idcard_checkbox"]
      local cmp_text_out = cmp_text
      
      local cmp_index = nil
      if cmp_button == btn_text_add then
         if cmp_text ~= "" then
            table.insert(item_meta.access, cmp_text)
         end
      elseif cmp_button == btn_text_remove then
         for i,v in ipairs(item_meta.access) do
            if v == cmp_text then
               table.remove(item_meta.access, i)
               break
            end

         end
      elseif cmp_button == btn_text_clear then
         cmp_text_out = ""
      elseif cmp_button == btn_text_blank then
         item_meta.active = false
         item_meta.access = {}
      elseif cmp_table ~= nil then
         local tbl_exp = minetest.explode_table_event(cmp_table)
         if tbl_exp.type == "DCL" then
            cmp_text_out = item_meta.access[tbl_exp.row]
            cmp_index = tbl_exp.row
         elseif tbl_exp.tpe == "CHG" then
            cmp_index = tbl_exp.row
         end
      elseif cmp_checkbox ~= nil then
         if cmp_checkbox == "true" then
            item_meta.active = true
         else
            item_meta.active = false
         end
      end
      --print(minetest.serialize(item_meta))
      stack:set_metadata(minetest.serialize(item_meta))
      inv:set_stack("input", 1, stack)

      if cmp_text_out == nil then
         cmp_text_out = meta:get_string("text_field")
      else
         meta:set_string("text_field", cmp_text_out)
      end

      if cmp_index == nil then
         cmp_index = meta:get_int("index")
      else 
         meta:set_int("index", cmp_index)
      end

      meta:set_string("formspec", computer_idcard_build_formspec(item_meta, cmp_index, cmp_text_out))

   end,
   --[[
   on_rightclick = function(pos, self, clicker, itemstack)
      
      local spec = "size[8,9]"..
                   "list[current_name;input;0;0;1;1]"..
                   "
      minetest.show_formspec(clicker:get_player_name(), "spacestation:computer_idcard", spec)
      
      return itemstack
   end
   --]]
})

