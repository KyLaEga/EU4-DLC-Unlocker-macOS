#!/bin/bash
# shellcheck shell=bash disable=SC2154
# ============================================
# Install subcommand: apply the CreamAPI patch to the game.
# Pipeline per design spec §5.
# ============================================

# Write cream_api.ini at <ini>, enumerating the game's own DLC metadata into an
# explicit [dlc] list so nothing is lost to Steam's truncated runtime list.
# Falls back to unlockall = true when no DLC metadata is found. The game root
# (and thus its dlc/ folder) is derived from the located dylib.
# Sets INSTALL_DLC_DESC for the post-install summary.
install_write_ini() {
    local ini="$1"
    local game_root="${FOUND_DYLIB%%/"$conf_app_bundle"/*}"
    local dlc_dir="$game_root/${conf_dlc_subdir:-dlc}"
    local list count
    list=$(mktemp)
    common_generate_dlc_list "$dlc_dir" > "$list"
    count=$(grep -c '=' "$list" 2>/dev/null) || count=0
    if [ "$count" -gt 0 ]; then
        out_info "Enumerated $count DLC from ${dlc_dir} → explicit [dlc] list (unlockall = false)."
        common_generate_ini "$ini" "$list"
        INSTALL_DLC_DESC="explicit list of $count DLC (complete; offline-safe after first launch)"
    else
        out_info "No DLC metadata under ${dlc_dir} → unlockall = true (Steam resolves the list)."
        common_generate_ini "$ini"
        INSTALL_DLC_DESC="automatic (unlockall = true; needs Steam online to resolve the list)"
    fi
    rm -f "$list"
}

install_run() {
    common_load_game "$GAME_ID"
    out_title "Install — ${conf_game_name} (appid ${conf_appid})"

    # Step 1: vendor integrity
    common_verify_vendor_dylib

    # Step 2: locate the game
    common_find_dylib
    if [ -z "$FOUND_DYLIB" ]; then
        cat >&2 <<EOF

Game not found automatically.
Set the path with:  --path "/full/path/to/Europa Universalis IV"
or pass it interactively below.
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
    local ini="$target_dir/cream_api.ini"
    local root; root=$(common_repo_root)
    local vendor_dylib="$root/vendor/creamapi/libsteam_api.dylib"

    out_ok "Found: $FOUND_DYLIB"
    out_info "Target dir: $target_dir"

    # Writable check
    [ -w "$target_dir" ] || die "Target dir not writable (run with appropriate permissions): $target_dir"

    # Step 4: guard against double-patch (resign-invariant; see common_is_creamapi).
    # The dylib is already patched, so we don't touch it — but we DO refresh
    # cream_api.ini so a re-run picks up any DLC content added since last time.
    if common_is_creamapi "$FOUND_DYLIB"; then
        out_warn "This dylib is ALREADY the CreamAPI patch (library left untouched)."
        out_info "Refreshing cream_api.ini from current DLC content..."
        install_write_ini "$ini"
        chmod 644 "$ini" || true
        common_strip_quarantine "$ini"
        out_info "Use 'uninstall' first if you want to restore the original."
        return 0
    fi

    # Step 2b: architecture check on the shipped dylib
    common_check_arch "$vendor_dylib"

    out_info "This will back up the original and install CreamAPI."
    confirm "Proceed?" || die "Aborted by user." "$EX_GENERIC"

    # Step 5: backup original (never overwrite an existing good backup)
    if [ -f "$backup" ]; then
        out_info "Backup already exists: $backup (keeping it)"
    else
        out_info "Backing up original..."
        cp "$FOUND_DYLIB" "$backup" || die "Backup failed." "$EX_GENERIC"
        out_ok "Backup: $backup"
    fi

    # Step 6: copy CreamAPI dylib
    out_info "Installing CreamAPI dylib..."
    cp "$vendor_dylib" "$FOUND_DYLIB" || die "Failed to copy dylib." "$EX_GENERIC"

    # Step 6a: verify the copy is byte-identical to the verified vendor file,
    # BEFORE the resign in step 9 rewrites the signature (and thus the hash).
    common_expected_sha256
    local copied_sha
    copied_sha=$(common_sha256 "$FOUND_DYLIB")
    [ "$copied_sha" = "$EXPECTED_SHA256" ] || \
        die "Copied dylib hash does not match the vendor file — copy may be corrupt." "$EX_INTEGRITY"

    # Step 6b: write cream_api.ini with an explicit, complete [dlc] list built
    # from the game's own DLC metadata (see install_write_ini).
    out_info "Writing cream_api.ini (appid=${conf_appid})..."
    install_write_ini "$ini"

    # Step 7: permissions
    chmod 755 "$FOUND_DYLIB" || true
    chmod 644 "$ini" || true

    # Step 8: strip quarantine
    common_strip_quarantine "$FOUND_DYLIB"
    common_strip_quarantine "$ini"

    # Step 9: ad-hoc resign
    common_resign "$FOUND_DYLIB"

    # Step 10: verify result. The hash now legitimately differs (re-signed in
    # step 9), so we confirm the install via the resign-invariant marker.
    if ! common_is_creamapi "$FOUND_DYLIB"; then
        out_warn "Post-install check could not confirm the CreamAPI library. Verify manually."
    fi
    [ -f "$backup" ] || out_warn "Backup missing after install!"

    out_title "Installation complete"
    cat <<EOF

  Game:        ${conf_game_name}
  Patched:     ${FOUND_DYLIB}
  Backup:      ${backup}
  Config:      ${ini}

  Multiplayer: supported (CreamAPI proxies to the real Steam).
  DLC unlock:  ${INSTALL_DLC_DESC}

Next steps:
  - Launch the game via Steam.
  - If it won't start, see README "Game won't launch" (xattr / codesign).
  - To restore the original: ./unlocker uninstall ${GAME_ID}
EOF
}
