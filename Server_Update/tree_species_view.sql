CREATE OR REPLACE VIEW tree_species_view AS
 SELECT p.geom,
                          COALESCE( p.tags->>'species:de'
                                             , s.treename
                                             , p.tags->>'genus:de'
                                             , p.tags->>'species'
                                             , p.tags->>'genus'
                                             ) AS obstbaumart,
                         CASE
                            WHEN  tags->>'name' <> 'none' OR tags->>'name:de' <> 'none' THEN CONCAT(E'\u000a', E'\u201e', COALESCE(tags->>'name:de',tags->>'name'), E'\u201c')
                        END AS baumname	  
                FROM trees p
                LEFT JOIN tree_species s
                    ON LOWER(p.tags->>'species') = s.treespecies
                  AND s.lang='de_DE';
      
