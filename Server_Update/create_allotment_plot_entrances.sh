#!/bin/bash
set -euo pipefail
# als user postgres
psql -d themeparktest -a -f /home/renderaccount/Myosm2pgsql-themepark/Server_Update/allotment_plot_entrances.sql



