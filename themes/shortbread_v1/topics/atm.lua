-- ---------------------------------------------------------------------------
--
-- Theme: shortbread_v1
-- Topic: ATM
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
        minzoom = 9,
    },
}

themepark:add_table{
    name = 'atm_polygons',
    ids_type = 'way',
    geom = 'polygon',
    columns = themepark:columns({
        { column = 'tags', type = 'jsonb' },
        { column = 'piageom', type = 'point' },
    }),
    tags = { },
    tiles = {
    minzoom = 9,
	},
}
themepark:add_table{
    name = 'cash_withdrawal',
    ids_type = 'any',
    geom = 'point',
    columns = themepark:columns({
        { column = 'tags', type = 'jsonb' },
    }),
    tags = { },
    tiles = {
        minzoom = 9,
    },
}

themepark:add_table{
    name = 'cash_withdrawal_polygons',
    ids_type = 'way',
    geom = 'polygon',
    columns = themepark:columns({
        { column = 'tags', type = 'jsonb' },
        { column = 'piageom', type = 'point' },
    }),
    tags = { },
    tiles = {
    minzoom = 9,
	},
}

-- ---------------------------------------------------------------------------

themepark:add_proc('node', function(object, data)

    if ( object.tags.amenity == 'atm' ) or ( object.tags.atm and not ( object.tags.atm == 'no' or object.tags.atm == 'unknown' )) then

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

    if not object.is_closed or not object.tags.atm then
        return
    end

    if object.tags.atm == 'no' or object.tags.atm == 'unknown' then
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

themepark:add_proc('node', function(object, data)

    if ( object.tags.cash_withdrawal and not ( object.tags.cash_withdrawal == 'no' or object.tags.cash_withdrawal == 'unknown' ) ) then

       local a = object
       local cash_withdrawal_geom =  object:as_point()

       themepark:insert('cash_withdrawal', {
		geom = cash_withdrawal_geom,
		tags = object.tags,
		     }
		)    
    end		
end)

themepark:add_proc('way', function(object, data)

    if not object.is_closed or not object.tags.cash_withdrawal  then
        return
    end

    if object.tags.cash_withdrawal == 'no' or object.tags.cash_withdrawal == 'unknown' then
       return
    end

    local a = object
    local a_geom = object:as_polygon()
    local pia_geom = object:as_polygon():pole_of_inaccessibility()
    
    if a then
         themepark:insert('cash_withdrawal_polygons', {
	 	geom = a_geom,
		tags= object.tags,
		piageom = pia_geom
		}
		)
    end

end)

-- ---------------------------------------------------------------------------
