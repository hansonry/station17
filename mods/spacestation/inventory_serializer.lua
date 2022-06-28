local function inventory_to_string(inv, list)
   local size = inv:get_size(list)
   local data = {
      size = size,
      stacks = {}
   }
   for index = 1,size do
      local stack = inv:get_stack(list, index)
      if not stack:is_empty() then
         local stack_info = {
            index = index,
            name = stack:get_name(),
            count = stack:get_count(),
            wear  = stack:get_wear(),
            meta_table = stack:get_meta():to_table()
         }
         table.insert(data.stacks, stack_info)
      end
   end
   return minetest.serialize(data)
end

local function string_to_inventory(str, inv, list, default_size)
   default_size = default_size or 8
   local data = nil
   local new_container = str == ""
   if new_container then
      data = {
         size = default_size,
         stacks = {}
      }
   else
      data = minetest.deserialize(str)
   end
   inv:set_size(list, 0) -- clear list
   inv:set_size(list, data.size)
   for _,stack_info in ipairs(data.stacks) do
      local stack = ItemStack(stack_info.name)
      stack:set_count(stack_info.count)
      stack:set_wear(stack_info.wear)
      local metadata = stack:get_meta()
      metadata:from_table(stack_info.meta_table)
      inv:set_stack(list, stack_info.index, stack)
   end
   return new_container
end

return {
   serialize   = inventory_to_string,
   deserialize = string_to_inventory
}

