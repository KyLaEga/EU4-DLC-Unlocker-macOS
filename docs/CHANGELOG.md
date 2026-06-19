# Changelog

All notable changes to this project are documented here.
The format is loosely based on [Keep a Changelog](https://keepachangelog.com/).

## [4.0.3] — 2026-06-19

Documentation. No engine change.

### Added
- `docs/DLC-CONTENT.md` — a detailed guide for getting DLC content onto the Mac:
  legally copying the `dlc/` folder from a Windows/Linux install (with the common
  mistakes), and joining/extracting a multi-part (`*.zip.001`) archive on macOS
  with `7zz`, including an integrity check and a `7zz` troubleshooting table.
- All six READMEs link to the new guide from the "Where do I get the DLC content
  files?" FAQ.
- `--version` now reports `4.0.3`.

## [4.0.2] — 2026-06-19

Documentation cleanup. No engine change.

### Added
- README (all six languages): an **"Unlock strategy history"** section
  documenting how the macOS unlocker evolved — Goldberg Steam Emulator
  (1.x–2.x, single-player only) → CreamAPI `unlockall = true` (3.0) → CreamAPI
  explicit `[dlc]` list (4.0.1+).

### Removed
- `docs/superpowers/specs/…v4.0-modular-rewrite-design.md` — an internal draft
  design note that still locked in the abandoned `unlockall = true` decision and
  was not useful to end users (kept in git history).

### Fixed
- CHANGELOG `[4.0]` entry: the DLC-strategy line still described the abandoned
  `unlockall = true` plan instead of the shipped explicit-`[dlc]`-list behavior.
- `--version` now reports `4.0.2`.

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
- DLC strategy: explicit `[dlc]` list (`unlockall = false`) built at install
  time from the game's own `dlc/*.dlc` metadata, de-duplicated by Steam appid.
  This replaces the original design's `unlockall = true` plan, which only
  unlocked a fraction of EU4's DLC because Steam's runtime DLC list comes back
  truncated for big-DLC games. Falls back to `unlockall = true` if no DLC
  metadata is found; rebuilt on every install.
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
