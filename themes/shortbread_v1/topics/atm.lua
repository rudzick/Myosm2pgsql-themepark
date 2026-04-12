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
        { column = 'piageom', type = 'point' },
    })
}

-- ---------------------------------------------------------------------------

themepark:add_proc('node', function(object, data)

    if ( object.tags.amenity == 'atm' ) or ( object.tags.atm and ( object.tags.atm ~= 'no' or object.tags.atm ~= 'unknown' )) then

       local a = object
       local atm_geom =  object:as_point()

       themepark:insert('atm', {
		geom = atm_geom,
		tags = object.tags,
		     }
		)    
    end		
end)

themepark:add_proc('way', function(object, data)

    if not object.is_closed or object.tags.atm ~= 'yes' then
        return
    end

    local a = object
    local a_geom = object:as_polygon()
    local pia_geom = object:as_polygon():pole_of_inaccessibility()
    
    if a then
         themepark:insert('atm_polygons', {
	 	geom = a_geom,
		tags= object.tags,
		piageom = pia_geom
		}
		)
    end

end)

-- ---------------------------------------------------------------------------
