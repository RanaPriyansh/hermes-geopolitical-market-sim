#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"
DEST="$HERMES_HOME/skills/research/geopolitical-market-sim"
mkdir -p "$(dirname "$DEST")"
rm -rf "$DEST"
cp -R "$REPO_ROOT/skill/geopolitical-market-sim" "$DEST"
python3 -m pip install -r "$REPO_ROOT/requirements.txt"
echo "Installed skill to $DEST"
echo "Next: export WORLDOSINT_BASE_URL / MIROFISH_BASE_URL / MIROFISH_ROOT as needed, then run:"
echo "  python3 \"$DEST/scripts/geopolitical_market_pipeline.py\" health"
