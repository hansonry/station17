

-- Wire Networks

local electric_group_flags = { connector = 1, device = 2 }


local function is_pos_equal(p1, p2)
   return (p1.x == p2.x and
           p1.y == p2.y and
           p1.z == p2.z)
end

local function manhattan_distance(p1, p2)
   local dx = p1.x - p2.x
   local dy = p1.y - p2.y
   local dz = p1.z - p2.z
   return math.abs(dx) + math.abs(dy) + math.abs(dz)
end

local PowerNetwork = {}
function PowerNetwork:new(group, obj )
   obj = obj or {}
   obj.devices_pos = {}
   obj.bounds = nil
   obj.group = group
   setmetatable(obj, self)
   return obj
end


function PowerNetwork:add(pos)
   table.insert(self.devices_pos, pos)
end

function PowerNetwork:get_index(pos)
   for i, v in ipairs(self.devices_pos) do
      if is_pos_equal(v, pos) then
         return i
      end
   end
   return nil
end

function PowerNetwork:remove(pos)
   local index = self:get_index(pos)
   if index == nil then
      return false
   else
      table.remove(self.devices_pos, index)
      return true
   end
end

function PowerNetwork:is_continuous()
   for i1, pos1 in ipairs(self.devices_pos) do
      local minDist = nil
      for i2=i1,#self.devices_pos do
         local pos2 = self.devices_pos[i2]
         local dist = manhattan_distance(pos1, pos2)
         if minDist == nil or minDist > dist then 
            minDist = dist 
         end          
      end
      if minDist > 1 then
         return false
      end
   end
   return true
end

function PowerNetwork:join(other_network)
   if other_network.group == self.group then
      for i, pos in ipairs(other_network.devices_pos) do
         table.insert(self.devices_pos, pos)
      end
   -- TODO: Update stats
   else
      minetest.log("error", "Attempted to join networks of different groups")
   end
end


function PowerNetwork:has_pos(pos)
   if self:get_index(pos) == nil then
      return false
   else
      return true
   end
end


local powernets = {}
powernets.networks = {}
function powernets.add(pos, group)
   local function generate_neighbors(pos)
      return {
         { pos.x + 1, pos.y,     pos.z     },
         { pos.x - 1, pos.y,     pos.z     },
         { pos.x,     pos.y + 1, pos.z     },
         { pos.x,     pos.y - 1, pos.z     },
         { pos.x,     pos.y,     pos.z + 1 },
         { pos.x,     pos.y,     pos.z - 1 },
      }
   end
   
   local function generate_nextto_neighbors(pos, group)
      local nextto_neighbors = {}
      local neighbors = generate_neighbors(pos)
      
      for i,neighbor_pos in ipairs(neighbors) do
         local node = minetest.get_node(neighbor_pos)
         local group = minetest.get_node_group(node.name)
         if group > 0 then
            table.insert(nextto_neighbors, neighbor_pos)
         end         
      end
      return nextto_neighbors
   end
   --local node = minetest.get_node(pos)
   local nextto_neighbors = generate_nextto_neighbors(pos, group)
   local network = nil
   if #nextto_neighbors > 0 then
      local neighbor_pos = table.remove(nextto_neighbors)
      network = powernets.get_network(neighbor_pos, group)
      if network == nil then
         minetest.log("error", "Failed to find network for existing wire")
         network = PowerNetwork:new(group)
         network:add(pos)
         network:add(neighbor_pos)
         table.insert(powernets.networks, network);
      else
         network:add(pos)
      end
      for i, neighbor_pos in ipairs(nextto_neighbors) do
         local nextto_network = powernets.get_network(neighbor_pos, group)
         network:join(nextto_network)
      end
   else
      network = PowerNetwork:new(group)
      network:add(pos)
      table.insert(powernets.networks, network);
   end
   -- TODO: update network stats maybe?
   
   return network
end

function powernets.remove(pos, refactor)
   if refactor == nil then refactor = true end
   for i, network in ipairs(powernets.networks) do
      if network:remove(pos) then
         if refactor then
            powernets.split_refactor()
         end
         return true
      end
   end
   return false
end

function powernets.split_refactor()
   -- Find and remove split networks
   local spit_networks = {}
   for i = #powernets.networks,1,-1 do
      local network = powernets.networks[i]
      if not network:is_continuous() then
         table.remove(powernets.networks, i)
         table.insert(spit_networks, network)
      end
   end
   
   -- Split all the networks that need it
   for i, split_network in ipairs(spit_networks) do
      -- TODO: Split everything.....
   end
end

function powernets.get_network(pos, group)
   for i, network in ipairs(powernets.networks) do
      if (group == nil or network.group == group) and network:has_pos(pos) then
         return network
      end
   end
   return nil
end

-- Blocks

minetest.register_craftitem("spacestation:multitool", {
   description = "Multitool",
   inventory_image = "spacestation_tool_multitool.png",
   stack_max = 1
})

minetest.register_node("spacestation:apc", {
	description = "Area Power Controller (APC)",
   drawtype = "signlike",
   tiles = {"spacestation_apc.png"},
	paramtype = "light",
	paramtype2 = "wallmounted",
   sunlight_propagates = true,
   walkable = false,
	groups = {cracky=3},
	sounds = default.node_sound_metal_defaults(),
   selection_box = {
		type = "wallmounted",
	},
})

local node_size = 0.5
local function MakeWireBoxes(node_size, wire_percent)
   local boxes = {}
   local unit = node_size * wire_percent
   local u = unit
   local n = node_size
   boxes.center  = { -u, -u, -u,  u,  u,  u }
   boxes.top     = { -u,  u, -u,  u,  n,  u }
   boxes.bottom  = { -u, -n, -u,  u, -u,  u }
   boxes.left    = { -n, -u, -u, -u,  u,  u }
   boxes.right   = {  u, -u, -u,  n,  u,  u }
   boxes.front   = { -u, -u, -n,  u,  u, -u }
   boxes.back    = { -u, -u,  u,  u,  u,  n }
   return boxes
end

local wire_boxes = MakeWireBoxes(node_size, 0.25);

minetest.register_node("spacestation:wirelv", {
	description = "Low Voltage Wire",
   drawtype = "nodebox",
	node_box = {
		type = "connected",
		fixed = {
			wire_boxes.center
		},
      connect_top    = wire_boxes.top, 
      connect_bottom = wire_boxes.bottom,
      connect_left   = wire_boxes.left,
      connect_right  = wire_boxes.right,
      connect_front  = wire_boxes.front,
      connect_back   = wire_boxes.back
	},
   connects_to = { "group:wirelv" },
   paramtype = "light",
   tiles = {"spacestation_uvgrid.png"},
   sunlight_propagates = true,
	groups = {cracky = 3, wirelv = electric_group_flags.connector },
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("spacestation:electricsource", {
	description = "Space Station Power Source (Testing)",
	tiles = {"spacestation_electric_source.png"},
   groups = {
      cracky = 3, 
      wirelv = electric_group_flags.device, 
      wiremv = electric_group_flags.device, 
      wirehv = electric_group_flags.device
   },
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("spacestation:electricload", {
	description = "Space Station Power Load (Testing)",
	tiles = {"spacestation_electric_load.png"},
	groups = {
      cracky = 3, 
      wirelv = electric_group_flags.device, 
      wiremv = electric_group_flags.device, 
      wirehv = electric_group_flags.device
   },
	sounds = default.node_sound_wood_defaults(),
})

