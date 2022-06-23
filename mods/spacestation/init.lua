-- spacestation (Minetest 0.4 mod)
-- Space Station parts

local function make_table_using_key(array, keyName)
   local t={}
   local function toKeyText(text)
      return string.gsub(text, " ", "_"):lower()
   end
   for i,v in ipairs(array) do
      local key = toKeyText(v[keyName])
      t[key] = v
   end
   return t
end

local access_ordered = {
   { name = "Command" },
   { name = "Captain Office" },
   { name = "Head Of Personel Office" },
   { name = "Security" },
   { name = "Head Of Security Office" },
   { name = "Cargo" },
   { name = "Mining" },
   { name = "Quarter Master Office" },
   { name = "Engineering" },
   { name = "Chief Engineer Office" },
   { name = "Kitchen" },
   { name = "Botany" },
   { name = "Science" },
   { name = "Research Director Office" },
   { name = "Medical" },
   { name = "Chief Medical Officer Office" },
   { name = "Clown Office" },
   { name = "Maintenance" },
   { name = "Crew" },
}

local access = make_table_using_key(access_ordered, "name")



local jobs_ordered = {
   { 
      name = "Captain",
      permissions = { 
         access.command, 
         access.captain_office,
         access.head_of_personel_office,
         access.security,
         access.head_of_security_office,
         access.cargo,
         access.mining,
         access.quarter_master_office,
         access.engineering,
         access.chief_engineer_office,
         access.kitchen,
         access.botany,
         access.science,
         access.research_director_office,
         access.medical,
         access.chief_medical_officer_office,
         access.clown_office,
         access.maintenance,
         access.crew
      } 
   },
   { 
      name = "Head Of Personel",
      permissions = { 
         access.command, 
         access.head_of_personel_office,
         access.security,
         access.kitchen,
         access.botany,
         access.cargo,
         access.mining,
         access.maintenance,
         access.crew
      } 
   },
   { 
      name = "Botanist",
      permissions = { 
         access.botany,
         access.crew
      } 
   },   
   { 
      name = "Chef", 
      permissions = { 
         access.kitchen,
         access.crew
      } 
   },
   { 
      name = "Bartender",
      permissions = {
         access.crew
      } 
   },
   { 
      name = "Janitor",
      permissions = {
         access.crew
      } 
   },
   { 
      name = "Quarter Master",
      permissions = {
         access.cargo,
         access.mining,
         access.quarter_master_office,
         access.crew
      }
   },
   { 
      name = "Miner",
      permissions = {
         access.cargo,
         access.mining,
         access.crew
      }
   },
   { 
      name = "Cargo Technician",
      permissions = {
         access.cargo,
         access.crew
      }
   },
   { 
      name = "Head Of Security",
      permissions = { 
         access.command, 
         access.security,
         access.head_of_security_office,
         access.maintenance,
         access.crew
      } 
   },
   { 
      name = "Security Officer",
      permissions = { 
         access.security,
         access.maintenance,
         access.crew
      }       
   },
   { 
      name = "Chief Medical Officer",
      permissions = { 
         access.command, 
         access.medical,
         access.chief_medical_officer_office,
         access.crew
      }
   },
   { 
      name = "Doctor",
      permissions = { 
         access.command, 
         access.medical,
         access.crew
      }
   },
   { 
      name = "Chief Engineer",
      permissions = { 
         access.command, 
         access.engineering,
         access.chief_engineer_office,
         access.maintenance,
         access.crew
      } 
   },
   { 
      name = "Engineer",
      permissions = { 
         access.engineering,
         access.maintenance,
         access.crew
      } 
   },
   { 
      name = "Research Director",
      permissions = { 
         access.command, 
         access.science,
         access.research_director_office,
         access.crew
      } 
   },
   { 
      name = "Scientist",
      permissions = { 
         access.science,
         access.research_director_office,
         access.crew
      }       
   },
   {
      name = "Clown",
      permissions = { 
         --access.command, 
         --access.captain_office, -- :D
         access.clown_office,
         access.crew
      }
   },
   {
      name = "Assistant",
      permissions = { 
         access.crew
      }
   }
}
local jobs = make_table_using_key(jobs_ordered, "name")



spacestation = {
   jobs_ordered   = jobs_ordered,
   jobs           = jobs,
   access_ordered = access_ordered,
   access         = access,
}

-- Metatable functions

local function create_metatable_functions(metatable_key, create_new_table_function)
   local function get_metadata_table(metadata)
      if metadata ~= nil then
         local text_data = metadata:get_string(metatable_key)
         if text_data ~= nil and text_data ~= "" then
            return minetest.deserialize(text_data)
         end
      end
      return create_new_table_function()
   end

   local function set_metadata_table(metadata, data)
      local text_data = minetest.serialize(data)
      metadata:set_string(metatable_key, text_data)
   end
   return get_metadata_table, set_metadata_table
end

local get_id_card_metadata_table, set_id_card_metadata_table = create_metatable_functions("id_card", function()
   return {
      name = "",
      active = true,
      access = {},
   }
end)

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

local function getOffset(facingDir)

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



local function getOtherDoor(pos, doorNode, closedDoorName, openDoorName)
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
   

local function doorToggle(pos, node, clicker, closedDoorName, openDoorName)
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


local function makeDoorOpen(closedDoorName)

   local function doorOpen(pos, node, clicker)
      -- Is door access locked
      local meta = minetest.get_meta(pos)
      local lock_var = meta:get_string("lock")
      local can_open = false
      -- print(dump(lock_var))
      if lock_var == nil  or lock_var == "" then
         can_open = true
      else
         local wielded_stack = clicker:get_wielded_item()
         local metadata = wielded_stack:get_meta()
         local item_meta = get_id_card_metadata_table(metadata)
         --print("Meta: " .. metadata)
         if item_meta.active then
            for _,v in ipairs(item_meta.access) do
               if v == lock_var then
                  can_open = true
                  break
               end
            end
         end
      end

      if can_open then
         doorToggle(pos, node, clicker, closedDoorName, closedDoorName .. "_open")
      end
   end
   return doorOpen
end

local function makeDoorClose(closedDoorName)
   local function doorClose(pos, node, clicker)
      doorToggle(pos, node, clicker, closedDoorName, closedDoorName .. "_open")
   end
   return doorClose
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

local _context = {}
local function get_context(player)
   if type(player) ~= "string" then
      -- Possibly really bad assuption that the table is a player
      player = player:get_player_name()
   end
   local context = _context[player] or {}
   _context[player] = context
   return context
end

minetest.register_on_leaveplayer(function(player)
   _contexts[player:get_player_name()] = nil
end)


minetest.register_on_player_receive_fields(function(player, formname, fields)
   if formname ~= "spacestation:programmer" then
      return false
   end
   local context = get_context(player)
   --print(dump(fields))
   -- If you press esc you only get the exit field
   local text = fields["spacestation:programmer_text"]
   if text == nil or context.formspec == nil then
      return false
   end
   local target = context.formspec.target
   context.formspec = nil
   local meta = minetest.get_meta(target)

   meta:set_string("lock", fields["spacestation:programmer_text"])

   return true
end)

minetest.register_craftitem("spacestation:programmer", {
   description = "Programmer",
   inventory_image = "spacestation_programmer.png",
   stack_max = 1,
   on_use = function(itemstack, user, pointed_thing)
      if pointed_thing.type ~= "node" then
         return
      end
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
         local context = get_context(user)
         context.formspec = {
            target = pointed_thing.under
         }

         local form = 
            "formspec_version[5]" ..
            "size[4,2]" ..
            "field[0,0;4,1;spacestation:programmer_text;Permission;" .. lock_var .. "]" ..
            "button_exit[0,1;4,1;spacestation:programmer_button;Program]"

         --print(user:get_player_name())
         minetest.show_formspec(user:get_player_name(), "spacestation:programmer", form)
      end
      return nil
   end,
})

local btn_text_set   = "Set"
local btn_text_reset = "Reset"
local btn_text_clear = "Clear"

local function computer_idcard_build_formspec(item_meta)

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
      local metadata = stack:get_meta()
      local item_meta = get_id_card_metadata_table(metadata)

      -- Build list string

      meta:set_string("formspec", computer_idcard_build_formspec(item_meta))
      
   end,
   on_metadata_inventory_take = function(pos, listname, index, stack, player)
      local meta = minetest.get_meta(pos)
      local item_meta = get_id_card_metadata_table(meta)
      meta:set_string("formspec", computer_idcard_build_formspec(item_meta))
   end,
   on_receive_fields = function(pos, formname, fields, sender)
      local meta = minetest.get_meta(pos)
      local inv = meta:get_inventory()
      local stack = inv:get_stack("input", 1)
      if stack:get_name() ~= "spacestation:idcard" then
         return
      end

      local metadata = stack:get_meta()
      local item_meta = get_id_card_metadata_table(metadata)
      --print(dump(fields))
      
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
      set_id_card_metadata_table(metadata, item_meta)
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

local function create_id_card_stack(name, accessList)
   local stack = ItemStack("spacestation:idcard")
   stack:set_count(1)
   local metadata = stack:get_meta()
   local idCardMeta = get_id_card_metadata_table(metadata)
   for i,v in ipairs(accessList) do
      table.insert(idCardMeta.access, v.name)
   end
   idCardMeta.name = name
   set_id_card_metadata_table(metadata, idCardMeta)
   return stack
end

minetest.register_on_newplayer(function(ObjectRef)
   local playerInventory = ObjectRef:get_inventory()
   local playerInventoryName = ObjectRef:get_wield_list()
   local idCardStack = create_id_card_stack("Bob Ross", jobs.captain.permissions)
   playerInventory:set_stack(playerInventoryName, 1, idCardStack)
end)

local spacestation_path = minetest.get_modpath("spacestation")

dofile(spacestation_path .. "/mapgen.lua")
dofile(spacestation_path .. "/skybox.lua")

