#!/bin/bash
# shellcheck shell=bash disable=SC2034,SC2154,SC2086
# Variables like conf_game_name/conf_appid/FOUND_DYLIB/OPT_PATH are assigned
# here and consumed by install/uninstall/status via sourcing. The linter
# cannot track that flow across separate files, hence the disables above.
# EU4 DLC Unlocker — common engine library
# Game-agnostic. Reads per-game config from games/*.conf.
# ============================================

# Exit-code conventions (see design spec §5/§6.2)
EX_OK=0
EX_GENERIC=1
EX_GAME_NOT_FOUND=2
EX_NO_BACKUP=3
EX_INTEGRITY=4

# ----------------------------------------------------------------------------
# Resolve repo root (parent of bin/) regardless of where the user invokes from.
# ----------------------------------------------------------------------------
common_repo_root() {
    # bin/lib/common.sh -> repo root is two levels up from this file's dir.
    local this_file
    this_file="${BASH_SOURCE[0]:-$0}"
    ( cd "$(dirname "$this_file")/../../" && pwd )
}

# ----------------------------------------------------------------------------
# Output helpers. Colors auto-disable when stdout is not a TTY.
# ----------------------------------------------------------------------------
if [ -t 1 ] && command -v tput >/dev/null 2>&1; then
    _C_BOLD=$(tput bold)
    _C_RED=$(tput setaf 1)
    _C_GREEN=$(tput setaf 2)
    _C_YELLOW=$(tput setaf 3)
    _C_BLUE=$(tput setaf 4)
    _C_RESET=$(tput sgr0)
else
    _C_BOLD="" _C_RED="" _C_GREEN="" _C_YELLOW="" _C_BLUE="" _C_RESET=""
fi

out_info()  { printf '%s\n' "${_C_BLUE}[*]${_C_RESET} $*"; }
out_ok()    { printf '%s\n' "${_C_GREEN}[+]${_C_RESET} $*"; }
out_warn()  { printf '%s\n' "${_C_YELLOW}[!]${_C_RESET} $*" >&2; }
out_err()   { printf '%s\n' "${_C_RED}[-]${_C_RESET} $*" >&2; }
out_title() { printf '%s\n' "${_C_BOLD}${_C_BLUE}=== $* ===${_C_RESET}"; }

# die <message> <exit-code>
die() {
    out_err "$1"
    exit "${2:-$EX_GENERIC}"
}

# ----------------------------------------------------------------------------
# Confirm interactively. $1 = prompt. Returns 0 (yes) / 1 (no).
# Honors global OPT_YES for non-interactive mode.
# ----------------------------------------------------------------------------
confirm() {
    if [ "${OPT_YES:-0}" = "1" ]; then
        return 0
    fi
    local resp
    read -r -p "$1 [y/N] " resp
    case "$resp" in
        y|Y|yes|YES) return 0 ;;
        *) return 1 ;;
    esac
}

# ----------------------------------------------------------------------------
# Load a game config file. Sets globals used by the rest of the engine.
#   conf_game_name, conf_appid, conf_app_bundle, conf_framework_subdir,
#   conf_search_paths[]   (bash array of expanded glob patterns)
# common_load_game <game-id>   (e.g. "eu4")
# ----------------------------------------------------------------------------
common_load_game() {
    local game_id="$1"
    local root
    root=$(common_repo_root)
    local conf_file="$root/games/${game_id}.conf"

    [ -f "$conf_file" ] || die "No game config for '$game_id' (expected $conf_file)." "$EX_GAME_NOT_FOUND"

    # Parse simple "key = value" lines. The search_paths block uses a
    # here-doc sentinel; we extract the lines between <<EOF and EOF.
    conf_game_name=""
    conf_appid=""
    conf_app_bundle=""
    conf_framework_subdir="Contents/Frameworks"
    conf_dlc_subdir="dlc"
    conf_search_paths=()

    local in_search=0 line key val
    while IFS= read -r line || [ -n "$line" ]; do
        # Strip comments and trim leading/trailing whitespace.
        line="${line%%#*}"
        line="${line#"${line%%[![:space:]]*}"}"
        line="${line%"${line##*[![:space:]]}"}"
        [ -z "$line" ] && continue

        if [ "$in_search" = "1" ]; then
            case "$line" in
                EOF) in_search=0; continue ;;
                *)   conf_search_paths+=("$line") ;;
            esac
            continue
        fi

        case "$line" in
            *"="*)
                key="${line%%=*}"
                val="${line#*=}"
                key="${key%"${key##*[![:space:]]}"}"
                val="${val#"${val%%[![:space:]]*}"}"
                val="${val%"${val##*[![:space:]]}"}"
                case "$key" in
                    game_name)         conf_game_name="$val" ;;
                    appid)             conf_appid="$val" ;;
                    app_bundle)        conf_app_bundle="$val" ;;
                    framework_subdir)  conf_framework_subdir="$val" ;;
                    dlc_subdir)        conf_dlc_subdir="$val" ;;
                    search_paths)      [ "$val" = "<<EOF" ] && in_search=1 ;;
                esac
                ;;
        esac
    done < "$conf_file"

    [ -n "$conf_game_name" ] || die "Config $conf_file: missing game_name."
    [ -n "$conf_appid" ]     || die "Config $conf_file: missing appid."

    # Substitute $USER literally. Each path stays ONE array element — no eval,
    # no word-splitting (default Steam paths contain spaces: "Application
    # Support", "Europa Universalis IV"). Globs (e.g. /Volumes/*) are left
    # intact and expanded later, space-safely, in common_find_dylib.
    local i expanded=()
    for i in "${conf_search_paths[@]}"; do
        expanded+=( "${i//\$USER/$USER}" )
    done
    conf_search_paths=("${expanded[@]}")
}

# ----------------------------------------------------------------------------
# Find the game's libsteam_api.dylib.
# Uses conf_search_paths globs (path-safe: globs expand to full quoted paths).
# If $OPT_PATH is set, uses it verbatim instead.
# Sets: FOUND_DYLIB (full path) on success.
# ----------------------------------------------------------------------------
common_find_dylib() {
    local candidate found=""

    if [ -n "${OPT_PATH:-}" ]; then
        out_info "Searching user-provided path: $OPT_PATH"
        candidate=$(find "$OPT_PATH" -name libsteam_api.dylib -type f 2>/dev/null | head -1)
        [ -n "$candidate" ] && found="$candidate"
    else
        local pattern dir oldifs
        oldifs=$IFS
        for pattern in "${conf_search_paths[@]}"; do
            # Expand globs while preserving spaces in path segments. With
            # IFS=newline, word-splitting cannot break on spaces, yet bash
            # still performs pathname (glob) expansion on the unquoted word.
            # An unmatched glob stays literal and fails the -d test below.
            IFS=$'\n'
            # shellcheck disable=SC2086  # intentional glob expansion
            for dir in $pattern; do
                IFS=$oldifs
                [ -d "$dir" ] || continue
                out_info "Checking: $dir"
                candidate=$(find "$dir" -name libsteam_api.dylib -type f 2>/dev/null | head -1)
                if [ -n "$candidate" ]; then
                    found="$candidate"
                    break 2
                fi
            done
            IFS=$oldifs
        done
    fi

    FOUND_DYLIB="$found"
}

# ----------------------------------------------------------------------------
# sha256 of a file. Uses shasum on macOS.
# ----------------------------------------------------------------------------
common_sha256() {
    shasum -a 256 "$1" | awk '{print $1}'
}

# ----------------------------------------------------------------------------
# Read the expected CreamAPI dylib SHA256 from vendor/.
# Sets EXPECTED_SHA256.
# ----------------------------------------------------------------------------
common_expected_sha256() {
    local root
    root=$(common_repo_root)
    EXPECTED_SHA256=$(tr -d '[:space:]' < "$root/vendor/creamapi/libsteam_api.dylib.sha256")
    [ -n "$EXPECTED_SHA256" ] || die "Missing vendor/creamapi/libsteam_api.dylib.sha256." "$EX_INTEGRITY"
}

# ----------------------------------------------------------------------------
# Verify the shipped dylib integrity (vendor copy).
# Aborts with EX_INTEGRITY on mismatch.
# ----------------------------------------------------------------------------
common_verify_vendor_dylib() {
    local root actual
    root=$(common_repo_root)
    local vendordylib="$root/vendor/creamapi/libsteam_api.dylib"
    [ -f "$vendordylib" ] || die "CreamAPI dylib missing: $vendordylib" "$EX_INTEGRITY"
    common_expected_sha256
    actual=$(common_sha256 "$vendordylib")
    if [ "$actual" != "$EXPECTED_SHA256" ]; then
        die "Vendor dylib integrity check FAILED.
  expected: $EXPECTED_SHA256
  actual:   $actual
The shipped library is corrupted or tampered with. Re-download the repo." "$EX_INTEGRITY"
    fi
    out_ok "CreamAPI dylib integrity verified."
}

# ----------------------------------------------------------------------------
# Decide whether <dylib> is the CreamAPI proxy (not the original Valve lib).
# Returns 0 (yes) / 1 (no).
#
# NOTE: we deliberately do NOT compare the full-file SHA256 here. The install
# step ad-hoc re-signs the copied dylib (codesign --force -s -), which rewrites
# the Mach-O signature and therefore changes the file hash. The CreamAPI build
# is instead identified by its LC_ID_DYLIB install name ("cream_api_clean"),
# which the resign does not touch — so detection survives installation.
# Fallback (no otool, e.g. no Xcode CLT → no resign either): the unmodified
# copy still matches the expected vendor SHA256.
# ----------------------------------------------------------------------------
common_is_creamapi() {
    local dylib="$1"
    [ -f "$dylib" ] || return 1
    if command -v otool >/dev/null 2>&1; then
        otool -D "$dylib" 2>/dev/null | grep -qi 'cream_api' && return 0
        return 1
    fi
    # No otool: codesign is almost certainly absent too, so the dylib was not
    # re-signed and its hash still equals the shipped vendor hash.
    local sha
    sha=$(common_sha256 "$dylib")
    common_expected_sha256
    [ "$sha" = "$EXPECTED_SHA256" ]
}

# ----------------------------------------------------------------------------
# Check the dylib contains both arm64 and x86_64 slices.
# Warn (do not fail) if only one.
# ----------------------------------------------------------------------------
common_check_arch() {
    local dylib="$1"
    if ! command -v lipo >/dev/null 2>&1; then
        out_warn "lipo not found; skipping architecture check."
        return 0
    fi
    local archs
    archs=$(lipo -archs "$dylib" 2>/dev/null || lipo -info "$dylib" 2>/dev/null)
    out_info "dylib architectures: $archs"
    if ! echo "$archs" | grep -q arm64; then
        out_warn "dylib has NO arm64 slice. Apple Silicon will need Rosetta 2."
    fi
    if ! echo "$archs" | grep -q x86_64; then
        out_warn "dylib has NO x86_64 slice. Intel Macs are not supported by this build."
    fi
}

# ----------------------------------------------------------------------------
# Remove macOS quarantine attribute from a path (file or dir).
# ----------------------------------------------------------------------------
common_strip_quarantine() {
    local target="$1"
    if xattr "$target" 2>/dev/null | grep -q 'com.apple.quarantine'; then
        out_info "Removing quarantine attribute from: $target"
        xattr -dr com.apple.quarantine "$target" 2>/dev/null || \
            xattr -d com.apple.quarantine "$target" 2>/dev/null || true
    fi
}

# ----------------------------------------------------------------------------
# Ad-hoc re-sign a dylib. Removes leaky build identifier, makes the signature
# consistent so macOS loads the library inside the game process.
# ----------------------------------------------------------------------------
common_resign() {
    local dylib="$1"
    if ! command -v codesign >/dev/null 2>&1; then
        out_warn "codesign not found; skipping re-sign. Install Xcode Command Line Tools:
  xcode-select --install"
        return 0
    fi
    out_info "Re-signing dylib (ad-hoc)..."
    if codesign --force -s - "$dylib" >/dev/null 2>&1; then
        out_ok "Re-signed."
    else
        out_warn "codesign failed; the game may still work, but the signature is unchanged."
    fi
}

# ----------------------------------------------------------------------------
# Enumerate a Paradox game's dlc/ directory into a CreamAPI [dlc] list.
# For each <dlc_dir>/*/*.dlc it reads steam_id + name, de-duplicates by appid
# (several content packs can share one Steam purchase) and prints lines of the
# form "<appid> = <name>" sorted by appid. Prints nothing when the directory
# has no readable .dlc metadata.
# common_generate_dlc_list <dlc_dir>
# ----------------------------------------------------------------------------
common_generate_dlc_list() {
    local dlc_dir="$1"
    [ -d "$dlc_dir" ] || return 0
    find "$dlc_dir" -maxdepth 2 -name '*.dlc' -print0 2>/dev/null | sort -z | \
    while IFS= read -r -d '' dfile; do
        local sid name
        sid=$(grep -m1 '^[[:space:]]*steam_id' "$dfile" 2>/dev/null \
              | sed -E 's/.*"([0-9]+)".*/\1/')
        name=$(grep -m1 '^[[:space:]]*name' "$dfile" 2>/dev/null \
               | sed -E 's/^[[:space:]]*name[^"]*"(.*)"[[:space:]]*$/\1/')
        [ -n "$sid" ] && printf '%s = %s\n' "$sid" "$name"
    done | awk -F' = ' '!seen[$1]++' | sort -n
}

# ----------------------------------------------------------------------------
# Generate cream_api.ini for the loaded game into a target path.
#   common_generate_ini <output-path> [dlc-list-file]
# When <dlc-list-file> is given and non-empty, the file is written with
# unlockall = false and an explicit [dlc] section (its contents). Otherwise it
# falls back to unlockall = true with an empty [dlc] section. The template
# carries the static comments; this function fills __APPID__, __UNLOCKALL__ and
# the __DLC_LIST__ block.
# ----------------------------------------------------------------------------
common_generate_ini() {
    local out="$1"
    local dlc_list_file="${2:-}"
    local root
    root=$(common_repo_root)
    local tmpl="$root/config/cream_api.ini.tmpl"
    [ -f "$tmpl" ] || die "Template missing: $tmpl" "$EX_GENERIC"

    local unlockall tmp_body="" body_file
    if [ -n "$dlc_list_file" ] && [ -s "$dlc_list_file" ]; then
        unlockall="false"
        body_file="$dlc_list_file"
    else
        unlockall="true"
        tmp_body=$(mktemp)
        printf '%s\n' "; empty on purpose — unlockall = true resolves the list from Steam" > "$tmp_body"
        body_file="$tmp_body"
    fi

    # awk substitutes the two scalars and expands the __DLC_LIST__ line into the
    # (possibly multi-line) body verbatim — sed cannot inject a multi-line block.
    awk -v appid="$conf_appid" -v ul="$unlockall" -v listfile="$body_file" '
        index($0, "__DLC_LIST__") { while ((getline l < listfile) > 0) print l; close(listfile); next }
        { gsub(/__APPID__/, appid); gsub(/__UNLOCKALL__/, ul); print }
    ' "$tmpl" > "$out" || { [ -n "$tmp_body" ] && rm -f "$tmp_body"; die "Failed to write $out."; }

    [ -n "$tmp_body" ] && rm -f "$tmp_body"
    return 0
}
