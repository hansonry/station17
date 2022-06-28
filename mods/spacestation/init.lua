-- spacestation (Minetest 0.4 mod)

spacestation = {}

local spacestation_path = minetest.get_modpath("spacestation")

local creative_inv = [[
		image[0,5.2;1,1;gui_hb_bg.png]
		image[1,5.2;1,1;gui_hb_bg.png]
		image[2,5.2;1,1;gui_hb_bg.png]
		image[3,5.2;1,1;gui_hb_bg.png]
		image[4,5.2;1,1;gui_hb_bg.png]
		image[5,5.2;1,1;gui_hb_bg.png]
		image[6,5.2;1,1;gui_hb_bg.png]
		image[7,5.2;1,1;gui_hb_bg.png]
		list[current_player;main;0,5.2;8,1;]
		list[current_player;main;0,6.35;8,3;8]
	]]

local spacestation_theme_inv = [[
      list[current_player;backpack;0,5.2;1,1;]
      list[current_player;idcard;1,5.2;1,1;]
      list[current_player;main;3,5.2;2,1;]
   ]]




spacestation.theme_inv = spacestation_theme_inv



dofile(spacestation_path .. "/mapgen.lua")
dofile(spacestation_path .. "/skybox.lua")
dofile(spacestation_path .. "/inventory.lua")
local inv_serializer   = dofile(spacestation_path .. "/inventory_serializer.lua")
local formspec_builder = dofile(spacestation_path .. "/formspec_builder.lua")

-- Metatable functions

local function create_metatable_functions(metatable_key, create_new_table_function, extra_set_function)
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
      if extra_set_function ~= nil then
         extra_set_function(metadata, data)
      end
   end
   return {get = get_metadata_table, set = set_metadata_table}
end

local id_card_metadata_table = create_metatable_functions("id_card", 
   function()
      return {
         name = "",
         job_title = "",
         active = true,
         access = {},
      }
   end,
   function(metadata, data)
      local descriptionStr = "ID Card"
      if data.name then
         descriptionStr = data.name
      end
      metadata:set_string("description", descriptionStr)
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

local function ends_with(str, ending)
   return ending == "" or str:sub(-#ending) == ending
end


local function get_door_info(pos)
   local node = minetest.get_node(pos)
   local door_flags = minetest.get_item_group(node.name, "door")
   local can_be_double_door = door_flags == 3 or door_flags == 2
   local can_be_single_door = door_flags == 3 or door_flags == 1
   local is_door = can_be_single_door or can_be_double_door
   if not is_door then
      return nil
   end
   local is_open = ends_with(node.name, "_open")
   local door_close_name = node.name
   if is_open then
      door_close_name = node.name:sub(0, #node.name - 5)
   end
   local door_info = {
      node         = node,
      pos          = pos,
      is_id_locked = minetest.get_item_group(node.name, "id_locked") >= 1,
      is_open      = is_open,
      name_close   = door_close_name,
      name_open    = door_close_name .. "_open",
      is_double    = false
   }
  
   if door_info.is_id_locked then
      local metadata = minetest.get_meta(pos)
      if metadata ~= nil then
         local lock = metadata:get_string("lock")
         if lock ~= nil and lock ~= "" then
            door_info.lock = lock
         end
      end
   end
 
   if not can_be_double_door then return door_info end

   local offset = getOffset(node.param2)

   if offset == nil then return door_info end
   local other_door_pos = vector.add(pos, offset)
   local other_door_node = minetest.get_node(other_door_pos)
   if other_door_node.name ~= door_info.name_close and 
      other_door_node.name ~= door_info.name_open then
      return door_info
   end
   local other_door_flags = minetest.get_item_group(other_door_node.name, "door")
   if other_door_flags == 0 or other_door_flags == 1 then
      -- If not a door or only a single door or the door name doesn't match
      return door_info
   end
   local other_door_offset = getOffset(other_door_node.param2)
   local offset_sum = vector.add(other_door_offset, offset)
   if not vector.equals(offset_sum, vector.new(0, 0, 0)) then
      -- If not facing each other, then this is a single door
      return door_info
   end

   door_info.is_double = true
   door_info.other_door = {
      node    = other_door_node,
      pos     = other_door_pos,
      is_open = other_door_node.name == door_info.name_open,
   }

   return door_info
end

local function door_open(door_info, open_connected)
   local function open_a_door(door_info, open_door_name, lock)
      if not door_info.is_open then
         minetest.swap_node(door_info.pos, { 
            name = open_door_name, 
            param1 = door_info.node.param1, 
            param2 = door_info.node.param2
         })
         local timer = minetest.get_node_timer(door_info.pos)
         timer:start(2)
         if lock ~= nil then
            minetest:get_meta(door_info.pos):set_string("lock", lock)
         end
      end
   end
   if open_connected == nil then open_connected = true end
   open_a_door(door_info, door_info.name_open, door_info.lock)
   if door_info.is_double and open_connected then
      open_a_door(door_info.other_door, door_info.name_open, door_info.lock)
   end
end

local function door_close(door_info, close_connected)
   local function close_a_door(door_info, close_door_name, lock)
      if door_info.is_open then
         minetest.swap_node(door_info.pos, { 
            name = close_door_name, 
            param1 = door_info.node.param1, 
            param2 = door_info.node.param2
         })
         if lock ~= nil then
            minetest:get_meta(door_info.pos):set_string("lock", lock)
         end
      end
   end
   if close_connected == nil then close_connected = true end
   close_a_door(door_info, door_info.name_close, door_info.lock)
   if door_info.is_double and close_connected then
      close_a_door(door_info.other_door, door_info.name_close, door_info.lock)
   end
end

local function makeDoorOpen()
   local function doorOpen(pos, node, clicker)
      local door_info = get_door_info(pos)
      -- Is door access locked
      local can_open = false
      -- print(dump(lock_var))
      if door_info.lock == nil then
         can_open = true
      else
         local function is_id_card_stack(stack)
            return not stack:is_empty() and
                   minetest.get_item_group(stack:get_name(), "id_card") >= 1
         end
         local function id_card_can_open_door(stack)
            local metadata = stack:get_meta()
            local idcard_meta = id_card_metadata_table.get(metadata)
            if idcard_meta.active then
               for _,v in ipairs(idcard_meta.access) do
                  if v == door_info.lock then
                     return true
                  end
               end
            end
            return false
         end
         local wielded_stack = clicker:get_wielded_item()
         local clicker_inv = clicker:get_inventory()
         local id_card_stack = clicker_inv:get_stack("idcard", 1)
         if is_id_card_stack(wielded_stack) then
            can_open = id_card_can_open_door(wielded_stack)
         elseif is_id_card_stack(id_card_stack) then
            can_open = id_card_can_open_door(id_card_stack)
         end
      end

      if can_open then
         door_open(door_info)
      end
   end
   return doorOpen
end

local function makeDoorClose()
   local function doorClose(pos, node, clicker)
      local door_info = get_door_info(pos)
      door_close(door_info)
   end
   return doorClose
end

minetest.register_node("spacestation:door", {
	description = "Space Station internal Door",
	tiles = {{ name = "spacestation_door.png", backface_culling = true }},
	--inventory_image = "spacestation_door.png",	
	groups = {cracky=3, id_locked=1, door=3},
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
   on_rightclick = makeDoorOpen(),
})

minetest.register_node("spacestation:door_open", {
	description = "Space Station internal Door",
	tiles = {{ name = "spacestation_door.png", backface_culling = true }},
	--inventory_image = "spacestation_door.png",	
	groups = {cracky=3, id_locked=1, door=3, not_in_creative_inventory=1},
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
   on_rightclick = makeDoorClose(),
   on_timer = function(pos, elapsed)
      local door_info = get_door_info(pos)
      door_close(door_info, false)
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
      local inv = meta:get_inventory()
      inv:set_size("main", 4 * 1)
      meta:set_string("infotext", "Locker")
      
   end,
   on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
      local meta = minetest.get_meta(pos)
      local isCreative = minetest.is_creative_enabled(clicker:get_player_name())
      local player_inv = spacestation_theme_inv
      if isCreative then
         player_inv = creative_inv
      end
      meta:set_string("formspec", "size[8,9]list[context;main;0,0;8,4]" .. player_inv .. "listring[context;main]listring[current_player;main]")
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
   groups = {id_card=1},
})

minetest.register_craftitem("spacestation:backpack", {
   description = "Backpack",
   inventory_image = "spacestation_backpack.png",
   stack_max = 1,
   groups = {backpack=1,storage_size=8}
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

   local door_info = get_door_info(target)
   if not door_info.is_id_locked then
      return true
   end

   local meta = minetest.get_meta(door_info.pos)

   meta:set_string("lock", button_clicked.name)

   if door_info.is_double then
      local otherDoorMeta = minetest.get_meta(door_info.other_door.pos)
      otherDoorMeta:set_string("lock", button_clicked.name)
   end

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
      local access_group = minetest.get_item_group(node_name, "id_locked")
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
      
      local inv = meta:get_inventory()
      inv:set_size("target_id", 1)
      inv:set_size("user_id", 1)
      
      meta:set_string("formspec", computer_idcard_build_formspec(inv))
   end,
   on_destruct = function(pos)
      local meta = minetest.get_meta(pos)
      local inv = meta:get_inventory()

      local function dropId(inv_location)
         if not inv:is_empty(inv_location) then
            minetest.item_drop(inv:get_stack(inv_location, 1), nil, pos)
         end
      end
      dropId("target_id")
      dropId("user_id")
      
   end,
   allow_metadata_inventory_put = function(pos, listname, index, stack, player)
      if minetest.get_item_group(stack:get_name(), "id_card") >= 1 then
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
      if minetest.get_item_group(target_id_stack:get_name(), "id_card") < 1 then
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

sfinv.register_page("spacestation:container", {
   title = "Containers",
   get = function(self, player, context)
      local containers = {}
      local player_inv = player:get_inventory()
      local function make_grid(inventory, inventory_location, list)
         local inv_size = inventory:get_size(list)
         local width = inv_size
         local height = 1
         if inv_size > 8 then
            width = 8
            height = (inv_size + 7) / 8
         end
         table.insert(containers, { 
            "list", width, height, inventory_location, list 
         })
      end
      local function make_container_function(list, index, list_inv)
         return function()
            local stack = player_inv:get_stack(list, index)
            if not stack:is_empty() then
               make_grid(player_inv, "current_player", list_inv)
            end
         end
      end

      local make_lefthand  = make_container_function("main",    1, "lefthand_contents")
      local make_righthand = make_container_function("main",    2, "righthand_contents")
      local make_backpack = make_container_function("backpack", 1, "backpack_contents")
      
      make_lefthand()
      make_righthand()
      make_backpack()
      
      local y = 0
      local formspec = ""
      for i,v in ipairs(containers) do
         local width = v[2]
         local height = v[3]
         local location = v[4]
         local list = v[5]
         local cmp = string.format("list[%s;%s;0,%d;%d,%d;]", location, list, y, width, height)
         formspec = formspec .. cmp
         y = y + 1
      end
      return sfinv.make_formspec(player, context, formspec, true)
   end,
})

minetest.register_on_joinplayer(function(player)
   local isCreative = minetest.is_creative_enabled(player:get_player_name())
   local inv = player:get_inventory()
   inv:set_size("idcard", 1)
   inv:set_size("backpack", 1)
   if isCreative then
      inv:set_size("main", 8 * 4)
   else
      inv:set_size("main", 2)
   end
end)

minetest.register_allow_player_inventory_action(function(player, action, inventory, inventory_info)
   local liststring = nil
   local itemType = nil
   if action == 'move' then
      local stack = inventory:get_stack(inventory_info.from_list, inventory_info.from_index)
      liststring = inventory_info.to_list
      itemType = stack:get_name()
   elseif action == 'put' then
      liststring = inventory_info.liststring
      itemType = inventory_info.stack:get_name()
   end

   if liststring == 'idcard' then
      if minetest.get_item_group(itemType, "id_card") >= 1 then
         return 1
      else
         return 0
      end
   elseif liststring == 'backpack' then
      if minetest.get_item_group(itemType, "backpack") >= 1 then
         return 1
      else
         return 0
      end
   end
   return nil 

end)

-- list -> name of storage inventory
-- source_list -> inventory name of slot
-- source_index -> inventory index of slot
local function create_storage_inventory(list, source_list, source_index)
   local function container_open(inventory, container_stack)
      --print(string.format("Open: %s", list))
      local default_size = minetest.get_item_group(container_stack:get_name(), 
                                                   "storage_size")
      local container_metadata = container_stack:get_meta()
      local inv_string = container_metadata:get_string("inv")
      inv_serializer.deserialize(inv_string, inventory, list, default_size)
   end
   local function container_save(inventory)
      --print(string.format("Save: %s", list))
      local container_stack = inventory:get_stack(source_list, source_index)
      local is_storage = minetest.get_item_group(container_stack:get_name(), "storage_size") >= 1
      if is_storage then
         local container_metadata = container_stack:get_meta()
         local inv_string = inv_serializer.serialize(inventory, list)
         container_metadata:set_string("inv", inv_string)
         inventory:set_stack(source_list, source_index, container_stack)
      end
   end
   local function container_close(inventory)
      --print(string.format("Close: %s", list))
      inventory:set_size(list, 0)
   end
   
   minetest.register_allow_player_inventory_action(function(player, action, inventory, inventory_info)
      if action == 'move' then
         if inventory_info.to_list == list and
            inventory_info.from_list == source_list and  
            inventory_info.from_index == source_index then
            return 0 -- Don't put the container into its self
         end
      end
      return nil
   end)

   minetest.register_on_player_inventory_action(function(player, action, inventory, inventory_info)
      local redraw = false
      if action == 'move' then
         local stack = inventory:get_stack(inventory_info.to_list, 
                                           inventory_info.to_index)
         local is_storage = minetest.get_item_group(stack:get_name(), "storage_size") >= 1
         
         if inventory_info.from_list  == source_list and 
            inventory_info.from_index == source_index and
            is_storage then
            container_close(inventory)
            redraw = true
         end
         if inventory_info.to_list  == source_list and 
            inventory_info.to_index == source_index and
            is_storage then
            container_open(inventory, stack)
            redraw = true
         end
         if inventory_info.to_list   == list or
            inventory_info.from_list == list then
            container_save(inventory)
         end
         
         
      elseif action == 'put' then
         local stack = inventory_info.stack
         local is_storage = minetest.get_item_group(stack:get_name(), "storage_size") >= 1
         if inventory_info.listname == source_list and
            inventory_info.index    == source_index and
            is_storage then
            container_open(inventory, stack)
            redraw = true
         elseif inventory_info.listname == list then
            container_save(inventory)
         end
      elseif action == 'take' then
         local stack = inventory_info.stack
         local is_storage = minetest.get_item_group(stack:get_name(), "storage_size") >= 1
         if inventory_info.listname == source_list and 
            inventory_info.index    == source_index and
            is_storage then
            container_close(inventory)
            redraw = true
         elseif inventory_info.listname == list then
            container_save(inventory)
         end
      end
      
      if redraw then
         sfinv.set_player_inventory_formspec(player)
      end

   end)
end

create_storage_inventory("backpack_contents",  "backpack", 1)
create_storage_inventory("lefthand_contents",  "main", 1)
create_storage_inventory("righthand_contents", "main", 2)

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


