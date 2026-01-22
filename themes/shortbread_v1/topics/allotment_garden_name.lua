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
        minzoom = 15,
    },
}

-- ---------------------------------------------------------------------------

themepark:add_proc('way', function(object, data)

    if not object.is_closed then
        return
    end

    local a = object
    if a and a.tags.landuse and a.tags.landuse == 'allotments' then
        a.geom = object:as_polygon():pole_of_inaccessibility()
        themepark:insert('allotment_garden_name', a, object.tags)
    end
end)

-- ---------------------------------------------------------------------------
