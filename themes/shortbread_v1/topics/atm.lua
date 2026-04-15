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

themepark:add_proc('node', function(object, data)
-- https://www.hanseaticbank.de/klarmacher/bezahlen/geld-abheben-im-supermarkt-so-funktioniert-cashback-bei-rewe-lidl-co#so
	if ( object.tags.cash_withdrawal or not object.tags.shop or object.tags.shop == 'no' or object.tags.shop == 'unknown' ) then
	   return
	end

	local a = object
	if object.tags.brand then
	   local brand = string.lower(object.tags.brand)
	else
	   local brand = ''
	end
	print("brand=",brand)
	if object.tags['brand:wikidata'] then
	   local brandwikidata = string.lower(object.tags['brand:wikidata'])
	else
	   local brandwikidata = ''
	end
	if object.tags.operator then
	   local operator = string.lower(object.tags.operator)
	else
	   local operator = ''
	end
	if object.tags['operator:wikidata'] then
	   local operatorwikidata = string.lower(object.tags['operator:wikidata'])
	else
	   local operatorwikidata = ''
	end
	local cash_withdrawal_geom =  object:as_point()
	
	-- EDEKA
	local company = 'edeka'
	local companywikidata = 'q701755'
	if ( brand == company or operator == company or brandwikidata == companywikidata or operatorwikidata == companywikidata ) then

	   object.tags.cash_withdrawal = 'implicit'
	   object.tags['cash_withdrawal:purchase_required'] = 'yes'
	   object.tags['cash_withdrawal:purchase_minimum'] = '20'
	   object.tags['cash_withdrawal:limit'] = '200'
	   
	   themepark:insert('cash_withdrawal', {
			       geom = cash_withdrawal_geom,
			       tags = object.tags,
					       }
	   )

	   return
	   
	end
	
	-- REWE
	local company = 'rewe'
	local companywikidata = 'q16968817'
	if ( brand == company or operator == company or brandwikidata == companywikidata or operatorwikidata == companywikidata ) then

	   object.tags.cash_withdrawal = 'implicit'
	   object.tags['cash_withdrawal:purchase_required'] = 'yes'
	   object.tags['cash_withdrawal:purchase_minimum'] = 'no'
	   object.tags['cash_withdrawal:limit'] = '200'
	   
	   themepark:insert('cash_withdrawal', {
			       geom = cash_withdrawal_geom,
			       tags = object.tags,
					       }
	   )

	   return
	   
	end
	
	-- ALDI Nord
	local company = 'aldi nord'
	local companywikidata = 'q41171373'
	if ( brand == company or operator == company or brandwikidata == companywikidata or operatorwikidata == companywikidata ) then

	   object.tags.cash_withdrawal = 'implicit'
	   object.tags['cash_withdrawal:purchase_required'] = 'yes'
	   object.tags['cash_withdrawal:purchase_minimum'] = '1'
	   object.tags['cash_withdrawal:limit'] = '200'
	   
	   themepark:insert('cash_withdrawal', {
			       geom = cash_withdrawal_geom,
			       tags = object.tags,
					       }
	   )

	   return
	   
	end
	
	-- ALDI Süd
	local company = 'aldi süd'
	local companywikidata = 'q41171672'
	if ( brand == company or operator == company or brandwikidata == companywikidata or operatorwikidata == companywikidata ) then

	   object.tags.cash_withdrawal = 'implicit'
	   object.tags['cash_withdrawal:purchase_required'] = 'yes'
	   object.tags['cash_withdrawal:purchase_minimum'] = '5'
	   object.tags['cash_withdrawal:limit'] = '200'
	   
	   themepark:insert('cash_withdrawal', {
			       geom = cash_withdrawal_geom,
			       tags = object.tags,
					       }
	   )

	   return
	   
	end
	
	-- ALDI
	local company = 'aldi'
	local companywikidata = 'q125054'
	if ( brand == company or operator == company or brandwikidata == companywikidata or operatorwikidata == companywikidata ) then

	   object.tags.cash_withdrawal = 'implicit'
	   object.tags['cash_withdrawal:purchase_required'] = 'yes'
	   object.tags['cash_withdrawal:limit'] = '200'
	   
	   themepark:insert('cash_withdrawal', {
			       geom = cash_withdrawal_geom,
			       tags = object.tags,
					       }
	   )

	   return
	   
	end
	
	-- DM
	local company = 'dm'
	local companywikidata = 'q41171672'
	if ( brand == company or operator == company or brandwikidata == companywikidata or operatorwikidata == companywikidata ) then

	   object.tags.cash_withdrawal = 'implicit'
	   object.tags['cash_withdrawal:purchase_required'] = 'yes'
	   object.tags['cash_withdrawal:purchase_minimum'] = 'no'
	   object.tags['cash_withdrawal:limit'] = '200'
	   
	   themepark:insert('cash_withdrawal', {
			       geom = cash_withdrawal_geom,
			       tags = object.tags,
					       }
	   )

	   return
	   
	end
	
	-- Netto
	local company = 'netto marken-discount'
	local companywikidata = 'q879858'
	if ( brand == company or operator == company or brandwikidata == companywikidata or operatorwikidata == companywikidata or brand == 'netto' or operator == 'netto' ) then

	   object.tags.cash_withdrawal = 'implicit'
	   object.tags['cash_withdrawal:purchase_required'] = 'yes'
	   object.tags['cash_withdrawal:purchase_minimum'] = '10'
	   object.tags['cash_withdrawal:limit'] = '200'
	   
	   themepark:insert('cash_withdrawal', {
			       geom = cash_withdrawal_geom,
			       tags = object.tags,
					       }
	   )

	   return
	   
	end
	
	-- Denns
	local company = 'denns biomarkt'
	local companywikidata = 'q48883773'
	if ( brand == company or operator == company or brandwikidata == companywikidata or operatorwikidata == companywikidata or brand == 'denns' or operator == 'denns' ) then

	   object.tags.cash_withdrawal = 'implicit'
	   object.tags['cash_withdrawal:purchase_required'] = 'yes'
	   object.tags['cash_withdrawal:purchase_minimum'] = '20'
	   object.tags['cash_withdrawal:limit'] = '200'
	   
	   themepark:insert('cash_withdrawal', {
			       geom = cash_withdrawal_geom,
			       tags = object.tags,
					       }
	   )

	   return
	   
	end
	
	-- famila
	local company = 'famila'
	local companywikidata = 'q1395108'
	if ( brand == company or operator == company or brandwikidata == companywikidata or operatorwikidata == companywikidata ) then

	   object.tags.cash_withdrawal = 'implicit'
	   object.tags['cash_withdrawal:purchase_required'] = 'yes'
	   object.tags['cash_withdrawal:purchase_minimum'] = '10'
	   object.tags['cash_withdrawal:limit'] = '200'
	   
	   themepark:insert('cash_withdrawal', {
			       geom = cash_withdrawal_geom,
			       tags = object.tags,
					       }
	   )

	   return
	   
	end
	
	-- Kaufland
	local company = 'kaufland'
	local companywikidata = 'q685967'
	if ( brand == company or operator == company or brandwikidata == companywikidata or operatorwikidata == companywikidata ) then

	   object.tags.cash_withdrawal = 'implicit'
	   object.tags['cash_withdrawal:purchase_required'] = 'yes'
	   object.tags['cash_withdrawal:purchase_minimum'] = '10'
	   object.tags['cash_withdrawal:limit'] = '200'
	   
	   themepark:insert('cash_withdrawal', {
			       geom = cash_withdrawal_geom,
			       tags = object.tags,
					       }
	   )

	   return
	   
	end
	
	-- Lidl
	local company = 'lidl'
	local companywikidata = 'q151954'
	if ( brand == company or operator == company or brandwikidata == companywikidata or operatorwikidata == companywikidata ) then

	   object.tags.cash_withdrawal = 'implicit'
	   object.tags['cash_withdrawal:purchase_required'] = 'yes'
	   object.tags['cash_withdrawal:purchase_minimum'] = '0.99'
	   object.tags['cash_withdrawal:limit'] = '200'
	   
	   themepark:insert('cash_withdrawal', {
			       geom = cash_withdrawal_geom,
			       tags = object.tags,
					       }
	   )

	   return
	   
	end
	
	-- Markant
	local company = 'markant'
	local companywikidata = 'q57523365'
	if ( brand == company or operator == company or brandwikidata == companywikidata or operatorwikidata == companywikidata ) then

	   object.tags.cash_withdrawal = 'implicit'
	   object.tags['cash_withdrawal:purchase_required'] = 'yes'
	   object.tags['cash_withdrawal:purchase_minimum'] = '10'
	   object.tags['cash_withdrawal:limit'] = '200'
	   
	   themepark:insert('cash_withdrawal', {
			       geom = cash_withdrawal_geom,
			       tags = object.tags,
					       }
	   )

	   return
	   
	end
	
	-- Norma
	local company = 'norma'
	local companywikidata = 'q450180'
	if ( brand == company or operator == company or brandwikidata == companywikidata or operatorwikidata == companywikidata ) then

	   object.tags.cash_withdrawal = 'implicit'
	   object.tags['cash_withdrawal:purchase_required'] = 'yes'
	   object.tags['cash_withdrawal:purchase_minimum'] = '1'
	   object.tags['cash_withdrawal:limit'] = '200'
	   
	   themepark:insert('cash_withdrawal', {
			       geom = cash_withdrawal_geom,
			       tags = object.tags,
					       }
	   )

	   return
	   
	end
	
	-- NP-Markt
	local company = 'np-markt'
	local companywikidata = 'q15836148'
	if ( brand == company or operator == company or brandwikidata == companywikidata or operatorwikidata == companywikidata ) then

	   object.tags.cash_withdrawal = 'implicit'
	   object.tags['cash_withdrawal:purchase_required'] = 'yes'
	   object.tags['cash_withdrawal:purchase_minimum'] = '10'
	   object.tags['cash_withdrawal:limit'] = '200'
	   
	   themepark:insert('cash_withdrawal', {
			       geom = cash_withdrawal_geom,
			       tags = object.tags,
					       }
	   )

	   return
	   
	end
	
	-- Penny
	local company = 'penny'
	local companywikidata = 'q284688'
	if ( brand == company or operator == company or brandwikidata == companywikidata or operatorwikidata == companywikidata ) then

	   object.tags.cash_withdrawal = 'implicit'
	   object.tags['cash_withdrawal:purchase_required'] = 'yes'
	   object.tags['cash_withdrawal:purchase_minimum'] = 'no'
	   object.tags['cash_withdrawal:limit'] = '200'
	   
	   themepark:insert('cash_withdrawal', {
			       geom = cash_withdrawal_geom,
			       tags = object.tags,
					       }
	   )

	   return
	   
	end
	
	-- Tegut
	local company = 'tegut'
	local companywikidata = 'q1547993'
	if ( brand == company or operator == company or brandwikidata == companywikidata or operatorwikidata == companywikidata ) then

	   object.tags.cash_withdrawal = 'implicit'
	   object.tags['cash_withdrawal:purchase_required'] = 'yes'
	   object.tags['cash_withdrawal:purchase_minimum'] = 'no'
	   object.tags['cash_withdrawal:limit'] = '200'
	   
	   themepark:insert('cash_withdrawal', {
			       geom = cash_withdrawal_geom,
			       tags = object.tags,
					       }
	   )

	   return
	   
	end
	
	-- Wasgau
	local company = 'wasgau'
	local companywikidata = 'q2536857'
	if ( brand == company or operator == company or brandwikidata == companywikidata or operatorwikidata == companywikidata ) then

	   object.tags.cash_withdrawal = 'implicit'
	   object.tags['cash_withdrawal:purchase_required'] = 'yes'
	   object.tags['cash_withdrawal:purchase_minimum'] = '20'
	   object.tags['cash_withdrawal:limit'] = '200'
	   
	   themepark:insert('cash_withdrawal', {
			       geom = cash_withdrawal_geom,
			       tags = object.tags,
					       }
	   )

	   return
	   
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
