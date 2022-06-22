-- spacestation (Minetest 0.4 mod)
-- Space Station parts

spacestation = {}

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

function makeDoorOpen(closedDoorName)

   local function doorOpen(pos, node, clicker)
      -- Is door access locked
      local meta = minetest.get_meta(pos)
      local lock_var = meta:get_string("lock")
      local can_open
      -- print(dump(lock_var))
      if lock_var == nil  or lock_var == "" then
         can_open = true
      else
         local wielded_stack = clicker:get_wielded_item()
         local metadata = wielded_stack:get_metadata()
         --print("Meta: " .. metadata)
         if metadata == nil or metadata == "" then
            can_open = false
         else
            local item_meta = minetest.deserialize(metadata)
               --active = false,
               --access = {},
            --print("lock: " .. lock_var)
            --print("dump: " .. dump(item_meta))
            if item_meta.active then
               can_open = false
               for _,v in ipairs(item_meta.access) do
                  --print("v: " .. v)
                  if v == lock_var then
                     can_open = true
                     break
                  end
               end
            else
               can_open = false
            end

         end
      end

      if can_open then
         doorToggle(pos, node, clicker, closedDoorName, closedDoorName .. "_open")
      end
   end
   return doorOpen
end

function makeDoorClose(closedDoorName)
   local function doorClose(pos, node, clicker)
      doorToggle(pos, node, clicker, closedDoorName, closedDoorName .. "_open")
   end
   return doorClose
end

function getOffset(facingDir)

   local offset
   if facingDir == 0 then
      offset = { x = -1, y = 0, z =  0 }
   elseif facingDir == 1 then
      offset = { x =  0, y = 0, z =  1 }
   elseif facingDir == 2 then
      offset = { x =  1, y = 0, z =  0 }
   elseif facingDir == 3 then
      offset = { x =  0, y = 0, z = -1 }
   else
      offset = nil
   end
   return offset
end



function getOtherDoor(pos, doorNode, closedDoorName, openDoorName)
   -- param2 should be facing dir
   -- 0 = z; 1 = x; 2 = -z; 3 = -x
   local offset = getOffset(doorNode.param2)
   if offset == nil then
      return nil, nil
   end
   local otherDoorPos = vector.add(pos, offset)
   local possibleDoor = minetest.get_node(otherDoorPos)
   if possibleDoor ~= nil and 
      possibleDoor.name ~= closedDoorName and
      possibleDoor.name ~= openDoorName then
      return nil, nil
   end
   local otherDoorOffset = getOffset(possibleDoor.param2)
   if otherDoorOffset == nil then
      return nil, nil
   end
   local offsetSum = vector.add(offset, otherDoorOffset)
   if not vector.equals(offsetSum, vector.new(0,0,0)) then 
      return nil, nil
   end
   return otherDoorPos, possibleDoor
end
   

function doorToggle(pos, node, clicker, closedDoorName, openDoorName)
   local newname
   if node.name == openDoorName then
      newname = closedDoorName
   else
      newname = openDoorName
   end
   minetest.swap_node(pos, { 
      name = newname, 
      param1 = node.param1, 
      param2 = node.param2
      })
   local otherDoorPos, otherDoorNode = getOtherDoor(pos, node, closedDoorName, openDoorName)
   if otherDoorPos ~= nil then
      minetest.swap_node(otherDoorPos, { 
         name = newname, 
         param1 = otherDoorNode.param1, 
         param2 = otherDoorNode.param2
         })
   end

end


minetest.register_node("spacestation:door", {
	description = "Space Station Interal Door",
	tiles = {{ name = "spacestation_door.png", backface_culling = true }},
	--inventory_image = "spacestation_door.png",	
	groups = {cracky=3, access=1},
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
   on_rightclick = makeDoorOpen("spacestation:door"),
})

minetest.register_node("spacestation:door_open", {
	description = "Space Station Interal Door",
	tiles = {{ name = "spacestation_door.png", backface_culling = true }},
	--inventory_image = "spacestation_door.png",	
	groups = {cracky=3, access=1},
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
   on_rightclick = makeDoorClose("spacestation:door"),
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
      local node_name = minetest.get_node(pointed_thing.under).name
      --print(node_name)
      local access_group = minetest.get_item_group(node_name, "access")
      if access_group >= 1 then

         local meta = minetest.get_meta(pointed_thing.under)
         local lock_var = meta:get_string("lock")
         
         --print(lock_var)
         if lock_var == nil then
            lock_var = ""
         end

         local form = 
            "formspec_version[5]" ..
            "size[4,2]" ..
            "field[0,0;4,1;spacestation:programmer_text;Permission;" .. lock_var .. "]" ..
            "button_exit[0,1;4,1;spacestation:programmer_button;Program]"

         --print(user:get_player_name())
         minetest.show_formspec(user:get_player_name(), "spacestation:programmer", form)
         minetest.register_on_player_receive_fields(function(player, formname, fields)
            if formname ~= "spacestation:programmer" then
               return false
            end
            --print(dump(fields))
            -- If you press esc you only get the exit field
            if fields["spacestation:programmer_text"] ~= nil then
               meta:set_string("lock", fields["spacestation:programmer_text"])
            end

            return true
         end)
      end
      return nil
   end,
})


btn_text_set = "Set"
btn_text_reset = "Reset"
btn_text_clear = "Clear"

function computer_idcard_build_formspec(item_meta)

   local perm_list = minetest.formspec_escape(table.concat(item_meta.access, "\n"))

   --print("List:  " .. perm_list .. "\n")
   local checkbox
   if item_meta.active then
      checkbox = "true"
   else
      checkbox = "false"
   end 

   local spec = "size[10,9]"..
                "list[current_name;input;0,1;1,1;]"..
                "textarea[2,1;4,3;spacestation:computer_idcard_text;Permissions;" .. perm_list .. "]"..
                "button[6,0;2,1;spacestation:computer_idcard_button;" .. btn_text_set .. "]"..
               -- "button[6,1;3,1;spacestation:computer_idcard_button;" .. btn_text_reset .. "]"..
                "button[6,2;3,1;spacestation:computer_idcard_button;" .. btn_text_clear .. "]"..
                "checkbox[6,3;spacestation:computer_idcard_checkbox;Enabled;" .. checkbox .. "]" ..
                "list[current_player;main;1,5;8,4;]"..
                "listring[]"
   return spec
end

minetest.register_node("spacestation:computer_idcard", {
	description = "ID Card Computer",
	tiles = {{ name = "spacestation_computer_idcard.png", backface_culling = true }},
	groups = {cracky=3, access=1},
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

      meta:set_string("formspec", computer_idcard_build_formspec(item_meta))
      
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

      meta:set_string("formspec", computer_idcard_build_formspec(item_meta))
      
   end,
   on_metadata_inventory_take = function(pos, listname, index, stack, player)
      local meta = minetest.get_meta(pos)
      local item_meta = {
         active = false,
         access = {},
      }
      meta:set_string("formspec", computer_idcard_build_formspec(item_meta))
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
      local cmp_checkbox = fields["spacestation:computer_idcard_checkbox"]
      local cmp_text_out = cmp_text
      
      local cmp_index = nil
      if cmp_button == btn_text_set then
         local perm
         item_meta.access = {}
         for perm in  string.gmatch(cmp_text, "%S+") do
            table.insert(item_meta.access, perm)
         end
         --print(dump(item_meta))
      elseif cmp_button == btn_text_reset then
         -- Maybe I dont need to do anything here
      elseif cmp_button == btn_text_clear then
         item_meta.access = {}
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


      meta:set_string("formspec", computer_idcard_build_formspec(item_meta))

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

sfinv.register_page("spacestation:equipment", {
   title = "Equipment",
   get = function(self, player, context)
      local formspec = "list[current_player;idcard;0,0;1,1]"
      return sfinv.make_formspec(player, context, formspec, true)
   end
})

minetest.register_on_joinplayer(function(player)
   local inv = player:get_inventory()
   inv:set_size("idcard", 1)
end)

minetest.register_allow_player_inventory_action(function(player, action, inventory, inventory_info)
   local liststring = nil
   local count = 0
   local itemType = nil
   if action == 'move' then
      local stack = inventory:get_stack(inventory_info.from_list, inventory_info.from_index)
      liststring = inventory_info.to_list
      count = inventory_info.count
      if count == nil then
         count = stack:get_count() 
      end
      itemType = stack:get_name()
   elseif action == 'put' then
      liststring = inventory_info.liststring
      count = inventory_info.stack:get_count()
      itemType = inventory_info.stack:get_name()
   elseif action == 'take' then
      count = inventory_info.stack:get_count()
   end

   if liststring == 'idcard' then
      if itemType == 'spacestation:idcard' then
         return 1
      else
         return 0
      end
   end
   return count 

end)

local spacestation_path = minetest.get_modpath("spacestation")

dofile(spacestation_path .. "/mapgen.lua")
dofile(spacestation_path .. "/skybox.lua")

