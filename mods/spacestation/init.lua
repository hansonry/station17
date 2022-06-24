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
   { name = "Head Of Personnel Office" },
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
         access.head_of_personnel_office,
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
         access.head_of_personnel_office,
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
   return {get = get_metadata_table, set = set_metadata_table}
end

local id_card_metadata_table = create_metatable_functions("id_card", function()
   return {
      name = "",
      job_title = "",
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
   local timer1 = minetest.get_node_timer(pos)
   timer1:start(2)
   
   local otherDoorPos, otherDoorNode = getOtherDoor(pos, node, closedDoorName, openDoorName)
   if otherDoorPos ~= nil then
      minetest.swap_node(otherDoorPos, { 
         name = newname, 
         param1 = otherDoorNode.param1, 
         param2 = otherDoorNode.param2
      })
      local timer2 = minetest.get_node_timer(otherDoorPos)
      timer2:start(2)
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
         local item_meta = id_card_metadata_table.get(metadata)
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
	description = "Space Station internal Door",
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
	description = "Space Station internal Door",
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
   on_timer = function(pos, elapsed)
      local node = minetest.get_node(pos)
      node.name = "spacestation:door"
      minetest.set_node(pos, { 
         name = "spacestation:door", 
         param1 = node.param1, 
         param2 = node.param2
      })
      return false
   end,

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
         "list[context;main;0,0;4,1;]"..
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

   if context.formspec == nil then
      return true
   end
   local target = context.formspec.target
   context.formspec = nil
   
   local function check_for_access_button()
      for i,v in ipairs(access_ordered) do
         if fields[v.name] ~= nil then
            return v
         end
      end
      return nil
   end
   
   local button_clicked = check_for_access_button()
   
  
   if button_clicked == nil then
      return true
   end

   local node = minetest.get_node(target)
   local access_group = minetest.get_item_group(node.name, "access")
   if not (access_group >= 1) then
      return true
   end

   local meta = minetest.get_meta(target)

   meta:set_string("lock", button_clicked.name)
   
   local otherDoorPos, _ = getOtherDoor(target, node, 
                                  "spacestation:door", "spacestation:door_open")
   if otherDoorPos ~= nil then
      local otherDoorMeta = minetest.get_meta(otherDoorPos)
      otherDoorMeta:set_string("lock", button_clicked.name)
   end

   return true
end)

local function formspec_builder(compTable, hori_spacing, virt_spacing, page_padding)
   hori_spacing = hori_spacing or 0.1
   virt_spacing = virt_spacing or 0.1
   page_padding = page_padding or 0.5
   local invGridScale = 1.2
   local next_x = page_padding
   local next_y = page_padding
   local max_x = next_x
   local formStr = ""
   local f = string.format
   for row_i, row_v in ipairs(compTable) do
      next_x = page_padding
      local row_height = 0
      if type(row_v) == "string" and row_v == "player_inventory" then
         formStr = formStr .. 
                   f("list[current_player;main;%.3f,%.3f;8,4;]", 
                     next_x, next_y) ..
                   "listring[]"
         row_height = 4 * invGridScale
         next_x = next_x + 8 * invGridScale 
      elseif type(row_v) == "number" then
         row_height = row_v
      else
         for cell_i, cell_v in ipairs(row_v) do
            local cell_height = 0
            local cellType = cell_v[1]
            if cellType == "label" then
               local width = cell_v[2]
               local text  = cell_v[3]
               formStr = formStr ..
                         f("label[%.3f,%.3f;%s]", 
                           next_x, next_y + 0.5, text)
               next_x = next_x + width
               cell_height = 1
            elseif cellType == "list" then
               local width    = cell_v[2]
               local height   = cell_v[3]
               local location = cell_v[4]
               local name     = cell_v[5]
               formStr = formStr ..
                         f("list[%s;%s;%.3f,%.3f;%d,%d;]",
                           location, name, next_x, next_y, width, height)
               next_x = next_x + width * invGridScale
               cell_height = height * invGridScale
            elseif cellType == "field" then
               local width = cell_v[2]
               local name  = cell_v[3]
               local text  = cell_v[4]
               local closeOnEnter = cell_v[5] == nil and true or cell_v[5]
               
               formStr = formStr ..
                         f("field[%.3f,%.3f;%.3f,%.3f;%s;;%s]",
                           next_x, next_y + 0.25, width, 0.5, name, text)
               -- Default value for close on enter is true, 
               -- so only create an entery when false
               if not closeOnEnter then
                  formStr = formStr ..
                            f("field_close_on_enter[%s;false]", name)
               end
               next_x = next_x + width
               cell_height = 0.75
            elseif cellType == "button" or cellType == "button_exit" then
               local width = cell_v[2]
               local name  = cell_v[3]
               local text  = cell_v[4]
               formStr = formStr ..
                         f("%s[%.3f,%.3f;%.3f,%.3f;%s;%s]", 
                           cellType, next_x, next_y, width, 0.75, name, text) 
               next_x = next_x + width
               cell_height = 0.75
            elseif cellType == "checkbox" then
               local width = cell_v[2]
               local name  = cell_v[3]
               local text  = cell_v[4]
               local value = cell_v[5] or false
               local valueStr = value and "true" or "false"
               formStr = formStr ..
                         f("checkbox[%.3f,%.3f;%s;%s;%s]", 
                           next_x, next_y + 0.5, name, text, valueStr) 
               next_x = next_x + width
               cell_height = 0.75
            else
               assert(true, f("Unknown cell type: %s", cellType))
            end
            next_x = next_x + virt_spacing
            if cell_height > row_height then row_height = cell_height end
         end
      end
      next_y = next_y + row_height + hori_spacing
      if next_x > max_x then max_x = next_x end
   end
   
   return "formspec_version[5]" ..
          f("size[%.3f,%.3f]", max_x + page_padding, next_y + page_padding) ..
          formStr
end



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
         local function insert_access_buttons(data, button_type, max_line_size)
            local buttons = {}
            local line_size = 0
            max_line_size = max_line_size or 15
            button_type = button_type or "button"
            for i,v in ipairs(access_ordered) do
               local size = (#v.name) * 0.2
               table.insert(buttons, {button_type, size, v.name, v.name})
               line_size = line_size + size
               if line_size > max_line_size then
                  line_size = 0
                  table.insert(data, buttons)
                  buttons = {}
               end
            end
            if #buttons > 0 then
               table.insert(data, buttons)
            end
         end

         local door_meta = minetest.get_meta(pointed_thing.under)
         local lock_var = door_meta:get_string("lock")
         
         --print(lock_var)
         if lock_var == nil then
            lock_var = ""
         end
         local context = get_context(user)
         
         local data = {}
         table.insert(data, {
            { "label", 10, lock_var }
         })
         insert_access_buttons(data, "button_exit")
         
         context.formspec = {
            target = pointed_thing.under
         }

         local form = formspec_builder(data)

         --print(user:get_player_name())
         minetest.show_formspec(user:get_player_name(), "spacestation:programmer", form)
      end
      return nil
   end,
})


local function computer_idcard_build_formspec(inventory)
   local target_id_stack = inventory:get_stack("target_id", 1)
   local target_name = ""
   local target_job_title = ""
   local perm_list = ""
   local checkbox = "false"
   local target_id_item_meta = nil
   if not target_id_stack:is_empty() then
      local target_id_metadata = target_id_stack:get_meta()
      target_id_item_meta = id_card_metadata_table.get(target_id_metadata)
      target_name = target_id_item_meta.name
      target_job_title = target_id_item_meta.job_title
      perm_list = minetest.formspec_escape(table.concat(target_id_item_meta.access, "\n"))
      
      if target_id_item_meta.active then
         checkbox = "true"
      else
         checkbox = "false"
      end 
   end
   
   local user_name = ""
   local user_job_title = ""
   local user_id_item_meta = nil
   
   local user_id_stack = inventory:get_stack("user_id", 1)
   if not user_id_stack:is_empty() then
      local user_id_metadata = user_id_stack:get_meta()
      user_id_item_meta = id_card_metadata_table.get(user_id_metadata)
      user_name = user_id_item_meta.name
      user_job_title = user_id_item_meta.job_title
   end
   --print("List:  " .. perm_list .. "\n")

   local function insert_job_buttons(data, button_type, max_line_size)
      local buttons = {}
      local line_size = 0
      max_line_size = max_line_size or 15
      button_type = button_type or "button"
      for i,v in ipairs(jobs_ordered) do
         local size = (#v.name) * 0.2
         table.insert(buttons, {button_type, size, v.name, v.name})
         line_size = line_size + size
         if line_size > max_line_size then
            line_size = 0
            table.insert(data, buttons)
            buttons = {}
         end
      end
      if #buttons > 0 then
         table.insert(data, buttons)
      end
   end
   
   local function insert_access_checks(data)
      local checkboxs = {}
      local line_size = 0
      local function has_access(access)
         if target_id_item_meta == nil then
            return false
         end
         for i, v in ipairs(target_id_item_meta.access) do
            if access.name == v then
               return true
            end
         end
         return false
      end
      for i,v in ipairs(access_ordered) do
         local size = (#v.name) * 0.15 + 0.3
         local hasAccess = has_access(v)
         table.insert(checkboxs, {"checkbox", size, v.name, v.name, hasAccess})
         line_size = line_size + size
         if line_size > 15 then
            line_size = 0
            table.insert(data, checkboxs)
            checkboxs = {}
         end
      end
      if #checkboxs > 0 then
         table.insert(data, checkboxs)
      end
   end

   local data = {}
   table.insert(data, {
      {"label", 1.5, "User ID:"},
      {"list",  1, 1, "context", "user_id"},
      {"label", 1, "Name:"},
      {"label", 3, user_name},
      {"label", 1, "Job:"},
      {"label", 4, user_job_title}, 
   })
   table.insert(data, {
      {"label", 1.5, "Target ID:"},
      {"list",  1, 1, "context", "target_id"},
      {"label", 1, "Name:"},
      {"field", 3, "target_name", target_name, false},
      {"label", 1, "Job:"},
      {"field", 4, "target_job_title", target_job_title, false}, 
   })
   table.insert(data, 0.5)
   insert_job_buttons(data)

   table.insert(data, 0.5)
   insert_access_checks(data)
   
   table.insert(data, 0.5)
   table.insert(data, "player_inventory")

   local spec = formspec_builder(data)

   --print(spec)
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
      
      meta:set_string("infotext", "ID Computer")
      meta:set_string("text_field", "")
      meta:set_int("index", 1)
      
      local inv = meta:get_inventory()
      inv:set_size("target_id", 1)
      inv:set_size("user_id", 1)
      
      meta:set_string("formspec", computer_idcard_build_formspec(inv))
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

      local formspec_str = computer_idcard_build_formspec(inv)
      -- Build list string

      meta:set_string("formspec", formspec_str)
      
   end,
   on_metadata_inventory_move = function(pos, listname, index, stack2, player)
      local meta = minetest.get_meta(pos)
      local inv = meta:get_inventory()

      local formspec_str = computer_idcard_build_formspec(inv)
      -- Build list string

      meta:set_string("formspec", formspec_str)
      
   end,
   on_metadata_inventory_take = function(pos, listname, index, stack, player)
      local meta = minetest.get_meta(pos)
      local inv = meta:get_inventory()
      meta:set_string("formspec", computer_idcard_build_formspec(inv))
   end,
   on_receive_fields = function(pos, formname, fields, sender)
      
      local meta = minetest.get_meta(pos)
      local inv = meta:get_inventory()
      local target_id_stack = inv:get_stack("target_id", 1)
      if target_id_stack:get_name() ~= "spacestation:idcard" then
         return
      end

      local target_id_meta = target_id_stack:get_meta()
      local target_id_data = id_card_metadata_table.get(target_id_meta)


      local function check_for_button()
         for i,v in ipairs(jobs_ordered) do
            if fields[v.name] ~= nil then
               return v
            end
         end
         return nil
      end
      
      local function check_for_checkbox()
         for i,v in ipairs(access_ordered) do
            if fields[v.name] ~= nil then
               return v
            end
         end
         return nil
      end


      target_id_data.name = fields["target_name"] or target_id_data.name
      target_id_data.job_title = fields["target_job_title"] or target_id_data.job_title
      target_id_data.active = true
      
      local job_button = check_for_button(fields)
      local access_checkbox = check_for_checkbox()
      if job_button ~= nil then
         target_id_data.access = {}
         for i,v in ipairs(job_button.permissions) do
            table.insert(target_id_data.access, v.name)
         end
         target_id_data.job_title = job_button.name
         
      elseif access_checkbox ~= nil then
         local checkbox_value_str = fields[access_checkbox.name] or "false"
         local checkbox_value = checkbox_value_str == "true" and true or false
         local foundIndex = nil
         for i,v in ipairs(target_id_data.access) do
            if v == access_checkbox.name then
               foundIndex = i
               break
            end
         end

         if checkbox_value then
            if foundIndex == nil then
               table.insert(target_id_data.access, access_checkbox.name)
            end
         else
            if foundIndex ~= nil then
               table.remove(target_id_data.access, foundIndex)
            end
         end
      end   
      
      --print(minetest.serialize(target_id_data))
      id_card_metadata_table.set(target_id_meta, target_id_data)
      inv:set_stack("target_id", 1, target_id_stack)

      meta:set_string("formspec", computer_idcard_build_formspec(inv))

   end,
   --[[
   on_rightclick = function(pos, self, clicker, itemstack)
      
      local spec = "size[8,9]"..
                   "list[context;target_id;0;0;1;1]"..
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

local function create_id_card_stack(name, jobTitle, accessList)
   local stack = ItemStack("spacestation:idcard")
   stack:set_count(1)
   local metadata = stack:get_meta()
   local idCardMeta = id_card_metadata_table.get(metadata)
   for i,v in ipairs(accessList) do
      table.insert(idCardMeta.access, v.name)
   end
   idCardMeta.name = name
   idCardMeta.job_title = jobTitle
   id_card_metadata_table.set(metadata, idCardMeta)
   return stack
end

minetest.register_on_newplayer(function(ObjectRef)
   local playerInventory = ObjectRef:get_inventory()
   local playerInventoryName = ObjectRef:get_wield_list()
   local idCardStack = create_id_card_stack("Bob Ross", jobs.captain.name, jobs.captain.permissions)
   playerInventory:set_stack(playerInventoryName, 1, idCardStack)
end)

local spacestation_path = minetest.get_modpath("spacestation")

dofile(spacestation_path .. "/mapgen.lua")
dofile(spacestation_path .. "/skybox.lua")

