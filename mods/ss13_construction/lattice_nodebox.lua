ss13_construction.nodeboxes.lattice_nodebox = {}
ss13_construction.nodeboxes.floor_ceiling_nodebox = {}

local lattice = ss13_construction.nodeboxes.lattice_nodebox
local floor_ceiling = ss13_construction.nodeboxes.floor_ceiling_nodebox

------------------------
--Basic Lattice Fixture
------------------------
lattice.type = "connected"

lattice.fixed = { --12 rods welded together
    -- long in the x direction
    { -.3, -.3, -.3,  .3, -.2, -.2 },
    { -.3,  .3,  .3,  .3,  .2,  .2 },
    { -.3, -.3,  .3,  .3, -.2,  .2 },
    { -.3,  .3, -.3,  .3,  .2, -.2 },

    --long in the y direction
    { -.3, -.3, -.3, -.2,  .3, -.2 },
    {  .3, -.3,  .3,  .2,  .3,  .2 },
    { -.3, -.3,  .3, -.2,  .3,  .2 },
    {  .3, -.3, -.3,  .2,  .3, -.2 },

    --long in the z direction
    { -.3, -.3, -.3, -.2, -.2,  .3 },
    {  .3,  .3, -.3,  .2,  .2,  .3 },
    { -.3,  .3, -.3, -.2,  .2,  .3 },
    {  .3, -.3, -.3,  .2, -.2,  .3 },
}

---------------------------
-- Connected NodeBox Pieces
---------------------------

--Top connection
lattice.connect_top = {
    { -.3,  .5, -.3, -.2,  .3, -.2 },
    {  .3,  .5,  .3,  .2,  .3,  .2 },
    { -.3,  .5,  .3, -.2,  .3,  .2 },
    {  .3,  .5, -.3,  .2,  .3, -.2 },
}

--Bottom connection
lattice.connect_bottom = {
    { -.3, -.5, -.3, -.2, -.3, -.2 },
    {  .3, -.5,  .3,  .2, -.3,  .2 },
    { -.3, -.5,  .3, -.2, -.3,  .2 },
    {  .3, -.5, -.3,  .2, -.3, -.2 },
}

--Front connection
lattice.connect_front = {
    { -.3, -.3, -.5, -.2, -.2, -.3 },
    {  .3,  .3, -.5,  .2,  .2, -.3 },
    { -.3,  .3, -.5, -.2,  .2, -.3 },
    {  .3, -.3, -.5,  .2, -.2, -.3 },
}

--Back connection
lattice.connect_back = {
    { -.3, -.3,  .5, -.2, -.2,  .3 },
    {  .3,  .3,  .5,  .2,  .2,  .3 },
    { -.3,  .3,  .5, -.2,  .2,  .3 },
    {  .3, -.3,  .5,  .2, -.2,  .3 },
}

--Right connection
lattice.connect_right = {
    { .5, -.3, -.3,  .3, -.2, -.2 },
    { .5,  .3,  .3,  .3,  .2,  .2 },
    { .5, -.3,  .3,  .3, -.2,  .2 },
    { .5,  .3, -.3,  .3,  .2, -.2 }
}

--Left connection
lattice.connect_left = {
    { -.5, -.3, -.3,  -.3, -.2, -.2 },
    { -.5,  .3,  .3,  -.3,  .2,  .2 },
    { -.5, -.3,  .3,  -.3, -.2,  .2 },
    { -.5,  .3, -.3,  -.3,  .2, -.2 }
}

-----------------
--Floor/ceiling nodebox
-----------------
floor_ceiling.type = lattice.type

floor_ceiling.fixed = table.copy(lattice.fixed)

floor_ceiling.connect_front = lattice.connect_front
floor_ceiling.connect_back = lattice.connect_back
floor_ceiling.connect_right = lattice.connect_right
floor_ceiling.connect_left = lattice.connect_left

--add top and bottom plates to the floor/ceiling fixed nodebox
local top_plate = {-.5, .3, -.5, .5, .5, .5}
local bottom_plate = {-.5, -.3, -.5, .5, -.5, .5}

table.insert(floor_ceiling.fixed, top_plate)
table.insert(floor_ceiling.fixed, bottom_plate)

