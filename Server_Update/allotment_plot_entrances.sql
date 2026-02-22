TRUNCATE allotment_plot_entrances;
INSERT INTO allotment_plot_entrances (node_id, geom, entrance_tags, plot_tags)
SELECT e.node_id, e.geom, e.tags, p.tags FROM entrances e INNER JOIN allotment_plots p ON ST_Intersects(ST_ExteriorRing(p.geom), e.geom);
