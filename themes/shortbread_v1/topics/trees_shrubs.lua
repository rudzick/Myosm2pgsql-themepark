-- ---------------------------------------------------------------------------
--
-- Theme: shortbread_v1
-- Topic: trees_shrubs.lua
--
-- ---------------------------------------------------------------------------

local themepark, theme, cfg = ...

themepark:add_table{
    name = 'trees',
    ids_type = 'any',
    geom = 'point',
    columns = themepark:columns({
        { column = 'tags', type = 'jsonb' },
    })
}

themepark:add_table{
    name = 'shrubs',
    ids_type = 'node',
    geom = 'point',
    columns = themepark:columns({
        { column = 'tags', type = 'jsonb' },
    })
}

-- --------------------------------------------------------------------------

themepark:add_proc('node', function(object, data)

    if not object.tags.natural  then
        return
    end

    if object.tags.natural == 'tree' then
       
       themepark:insert('trees', {
			   geom = object:as_point(),
			   tags = object.tags
				 }
       )
    elseif object.tags.natural == 'shrub' then
       themepark:insert('shrubs', {
			   geom = object:as_point(),
			   tags = object.tags
				  }
       )
    end
end)

