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


return formspec_builder

