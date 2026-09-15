#!/usr/bin/env bash
# Render every page of a PDF to PNG with ImageMagick, one page per process.
# Usage: render.sh <file.pdf> [out_dir=pages] [density=150] [jobs=8]
# Rendering the whole PDF in one convert call exhausts ImageMagick's pixel
# cache on large documents, so each page is converted separately.
set -euo pipefail

pdf="$1"
out="${2:-pages}"
density="${3:-150}"
jobs="${4:-8}"

command -v convert >/dev/null || { echo "ImageMagick 'convert' not found" >&2; exit 1; }
command -v pdfinfo >/dev/null || { echo "'pdfinfo' (poppler-utils) not found" >&2; exit 1; }

pages=$(pdfinfo "$pdf" | awk '/^Pages:/ {print $2}')
mkdir -p "$out"

seq 1 "$pages" | xargs -P "$jobs" -I{} sh -c '
  n={}
  convert -density "'"$density"'" "'"$pdf"'[$((n-1))]" -background white -alpha remove \
    "'"$out"'/page-$(printf %03d $n).png"
'

echo "Rendered $(ls "$out"/page-*.png | wc -l) of $pages pages into $out/"
