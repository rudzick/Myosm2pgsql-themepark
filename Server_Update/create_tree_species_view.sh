#!/bin/bash
set -euo pipefail
# als user postgres
psql -d themeparktest -a -f /home/renderaccount/Mymapnik_openstreetmap-carto/Server_Update/tree_species.sql
psql -d themeparktest -a -f /home/renderaccount/Myosm2pgsql-themepark/Server_Update/tree_species_view.sql
