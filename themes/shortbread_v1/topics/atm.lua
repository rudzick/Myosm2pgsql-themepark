-- ---------------------------------------------------------------------------
--
-- Theme: shortbread_v1
-- Topic: allotment_garden_name
--
-- ---------------------------------------------------------------------------

local themepark, theme, cfg = ...

themepark:add_table{
    name = 'atm',
    ids_type = 'any',
    geom = 'point',
    columns = themepark:columns({
        { column = 'tags', type = 'jsonb' },
        { column = 'isatm', type = 'bool' },
    }),
    tags = { },
    tiles = {
        minzoom = 13,
    },
}

themepark:add_table{
    name = 'atm_polygons',
    ids_type = 'way',
    geom = 'polygon',
    columns = themepark:columns({
        { column = 'tags', type = 'jsonb' },
    })
}

-- ---------------------------------------------------------------------------

themepark:add_proc('node', function(object, data)

    if not object.tags.amenity ~= 'atm' then
        return
    end

    local a = object
    local atm_geom =  object:as_point()

    themepark:insert('atm', {
                  geom = atm_geom,
		  tags = object.tags,
		  isatm = true,
		 }
		)

end)

themepark:add_proc('way', function(object, data)

    if not object.is_closed or object.tags.atm ~= 'yes' then
        return
    end

    local a = object

    if a then
        a.geom = object:as_polygon(),
        themepark:insert('atm_polygon', a, object.tags)
    end

end)

-- ---------------------------------------------------------------------------
