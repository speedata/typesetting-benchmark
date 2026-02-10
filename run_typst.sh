#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

PAGES="${1:-1}"
if [ "$PAGES" = "500" ]; then XML=fakenames_500.xml; else XML=fakenames.xml; fi

typst compile --input xml="$XML" mailmerge.typ mailmerge_typst.pdf
