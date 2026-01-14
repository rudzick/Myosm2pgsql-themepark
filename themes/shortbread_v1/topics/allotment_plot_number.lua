-- ---------------------------------------------------------------------------
--
-- Theme: shortbread_v1
-- Topic: allotment_plot_number
--
-- ---------------------------------------------------------------------------

local themepark, theme, cfg = ...

themepark:add_table{
    name = 'allotment_plot_number',
    ids_type = 'any',
    geom = 'point',
    columns = themepark:columns({
        { column = 'tags', type = 'jsonb' },
    }),
    tags = { },
    tiles = {
        minzoom = 16,
    },
}

-- ---------------------------------------------------------------------------

themepark:add_proc('way', function(object, data)

    if not object.is_closed then
        return
    end

    local a = object
    if a and a.tags.allotments and a.tags.allotments == 'plot' then
        a.geom = object:as_polygon():pole_of_inaccessibility()
        themepark:insert('allotment_plot_number', a, object.tags)
    end
end)

-- ---------------------------------------------------------------------------
