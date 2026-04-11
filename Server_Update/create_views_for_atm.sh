#!/bin/bash
set -euo pipefail
# als user postgres
psql -d themeparktest -a -f /home/renderaccount/Myosm2pgsql-themepark/Server_Update/create_views_for_atm.sql



