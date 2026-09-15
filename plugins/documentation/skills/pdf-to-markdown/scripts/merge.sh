#!/usr/bin/env bash
# Concatenate numbered Markdown chunks (e.g. 001-006.md, 007-012.md) in page
# order and run basic sanity checks on the result.
# Usage: merge.sh <chunks_dir=md> <output.md>
set -euo pipefail

dir="${1:-md}"
out="$2"

for f in $(ls "$dir" | sort -n); do
  cat "$dir/$f"
  printf '\n'
done > "$out"

wc -l -c "$out"
fences=$(grep -c '^\s*```' "$out" || true)
echo "code fences: $fences $([ $((fences % 2)) -eq 0 ] && echo '(balanced)' || echo '(UNBALANCED - a code block is left open)')"
echo "chapter headings (#):"
grep -n '^# ' "$out" || true
