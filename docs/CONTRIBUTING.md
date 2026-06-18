# Contributing

Thanks for helping out. This is a small, security-sensitive Bash project — the
bar is "clean, safe, and boring."

## Project layout

```
bin/unlocker          single CLI entrypoint (install / uninstall / status)
bin/lib/*.sh          engine: common.sh + one file per subcommand (sourced)
games/<game>.conf     per-game data (appid, search paths) — no logic
config/*.tmpl         cream_api.ini template (appid placeholder)
vendor/creamapi/      pinned CreamAPI dylib + checksum
docs/                 READMEs (6 languages), CHANGELOG, SECURITY, this file
.github/workflows/    CI: shellcheck, link check, dylib verification
```

The engine is **game-agnostic**. Anything EU4-specific lives in data files.

## Coding rules

- Every script starts with `set -euo pipefail`.
- `shellcheck` must pass clean on **every** file:
  ```bash
  shellcheck -x bin/unlocker bin/lib/*.sh install_dlc_unlocker.sh uninstall_dlc_unlocker.sh
  ```
  CI enforces this. Use `read -r`, quote variables, and avoid `eval` on paths
  (paths contain spaces — that bug has bitten this project before).
- Target macOS's system bash (3.2): no associative arrays, no `mapfile`/`readarray`.
- Check the result of every `cp` / `find` / `codesign`. No silent success.
- Keep `bin/unlocker` executable (`chmod +x`); the wrappers `exec` it.

## Adding another Paradox game

No engine change required:

1. Create `games/<game>.conf` (copy `games/eu4.conf`):
   - `game_name`, `appid` (from the Steam store URL), `app_bundle`,
     `framework_subdir`, and a `search_paths` block.
2. Test: `./bin/unlocker status <game>` then a full install/uninstall cycle.

## Manual test checklist (before a release)

Run on **both** Intel and Apple Silicon if possible, and once with a game path
that **contains a space**:

1. `./bin/unlocker status eu4` → reports NOT installed, integrity OK (no writes).
2. `./bin/unlocker install eu4` → backs up, installs, re-signs; no spurious
   warnings.
3. `./bin/unlocker status eu4` → reports **INSTALLED**, backup PRESENT.
4. `./bin/unlocker install eu4` again → "already the CreamAPI patch" (idempotent).
5. `./bin/unlocker uninstall eu4` → restores the original.
6. The restored `libsteam_api.dylib` is **byte-identical** to the pre-install
   original (`shasum -a 256`).
7. Launch EU4 via Steam (online) → DLC unlocked, multiplayer works.

A quick sandbox version of steps 1–6 (no real game needed):

```bash
SB="/tmp/eu4 sb/Europa Universalis IV/eu4.app/Contents/Frameworks"
mkdir -p "$SB"; printf 'ORIGINAL' > "$SB/libsteam_api.dylib"
./bin/unlocker install   eu4 --path "/tmp/eu4 sb" --yes
./bin/unlocker status    eu4 --path "/tmp/eu4 sb"
./bin/unlocker uninstall eu4 --path "/tmp/eu4 sb" --yes
```

## Updating the CreamAPI dylib

See `vendor/creamapi/README.md`. After replacing the binary, regenerate
`libsteam_api.dylib.sha256` and update `VERSION.txt`; CI will verify the match.

## Documentation

The English `README.md` is canonical. If you change it, update the five
translations in `docs/README_*.md` to match (structure and claims), and add a
`CHANGELOG.md` entry. Do not reintroduce removed content (Goldberg,
"single-player only", "Rosetta 2 required", a fixed DLC count).
