#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

# Generate fakenames_500.xml if needed
if [ ! -f fakenames_500.xml ]; then
  echo "Generating fakenames_500.xml ..."
  .venv/bin/python generate_fakenames.py
fi

echo "=== Benchmark: 1 page ==="
hyperfine --warmup 3 \
  -n typst      './run_typst.sh 1' \
  -n pdflatex   './run_latex.sh 1' \
  -n lualatex   './run_lualatex.sh 1' \
  -n weasyprint './run_weasy.sh 1' \
  -n fop        './run_fop.sh 1' \
  -n sp         './run_sp.sh 1'

echo ""
echo "=== Benchmark: 500 pages ==="
hyperfine --warmup 1 --min-runs 3 \
  -n typst      './run_typst.sh 500' \
  -n pdflatex   './run_latex.sh 500' \
  -n lualatex   './run_lualatex.sh 500' \
  -n weasyprint './run_weasy.sh 500' \
  -n fop        './run_fop.sh 500' \
  -n sp         './run_sp.sh 500'


  # -n groff      './run_groff.sh 1' \
  # -n groff      './run_groff.sh 500' \
