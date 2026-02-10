#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

PAGES="${1:-1}"
if [ "$PAGES" = "500" ]; then XML=fakenames_500.xml; else XML=fakenames.xml; fi

sp --data "$XML" --layout mailmergesp.xml --jobname "mailmerge_sp_${PAGES}p"
