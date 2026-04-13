CREATE OR REPLACE VIEW fake_geldautomaten AS
SELECT ap.piageom AS geom, ap.tags AS tags
FROM atm_polygons AS ap
LEFT OUTER JOIN atm AS a
ON ST_INTERSECTS(ap.geom, a.geom) AND ap.geom && a.geom
WHERE a.geom IS NULL;

CREATE OR REPLACE VIEW alle_geldautomaten AS
SELECT geom, tags FROM fake_geldautomaten
UNION ALL
SELECT geom, tags FROM atm;

CREATE OR REPLACE VIEW fake_cash_withdrawal AS
SELECT ap.piageom AS geom, ap.tags AS tags
FROM cash_withdrawal_polygons AS ap
LEFT OUTER JOIN cash_withdrawal AS a
ON ST_INTERSECTS(ap.geom, a.geom) AND ap.geom && a.geom
WHERE a.geom IS NULL;

CREATE OR REPLACE VIEW alle_cash_withdrawal AS
SELECT geom, tags FROM fake_cash_withdrawal
UNION ALL
SELECT geom, tags FROM cash_withdrawal;
