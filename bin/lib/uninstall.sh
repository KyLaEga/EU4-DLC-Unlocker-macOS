#!/bin/bash
# shellcheck shell=bash disable=SC2154
# ============================================
# Uninstall subcommand: restore the original libsteam_api.dylib.
# ============================================

uninstall_run() {
    common_load_game "$GAME_ID"
    out_title "Uninstall — ${conf_game_name} (appid ${conf_appid})"

    common_find_dylib
    if [ -z "$FOUND_DYLIB" ]; then
        cat >&2 <<EOF

Game not found automatically.
Pass the path with:  --path "/full/path/to/Europa Universalis IV"
EOF
        local custom
        read -r -p "Path to game folder: " custom
        [ -n "$custom" ] || die "No path given." "$EX_GAME_NOT_FOUND"
        FOUND_DYLIB=$(find "$custom" -name libsteam_api.dylib -type f 2>/dev/null | head -1)
        [ -n "$FOUND_DYLIB" ] || die "libsteam_api.dylib not found under '$custom'." "$EX_GAME_NOT_FOUND"
    fi

    local target_dir
    target_dir=$(dirname "$FOUND_DYLIB")
    local backup="${target_dir}/libsteam_api_o.dylib"
    local old_backup="${FOUND_DYLIB}.backup"   # legacy Goldberg-era backup

    if [ -f "$backup" ]; then
        out_ok "Found CreamAPI backup: $backup"
    elif [ -f "$old_backup" ]; then
        out_warn "Found legacy backup (Goldberg era): $old_backup"
        backup="$old_backup"
    else
        die "No backup found — was the unlocker installed?" "$EX_NO_BACKUP"
    fi

    [ -w "$target_dir" ] || die "Target dir not writable: $target_dir"

    confirm "Restore the original library from the backup?" || die "Aborted by user." "$EX_GENERIC"

    out_info "Restoring original..."
    cp "$backup" "$FOUND_DYLIB" || die "Restore failed." "$EX_GENERIC"
    rm -f "$backup"
    rm -f "$target_dir/cream_api.ini"
    rm -rf "$target_dir/steam_settings" 2>/dev/null || true   # legacy Goldberg
    rm -f "$target_dir/steam_appid.txt" 2>/dev/null || true   # legacy Goldberg

    chmod 755 "$FOUND_DYLIB" || true
    common_strip_quarantine "$FOUND_DYLIB"
    common_resign "$FOUND_DYLIB"

    out_title "Uninstall complete"
    cat <<EOF

  Restored: ${FOUND_DYLIB}
  The game now runs with the original Steam library.

If Steam "Verify Integrity of Game Files" was run, Steam may have already
restored this for you — that's expected.
EOF
}
