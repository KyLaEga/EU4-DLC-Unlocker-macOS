#!/bin/bash
# shellcheck shell=bash disable=SC2154
# ============================================
# Status subcommand: non-mutating diagnostic.
# Reports: game found? patch installed? backup present? integrity ok?
# ============================================

status_run() {
    common_load_game "$GAME_ID"
    out_title "Status — ${conf_game_name} (appid ${conf_appid})"

    # Vendor integrity (always checkable)
    common_verify_vendor_dylib

    # Locate game
    common_find_dylib
    if [ -z "$FOUND_DYLIB" ]; then
        out_warn "Game not found."
        out_info "Use --path to point at your installation."
        return "$EX_GAME_NOT_FOUND"
    fi

    local target_dir
    target_dir=$(dirname "$FOUND_DYLIB")
    local backup="${target_dir}/libsteam_api_o.dylib"
    local old_backup="${FOUND_DYLIB}.backup"

    echo
    out_info "Game library:   ${FOUND_DYLIB}"

    # Architecture
    common_check_arch "$FOUND_DYLIB"

    # Patch state. Detected via the resign-invariant marker, not a full-file
    # hash: install re-signs the dylib, which changes its SHA256 but not its
    # CreamAPI install name. (See common_is_creamapi.)
    local is_patched=0
    if common_is_creamapi "$FOUND_DYLIB"; then
        is_patched=1
        out_ok "Patch state:     INSTALLED (CreamAPI active)"
    else
        out_warn "Patch state:     NOT installed (original or unknown library)"
        out_info "Installed SHA256: $(common_sha256 "$FOUND_DYLIB")"
    fi

    # Backup state
    if [ -f "$backup" ]; then
        out_ok "Original backup: PRESENT ($backup)"
    elif [ -f "$old_backup" ]; then
        out_warn "Legacy backup:   PRESENT ($old_backup)"
    else
        out_warn "Original backup: MISSING"
        [ "$is_patched" = "1" ] && \
            out_warn "  Patch is installed but no backup exists — uninstall is NOT possible."
    fi

    # Config
    if [ -f "$target_dir/cream_api.ini" ]; then
        out_ok "cream_api.ini:   PRESENT"
        if grep -Eq '^unlockall[[:space:]]*=[[:space:]]*true' "$target_dir/cream_api.ini" 2>/dev/null; then
            out_info "  unlockall = true (DLC list resolved from Steam at runtime)"
        else
            local dlc_n
            dlc_n=$(awk '/^\[dlc\]/{f=1;next} /^\[/{f=0} f && /=/ && $0 !~ /^[[:space:]]*;/ {c++} END{print c+0}' \
                    "$target_dir/cream_api.ini")
            out_info "  unlockall = false; explicit [dlc] list (${dlc_n} DLC)"
        fi
    else
        out_info "cream_api.ini:   absent"
    fi

    echo
    out_info "Steam 'Verify Integrity of Game Files' silently reverts the patch."
    out_info "Re-run './unlocker install ${GAME_ID}' to reapply."
    return "$EX_OK"
}
