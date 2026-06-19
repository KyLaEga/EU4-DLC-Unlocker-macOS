# EU4 DLC Unlocker for macOS

**Version 4.0.1 — modular engine, CreamAPI v5.3.0.0, complete DLC unlock, multiplayer supported**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-macOS-blue.svg)](https://www.apple.com/macos/)
[![Game](https://img.shields.io/badge/Game-Europa%20Universalis%20IV-red.svg)](https://store.steampowered.com/app/236850/)
[![ShellCheck](https://github.com/KyLaEga/EU4-DLC-Unlocker-macOS/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/KyLaEga/EU4-DLC-Unlocker-macOS/actions/workflows/shellcheck.yml)

**🌍 Languages:** [English](README.md) | [Русский](docs/README_RU.md) | [Deutsch](docs/README_DE.md) | [Français](docs/README_FR.md) | [Español](docs/README_ES.md) | [中文](docs/README_ZH.md)

---

## ⚠️ Disclaimer & legal warning

> **For educational purposes only. Use at your own risk.**
>
> - You must **own a legitimate copy of Europa Universalis IV on Steam**. This
>   tool does **not** download any DLC — it only flips ownership state for DLC
>   content that is already present in your game files.
> - Using a DLC unlocker **violates the Steam Subscriber Agreement and
>   Paradox's EULA**. In principle this can lead to a **VAC / account ban or
>   suspension**. EU4 has no VAC-secured servers, so the practical risk is low,
>   but it is **not zero** — you accept it yourself.
> - The authors are not responsible for any consequences. If you enjoy the
>   game, **please buy the DLC and support Paradox Interactive.**

---

## 📖 Description

A DLC unlocker for **Europa Universalis IV** on **macOS**. It uses
[CreamAPI v5.3.0.0](https://cs.rin.ru/forum/viewtopic.php?f=29&t=70576) to
unlock DLC ownership for a game you legitimately own on Steam.

### How it works

The tool installs CreamAPI's `libsteam_api.dylib` (a drop-in proxy in front of
the real Steam library) into the game's `eu4.app/Contents/Frameworks/`, backs
up the original as `libsteam_api_o.dylib`, and writes a `cream_api.ini`. At
launch the game asks Steam which DLC you own; CreamAPI answers "yes" for each
unlocked DLC while still proxying everything else to the real Steam, so
**multiplayer keeps working**.

At install time the unlocker **enumerates the game's own `dlc/*.dlc` metadata**
and writes an explicit `[dlc]` list (`unlockall = false`). This is deliberate:
EU4 ships 130+ content packs, and CreamAPI's `unlockall = true` mode relies on
Steam's *runtime* DLC list, which comes back **truncated** for big-DLC games —
so only a fraction would unlock. Building the list from the content you already
have is complete and **works offline after the first launch**. The list is
rebuilt on every install, so adding new DLC content and re-running the
installer keeps it current. If no DLC metadata is found, it falls back to
`unlockall = true`.

### Features

- ✅ **Multiplayer supported** (CreamAPI proxies to the real Steam)
- ✅ Complete DLC unlock — explicit list built from your own `dlc/` content (no truncation, offline-safe), rebuilt on every install
- ✅ Automatic detection of the EU4 install (internal disk **and** external drives)
- ✅ Safe backup of the original library; clean, reversible uninstall
- ✅ Non-mutating `status` command to check what's installed
- ✅ Integrity-checked, **universal** binary (native Intel **and** Apple Silicon)

---

## 📋 Requirements

### Supported platforms

| Platform     | Architecture          | Status                  |
|--------------|-----------------------|-------------------------|
| macOS 10.13+ | Intel (x86_64)        | ✅ Native               |
| macOS 11+    | Apple Silicon (M1–M4) | ✅ Native (arm64)       |

The shipped `libsteam_api.dylib` is a **universal** (fat) binary containing both
`x86_64` and `arm64` slices — **no Rosetta 2 required** on Apple Silicon.

### Prerequisites

- macOS 10.13 (High Sierra) or newer
- Europa Universalis IV, legitimately purchased on Steam
- The DLC **content files** (must already be present — this tool does not download them)
- Xcode Command Line Tools recommended (`xcode-select --install`) for `codesign`/`xattr`

---

## 🚀 Installation

**TL;DR** — three commands, then launch the game:

```bash
git clone https://github.com/KyLaEga/EU4-DLC-Unlocker-macOS.git
cd EU4-DLC-Unlocker-macOS
./install_dlc_unlocker.sh
```

### Step by step

1. **Make sure the DLC content is in place first.** Your game's `dlc/` folder
   must already contain the DLC packs (this tool unlocks ownership, it does not
   download content). See
   [Where do I get the DLC content files?](#where-do-i-get-the-dlc-content-files)
   below if it's empty.

2. **Clone or download** this repository:
   ```bash
   git clone https://github.com/KyLaEga/EU4-DLC-Unlocker-macOS.git
   cd EU4-DLC-Unlocker-macOS
   ```

3. **Run the installer:**
   ```bash
   ./install_dlc_unlocker.sh
   ```
   This is a thin wrapper around `./bin/unlocker install eu4`. The tool
   verifies the shipped library, auto-detects your EU4 install (internal disk
   **and** external drives), backs up the original as `libsteam_api_o.dylib`,
   installs CreamAPI, builds the explicit DLC list from your `dlc/` content,
   and ad-hoc re-signs the result for macOS Gatekeeper.

   If your game lives somewhere unusual, point the tool at it directly:
   ```bash
   ./bin/unlocker install eu4 --path "/Volumes/My Drive/SteamLibrary/steamapps/common/Europa Universalis IV"
   ```

4. **Launch EU4 through Steam.** With the explicit `[dlc]` list this works
   offline too. **Important:** if the game or the Paradox launcher was already
   open, fully **quit it (`⌘Q`)** and relaunch — CreamAPI reads `cream_api.ini`
   only once at process start.

### Verify it worked

Check the patch state without changing anything:
```bash
./bin/unlocker status eu4
```
You want to see:
```
[+] Patch state:     INSTALLED (CreamAPI active)
[+] Original backup: PRESENT (...libsteam_api_o.dylib)
[+] cream_api.ini:   PRESENT
[*]   unlockall = false; explicit [dlc] list (N DLC)
```
Then open the **DLC tab** in the Paradox launcher — every DLC whose content is
present should now be owned (no "Buy" buttons, no warning icons).

---

## 🛠️ Usage (`unlocker` CLI)

The single entrypoint is `bin/unlocker`; the two `*_dlc_unlocker.sh` scripts are
thin wrappers kept for backward compatibility.

```text
./bin/unlocker install   [eu4]   # back up original + apply CreamAPI patch
./bin/unlocker uninstall [eu4]   # restore the original library
./bin/unlocker status    [eu4]   # non-mutating: show patch / backup / integrity
./bin/unlocker --help
./bin/unlocker --version

Options (after the command):
  --yes          Non-interactive; assume "yes" to confirmations.
  --path DIR     Use this game directory instead of auto-detecting.
```

Check state without changing anything:
```bash
./bin/unlocker status eu4
```

### What `install` does under the hood

1. **Integrity gate** — refuses to run unless the shipped `libsteam_api.dylib`
   matches the committed SHA256 (tamper/corruption guard).
2. **Locate the game** — expands the search paths from `games/eu4.conf` (handles
   spaces and external `/Volumes/*` drives); or uses `--path`.
3. **Back up** the original library as `libsteam_api_o.dylib` (never overwrites
   an existing good backup).
4. **Install CreamAPI** — copies the proxy dylib over `libsteam_api.dylib` and
   re-checks the copy's hash before re-signing.
5. **Build `cream_api.ini`** — scans `dlc/*/*.dlc`, collects each `steam_id`,
   de-duplicates, and writes an explicit `[dlc]` list with `unlockall = false`.
6. **macOS hardening** — strips the quarantine attribute (`xattr`) and ad-hoc
   re-signs the dylib (`codesign -s -`) so Gatekeeper loads it inside the game.

`uninstall` reverses steps 3–4 (restore the backup, delete `cream_api.ini`,
re-sign). `status` reports all of the above and changes nothing.

---

## 🗑️ Uninstallation

```bash
./uninstall_dlc_unlocker.sh
# or: ./bin/unlocker uninstall eu4
```

This restores `libsteam_api.dylib` from the backup, removes `cream_api.ini`,
re-signs the original, and cleans up any legacy artifacts.

> Running Steam's **"Verify Integrity of Game Files"** silently restores the
> original library and removes the patch — that is expected. Re-run the
> installer to re-apply, or `status` to confirm the current state.

---

## ❓ FAQ

### DLCs show warning icons in the launcher
The DLC **content files** are missing. The unlocker only changes ownership
state — the actual content must be present in the game's `dlc/` folder.

### Where do I get the DLC content files?
This tool does **not** distribute or download DLC — you bring your own. Paradox
DLC content is cross-platform, so the usual route is to **copy the `dlc/`
folder from a machine where you already have it** (e.g. a Windows or Linux
install you own) into your Mac install at:
```
.../steamapps/common/Europa Universalis IV/dlc/
```
Each DLC lives in its own subfolder (`dlc/dlcNNN_name/`) containing a `.dlc`
metadata file, a `.zip`, and a thumbnail. After copying, run the installer (or
re-run it) so the `[dlc]` list is rebuilt from the new content.

**Got the content as a multi-part archive (`*.zip.001`, `*.zip.002`, …)?**
Those parts are **one** archive split into chunks — not separate zips. Join and
extract them on macOS like this (you don't extract each part separately):
```bash
# 7-Zip handles the LZMA compression EU4 packs often use, and reads all parts
# automatically when you point it at the first one:
brew install sevenzip
7zz x "DLC-….zip.001" -o"/path/to/Europa Universalis IV"   # writes the dlc/ tree

# Alternatively, concatenate the parts back into one file first (order matters):
cat DLC-….zip.00{1,2,3,4} > DLC-….zip
7zz x DLC-….zip -o"/path/to/Europa Universalis IV"
```
Point `-o` at the game folder (the parent of `dlc/`) — the archive already
contains a top-level `dlc/`, so extracting there merges it into place.

### Why does `status` show fewer DLC than I have folders?
That's correct, nothing is missing. The `dlc/` folder holds **content packs**
(134 for the full game), but Steam sells them as fewer **purchases** — one
purchase often bundles several packs (an expansion + its unit pack + its music
pack share a single Steam appid). The unlocker grants ownership **per Steam
appid**, so e.g. ~75 appids cover all 134 packs. `status` reports the number of
appids; the launcher shows all the packs they unlock.

### Steam "Verify Integrity of Game Files" reverted my patch
Expected — Steam replaced our library with the original. Run
`./bin/unlocker status eu4` to confirm, then re-run the installer.

### The game won't launch
macOS Gatekeeper may be blocking the modified library. The installer already
strips the quarantine attribute and ad-hoc re-signs the dylib, but if you
copied files manually:
```bash
xattr -dr com.apple.quarantine "/path/to/eu4.app"
codesign --force -s - "/path/to/eu4.app/Contents/Frameworks/libsteam_api.dylib"
```
Install the Command Line Tools first if `codesign`/`xattr` are missing:
`xcode-select --install`. Still stuck? Run the uninstaller and try again.

### Is the bundled library safe?
The shipped `libsteam_api.dylib` is byte-identical to the official CreamAPI
*nonlog* macOS build and scores **0/64 on VirusTotal**. You can re-verify the
checksum yourself — see [docs/SECURITY.md](docs/SECURITY.md) and
[vendor/creamapi/VERSION.txt](vendor/creamapi/VERSION.txt). (Note: the binary
embeds an upstream build path in its install name; that is harmless and is what
the tool actually uses to detect an installed patch.)

### Which DLCs are unlocked?
**Every DLC whose content is present in your `dlc/` folder.** The installer
reads each `dlc/*.dlc` file, collects its Steam appid, and writes the full set
into `cream_api.ini`'s `[dlc]` section. Added new DLC content? Re-run the
installer and the list is rebuilt. (We avoid `unlockall = true` on purpose —
Steam's runtime DLC list is truncated for EU4, so it would unlock only a
fraction. `status eu4` prints how many DLC the current config covers.)

### Can I unlock another Paradox game?
The engine is game-agnostic. Adding e.g. CK3 needs only a new
`games/<game>.conf` (appid + search paths) — no code change. Only EU4 ships
today; see [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md).

---

## 🔐 Security & integrity

The installer refuses to run if the shipped dylib's SHA256 does not match
`vendor/creamapi/VERSION.txt` (tamper/corruption guard), and CI re-verifies it
on every push. See [docs/SECURITY.md](docs/SECURITY.md).

## 🙏 Credits

- [CreamAPI](https://cs.rin.ru/forum/viewtopic.php?f=29&t=70576) — the DLC unlocker library
- Inspired by CreamInstaller (repo no longer available)

## 📜 License

Licensed under the MIT License — see [LICENSE](LICENSE).

## ⭐ Support

If this helped you: ⭐ star the repo, 🐛 report issues, 💡 suggest improvements.
**And if you enjoy EU4 and its DLC, please buy them to support Paradox Interactive.**
