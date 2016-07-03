minetest.register_on_newplayer(function(player)
	print("[station17] giving initial stuff to player")

        player:get_inventory():add_item('main', 'ss13_construction:crowbar')
        player:get_inventory():add_item('main', 'ss13_construction:lattice 800')
	player:get_inventory():add_item('main', 'ss13_construction:floor_tile 400')
	player:get_inventory():add_item('main', 'ss13_construction:wall_tile 400')
        

	player:get_inventory():add_item('main', 'spacestation:light 64')
	player:get_inventory():add_item('main', 'spacestation:door 64')
        player:get_inventory():add_item('main', 'ss13_construction:hull_plating 100')
	
        player:get_inventory():add_item('main', 'default:pick_wood')
	player:get_inventory():add_item('main', 'default:pick_steel')
	player:get_inventory():add_item('main', 'default:pick_mese')
	player:get_inventory():add_item('main', 'default:mese 99')
end)

