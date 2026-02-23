-- ---------------------------------------------------------------------------
--
-- Theme: shortbread_v1
-- Topic: allotment_plot_number
--
-- ---------------------------------------------------------------------------

local themepark, theme, cfg = ...

themepark:add_table{
    name = 'barriers',
    ids_type = 'node',
    geom = 'point',
    columns = themepark:columns({
        { column = 'tags', type = 'jsonb' },
    })
}

themepark:add_table{
    name = 'hedges',
    ids_type = 'way',
    geom = 'linestring',
    columns = themepark:columns({
        { column = 'tags', type = 'jsonb' },
    })
}

-- --------------------------------------------------------------------------

themepark:add_proc('node', function(object, data)

    if not object.tags.barrier  then
        return
    end

    themepark:insert('barriers', {
                  geom = object:as_point(),
		  tags = object.tags
		 }
		)
		end)

-- ---------------------------------------------------------------------------

themepark:add_proc('way', function(object, data)

    if object.tags.barrier ~= 'hedge'  then
        return
    end

    local plot_geom =  object:as_linestring()

    themepark:insert('hedges', {
                  geom = plot_geom,
		  tags = object.tags
		 }
		)
		end)

-- ---------------------------------------------------------------------------
