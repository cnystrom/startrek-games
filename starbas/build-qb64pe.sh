#!/bin/sh
# Build Star Battles with QB64 Phoenix Edition on Linux or macOS.
# Usage: QB64PE=/path/to/qb64pe ./build-qb64pe.sh [output-folder]
# (port helper, not part of the 1990 original)
set -e
cd "$(dirname "$0")"
QB64PE=${QB64PE:-qb64pe}
OUT=${1:-game}
mkdir -p "$OUT"
for p in STARBAT SB SB2 SBCREATE; do
  echo "== $p"
  "$QB64PE" -x -q "PE_$p.BAS" -o "$(cd "$OUT" && pwd)/$p"
done
cp SBINST.DOC SBCRINST.DOC CREATION.DOC "$OUT"/
echo "Done. Run: cd $OUT && ./STARBAT    (or ./SBCREATE to make a scenario)"
