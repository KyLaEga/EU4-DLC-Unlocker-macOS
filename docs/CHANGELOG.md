# Changelog

All notable changes to this project are documented here.
The format is loosely based on [Keep a Changelog](https://keepachangelog.com/).

## [4.0.1] — 2026-06-19

Documentation and packaging follow-up to 4.0. No behavior change in the engine.

### Changed
- All six READMEs (EN/RU/DE/FR/ES/ZH) brought to full parity: TL;DR, step-by-step
  install, a "Verify it worked" section, an "under the hood" breakdown of the
  install pipeline, a macOS split-archive (`*.zip.001`) join/extract how-to, and
  a "purchases vs content packs" FAQ explaining why the DLC count (appids) is
  lower than the number of `dlc/` folders.
- `--version` now reports `4.0.1`.

### Fixed
- Dropped the dead `pointfeev/CreamInstaller` credit link — the repo now returns
  HTTP 451 (Unavailable For Legal Reasons), which failed the link-check CI.

## [4.0] — 2026-06

Modular rewrite. The two monolithic scripts are replaced by a small,
game-agnostic engine that reads per-game data files. Only EU4 is shipped.

### Added
- Single `bin/unlocker` CLI with `install` / `uninstall` / `status` subcommands
  and `--yes` / `--path` flags.
- Non-mutating `status` command (game found? patch installed? backup present?
  integrity OK?). Detects when Steam's "Verify Integrity of Game Files" has
  silently reverted the patch.
- Data-driven games: `games/eu4.conf` holds the appid and search paths; adding
  another Paradox game needs only a new `.conf`, no code changes.
- Vendored CreamAPI under `vendor/creamapi/` with a committed SHA256
  (`VERSION.txt` + `libsteam_api.dylib.sha256`); the installer refuses to run on
  a checksum mismatch.
- macOS hardening in the install pipeline: quarantine removal (`xattr`) and
  ad-hoc re-signing (`codesign`) so the modified library loads under Gatekeeper.
- `config/cream_api.ini.tmpl`; at install time the engine enumerates the game's
  `dlc/*.dlc` metadata into an explicit `[dlc]` list (`unlockall = false`) so
  every DLC unlocks — EU4's 130+ packs overflow Steam's truncated runtime list
  under `unlockall = true`. Falls back to `unlockall = true` when no DLC
  metadata is found; the list is rebuilt on every install. New game key
  `dlc_subdir` (default `dlc`) tells the engine where the content lives.
- CI: ShellCheck, markdown link check, and dylib-integrity verification.
- `docs/SECURITY.md`, `docs/CONTRIBUTING.md`, issue templates.

### Fixed
- **Path-with-spaces bug:** auto-detection failed for the default Steam path
  (`Application Support`, `Europa Universalis IV`) and external drives. Paths
  are now expanded space-safely (no word-splitting `eval`).
- **Re-sign vs. detection contradiction:** ad-hoc re-signing changes the dylib
  hash, which broke SHA-based "is it installed?" checks (every install printed a
  spurious warning; `status` always reported NOT installed). Detection now uses
  the resign-invariant CreamAPI install-name marker instead of the full-file hash.
- `bin/unlocker` is now executable, so the back-compat wrappers actually run.
- ShellCheck: all scripts pass clean (`read -r`, directive fixes, etc.).

### Changed
- DLC strategy: `unlockall = true` with an empty `[dlc]` section. CreamAPI
  resolves the full DLC list from Steam at runtime — no hard-coded list to
  maintain (removes the stale "100+ DLCs" claim).
- Documentation rewritten across all six languages: honest EULA/ban warning,
  corrected platform table (Apple Silicon is **native arm64**, not Rosetta 2),
  and removal of obsolete Goldberg / single-player-only content.

### Migration
- `install_dlc_unlocker.sh` and `uninstall_dlc_unlocker.sh` still work — they are
  now thin wrappers over `./bin/unlocker install eu4` / `uninstall eu4`.

## [3.0] — earlier

- Switched from the Goldberg Steam Emulator to **CreamAPI v5.3.0.0**, which
  proxies to the real Steam and therefore **supports multiplayer**.

## [2.x] — earlier

- 2.2.x: clarified supported platforms; multiplayer documented as unsupported
  (Goldberg era); CreamAPI suggested for online play on other platforms.
- 2.1: default path moved to the internal drive; Goldberg global settings.
- 2.0: initial public versions targeting Goldberg-based single-player unlock.
