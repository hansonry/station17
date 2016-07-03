--Implements the basic tools and materials for SS13 like construction

ss13_construction = {}

--storage of nodebox information
ss13_construction.nodeboxes = {}

dofile(minetest.get_modpath("ss13_construction").."/lattice_code.lua")

dofile(minetest.get_modpath("ss13_construction").."/tools.lua")
