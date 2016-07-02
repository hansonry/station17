

--crowbar
minetest.register_tool("ss13_construction:crowbar", {
    description = "Crowbar",
    inventory_image = "ss13_construction_crowbar.png",
    tool_capabilities = {
            full_punch_interval = 1.0,
            max_drop_level=1,
            groupcaps={
                pryable={times={[1]=0.40}, maxwear=0, maxlevel=1},
            },
    }
})
