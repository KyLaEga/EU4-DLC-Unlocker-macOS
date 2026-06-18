#!/bin/bash
# shellcheck shell=bash
# ============================================
# Backward-compatibility wrapper → ./unlocker install eu4
# Kept so existing documentation and bookmarks keep working.
# ============================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Forward any extra args (e.g. a path passed as $1 in the old interface).
exec "$SCRIPT_DIR/bin/unlocker" install eu4 "$@"
