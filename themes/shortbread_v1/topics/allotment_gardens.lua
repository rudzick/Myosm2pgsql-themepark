-- ---------------------------------------------------------------------------
--
-- Theme: shortbread_v1
-- Topic: allotment_garden_name
--
-- ---------------------------------------------------------------------------

local themepark, theme, cfg = ...

themepark:add_table{
    name = 'allotment_garden_name',
    ids_type = 'any',
    geom = 'point',
    columns = themepark:columns({
        { column = 'tags', type = 'jsonb' },
    }),
    tags = { },
    tiles = {
        minzoom = 13,
    },
}

themepark:add_table{
    name = 'allotment_gardens',
    ids_type = 'way',
    geom = 'polygon',
    columns = themepark:columns({
        { column = 'tags', type = 'jsonb' },
    })
}

-- ---------------------------------------------------------------------------

themepark:add_proc('way', function(object, data)

    if not object.is_closed or object.tags.landuse ~= 'allotments' then
        return
    end

    local a = object
    local allotment_gardens_geom =  object:as_polygon()

    themepark:insert('allotment_gardens', {
                  geom = allotment_gardens_geom,
		  tags = object.tags
		 }
		)

    if a then
        a.geom = allotment_gardens_geom:pole_of_inaccessibility()
        themepark:insert('allotment_garden_name', a, object.tags)
    end

end)

-- ---------------------------------------------------------------------------
