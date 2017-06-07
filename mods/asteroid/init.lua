-- Parameters

local YMIN = 900
local YMAX = 62900
local XMIN = -31000
local XMAX = 31000
local ZMIN = -31000
local ZMAX = 31000

local ASCOT = 0.70 -- Asteroid / comet nucleus noise threshold.
local STOT = 0.125 -- Asteroid stone threshold.
local COBT = 0.05 -- Asteroid cobble threshold.
local GRAT = 0.02 -- Asteroid gravel threshold.
local ICET = 0.05 -- Comet ice threshold.
local ATMOT = 0 -- Comet atmosphere threshold.
local FISTS = 0.01 -- Fissure noise threshold at surface. Controls size of fissures
					-- and amount / size of fissure entrances at surface.
local FISEXP = 0.3 -- Fissure expansion rate under surface.
local ORECHA = 3 * 3 * 3 -- Ore 1/x chance per stone node.

local CPCHU = 8 -- Maximum craters per chunk.
local CRMIN = 4 -- Crater radius minimum, radius includes dust and obsidian layers.
local CRRAN = 8 -- Crater radius range.

local SPAJ = 1 -- Space jump (1 = normal)
local SPAG = 0.1 -- Space gravity (1 = normal)

local DEBUG = false

-- 3D Perlin noise for large structures

local np_large = {
	offset = 0,
	scale = 1,
	spread = {x = 50, y = 50, z = 50},
	seed = -83928935,
	octaves = 4,
	persist = 0.6,
	lacunarity = 2.0,
	--flags = ""
}

-- 3D Perlin noise for fissures

local np_fissure = {
	offset = 0,
	scale = 1,
	spread = {x = 64, y = 64, z = 64},
	seed = -188881,
	octaves = 3,
	persist = 0.5,
	lacunarity = 2.0,
	--flags = ""
}

-- 3D Perlin noise for ore selection

local np_ores = {
	offset = 0,
	scale = 1,
	spread = {x = 128, y = 128, z = 128},
	seed = -70242,
	octaves = 1,
	persist = 0.5,
	lacunarity = 2.0,
	--flags = ""
}

-- 3D Perlin noise for comet atmosphere

local np_atmos = {
	offset = 0,
	scale = 1,
	spread = {x = 192, y = 192, z = 192},
	seed = -83928935,
	octaves = 3,
	persist = 0.6,
	lacunarity = 2.0,
	flags = "eased"
}


-- Do files

dofile(minetest.get_modpath("asteroid").."/nodes.lua")


-- Constants

local c_air = minetest.CONTENT_AIR
	
local c_stone = minetest.get_content_id("asteroid:stone")
local c_cobble = minetest.get_content_id("asteroid:cobble")
local c_gravel = minetest.get_content_id("asteroid:gravel")
local c_dust = minetest.get_content_id("asteroid:dust")
local c_ironore = minetest.get_content_id("asteroid:ironore")
local c_copperore = minetest.get_content_id("asteroid:copperore")
local c_goldore = minetest.get_content_id("asteroid:goldore")
local c_diamondore = minetest.get_content_id("asteroid:diamondore")
local c_meseore = minetest.get_content_id("asteroid:meseore")
local c_waterice = minetest.get_content_id("asteroid:waterice")
local c_atmos = c_air -- minetest.get_content_id("asteroid:atmos")
local c_snowblock = minetest.get_content_id("asteroid:snowblock")


-- On dignode function. Atmosphere flows into a dug hole.

--[[

minetest.register_on_dignode(function(pos, oldnode, digger)
	local x = pos.x
	local y = pos.y
	local z = pos.z

	for i = -1, 1 do
	for j = -1, 1 do
	for k = -1, 1 do
		if not (i == 0 and j == 0 and k == 0) then
			local nodename = minetest.get_node({x = x + i, y = y + j, z = z + k}).name
			if nodename == "asteroid:atmos" then	
				minetest.add_node(pos, {name = "asteroid:atmos"})
				return
			end
		end
	end
	end
	end
end)
]]--

-- Globalstep function for skybox, physics override, light override

local skybox_space = {
	"asteroid_skybox_ypos.png",
	"asteroid_skybox.png",
	"asteroid_skybox.png",
	"asteroid_skybox.png",
	"asteroid_skybox.png",
	"asteroid_skybox.png"
}

minetest.register_globalstep(function(dtime)
	for _, player in ipairs(minetest.get_connected_players()) do
		if math.random() < 0.03 then -- set gravity, skybox and override light
			local ppos = player:getpos()
			if ppos.y < YMIN or ppos.y > YMAX then -- normal
				player:set_physics_override(1, 1, 1) -- speed, jump, gravity
				player:set_sky({}, "regular", {})
				player:override_day_night_ratio(nil)
			else -- space
				player:set_physics_override(1, SPAJ, SPAG) -- speed, jump, gravity
				player:set_sky({r = 0, g = 0, b = 0, a = 0}, "skybox", skybox_space)
				player:override_day_night_ratio(1)
			end
		end
	end
end)


-- Initialise noise objects to nil

local nobj_large = nil
local nobj_fissure = nil
local nobj_ores = nil
local nobj_atmos = nil


-- Localise noise buffers

local nbuf_large
local nbuf_fissure
local nbuf_ores
local nbuf_atmos


-- On generated function

if DEBUG then
	print ("[asteroid] This happend!!")
end

minetest.register_on_generated(function(minp, maxp, seed)
	if DEBUG then
		print ("[asteroid] min x: " .. minp.x .. " y: " .. minp.y .. " z: " .. minp.z)
		print ("[asteroid] max x: " .. maxp.x .. " y: " .. maxp.y .. " z: " .. maxp.z)
	end
	if minp.x < XMIN or maxp.x > XMAX
			or minp.y < YMIN or maxp.y > YMAX
			or minp.z < ZMIN or maxp.z > ZMAX then
		return
	end

	if DEBUG then
		print ("[asteroid] Here")
	end

	local t1 = os.clock()

	local x1 = maxp.x
	local y1 = maxp.y
	local z1 = maxp.z
	local x0 = minp.x
	local y0 = minp.y
	local z0 = minp.z

	local sidelen = x1 - x0 + 1
	local chulens = {x = sidelen, y = sidelen, z = sidelen}
	local minpos = {x = x0, y = y0, z = z0}
	
	nobj_large   = nobj_large   or minetest.get_perlin_map(np_large,   chulens)
	nobj_fissure = nobj_fissure or minetest.get_perlin_map(np_fissure, chulens)
	nobj_ores    = nobj_ores    or minetest.get_perlin_map(np_ores,    chulens)
	nobj_atmos   = nobj_atmos   or minetest.get_perlin_map(np_atmos,   chulens)
	
	local nvals_large   = nobj_large  :get3dMap_flat(minpos, nbuf_large)
	local nvals_fissure = nobj_fissure:get3dMap_flat(minpos, nbuf_fissure)
	local nvals_ores    = nobj_ores   :get3dMap_flat(minpos, nbuf_ores)
	local nvals_atmos   = nobj_atmos  :get3dMap_flat(minpos, nbuf_atmos)

	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local area = VoxelArea:new{MinEdge = emin, MaxEdge = emax}
	local data = vm:get_data()
	
	local ni = 1
	for z = z0, z1 do
	for y = y0, y1 do
		local vi = area:index(x0, y, z)
		for x = x0, x1 do
			local n_large = nvals_large[ni]
			local nabs_large = math.abs(n_large)
			local atmos = (nvals_atmos[ni]) < -(ASCOT + ATMOT) -- comet atmosphere volume

			if nabs_large > ASCOT then -- if below surface
				local comet = n_large < -ASCOT
				local nlargedep = nabs_large - ASCOT -- zero at surface, positive beneath
				if math.abs(nvals_fissure[ni]) > FISTS + nlargedep * FISEXP then
					-- no fissure
					if not comet or
							(comet and nlargedep > (math.random() / 2) + ICET) then
						-- asteroid or asteroid materials in comet
						if nlargedep >= STOT then
							-- stone/ores
							local n_ores = nvals_ores[ni]
							if math.random(ORECHA) == 2 then
								if n_ores > 0.6 then
									data[vi] = c_goldore
								elseif n_ores < -0.6 then
									data[vi] = c_diamondore
								elseif n_ores > 0.2 then
									data[vi] = c_meseore
								elseif n_ores < -0.2 then
									data[vi] = c_copperore
								else
									data[vi] = c_ironore
								end
							else
								data[vi] = c_stone
							end
						elseif nlargedep >= COBT then
							data[vi] = c_cobble
						elseif nlargedep >= GRAT then
							data[vi] = c_gravel
						else
							data[vi] = c_dust
						end
					else -- comet materials
						if nlargedep >= ICET then
							data[vi] = c_waterice
						else
							data[vi] = c_snowblock
						end
					end
				elseif atmos then -- fissures, if comet then add comet atmosphere
					data[vi] = c_atmos
				end
			elseif atmos then -- if comet atmosphere then
				data[vi] = c_atmos
			end

			ni = ni + 1
			vi = vi + 1
		end
	end
	end
	-- craters
	for ci = 1, CPCHU do -- iterate
		local cr = math.floor(CRMIN + math.random() ^ 2 * CRRAN) -- exponential radius
		local cx = math.random(x0 + cr, x1 - cr) -- centre x
		local cz = math.random(z0 + cr, z1 - cr) -- centre z
		local comet = false
		local surfy = false
		local count = 0

		for y = y1, y0 + cr, -1 do
			local vi = area:index(cx, y, cz)
			local nodeid = data[vi]
			if nodeid == c_air or nodeid == c_atmos then
				count = count + 1
			elseif count > cr and (nodeid == c_dust
					or nodeid == c_gravel
					or nodeid == c_cobble) then
				surfy = y
				break
			elseif count > cr and (nodeid == c_snowblock
					or nodeid == c_waterice) then
				comet = true
				surfy = y
				break
			else
				count = 0
			end
		end

		if surfy then
			for x = cx - cr, cx + cr do
			for z = cz - cr, cz + cr do
			for y = surfy - cr, surfy + cr do
				local vi = area:index(x, y, z)
				local nr = ((x - cx) ^ 2 + (y - surfy) ^ 2 + (z - cz) ^ 2) ^ 0.5
				if nr < cr - 1 then
					local nodeid = data[vi]
					if nodeid ~= c_atmos
							and nodeid ~= c_air then
						if comet then
							data[vi] = c_atmos
						else
							data[vi] = c_air
						end
					end
				elseif nr < cr then
					local nodeid = data[vi]
					if nodeid ~= c_atmos
							and nodeid ~= c_air then
						if comet then
							data[vi] = c_snowblock
						else
							data[vi] = c_dust
						end
					end
				end
			end
			end
			end
		end
	end

	vm:set_data(data)
	vm:set_lighting({day = 0, night = 0})
	vm:calc_lighting()
	vm:write_to_map(data)

	local chugent = math.ceil((os.clock() - t1) * 1000)
	if DEBUG then
		print ("[asteroid] chunk generation "..chugent.." ms")
	end
end)
