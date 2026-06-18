#!/bin/bash
# shellcheck shell=bash
# ============================================
# Backward-compatibility wrapper → ./unlocker uninstall eu4
# ============================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

exec "$SCRIPT_DIR/bin/unlocker" uninstall eu4 "$@"
