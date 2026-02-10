#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

PAGES="${1:-1}"
if [ "$PAGES" = "500" ]; then XML=fakenames_500.xml; else XML=fakenames.xml; fi

fop -xml "$XML" -xsl mailmerge.xsl -pdf mailmerge_fop_${PAGES}p.pdf 2>/dev/null
