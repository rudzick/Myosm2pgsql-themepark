-- ---------------------------------------------------------------------------
--
-- Theme: shortbread_v1
-- Topic: allotment_plot_number
--
-- ---------------------------------------------------------------------------

local themepark, theme, cfg = ...

themepark:add_table{
    name = 'allotment_plot_number',
    ids_type = 'node',
    geom = 'point',
    columns = themepark:columns({
        { column = 'tags', type = 'jsonb' },
    })
}

themepark:add_table{
    name = 'entrances',
    ids_type = 'node',
    geom = 'point',
    columns = themepark:columns({
        { column = 'tags', type = 'jsonb' },
    })
}

themepark:add_table{
    name = 'allotment_plots',
    ids_type = 'way',
    geom = 'polygon',
    columns = themepark:columns({
        { column = 'tags', type = 'jsonb' },
    })
}

-- --------------------------------------------------------------------------

local function reftail(s)
      return string.gsub(s,"^.*/", "")
end

-- --------------------------------------------------------------------------

themepark:add_proc('node', function(object, data)

    if not object.tags.entrance  then
        return
    end

    themepark:insert('entrances', {
                  geom = object:as_point(),
		  tags = object.tags
		 }
		)

-- ---------------------------------------------------------------------------

themepark:add_proc('way', function(object, data)

    if not object.is_closed or object.tags.allotments ~= 'plot'  then
        return
    end

    local a = object
    local plot_geom =  object:as_polygon()

    themepark:insert('allotment_plot', {
                  geom = plot_geom,
		  tags = object.tags
		 }
		)

    if a.tags.ref then
        a.geom = plot_geom:pole_of_inaccessibility()
	object.tags.reftail = reftail(object.tags.ref)
        themepark:insert('allotment_plot_number', a, object.tags)
    end
end)

-- ---------------------------------------------------------------------------
