# Getting your DLC content into the macOS install

This unlocker changes DLC **ownership** — it does **not** download or distribute
DLC content. You bring the content files yourself, from a copy you legitimately
own. This guide covers the two things people actually get stuck on:

1. [Copying the `dlc/` folder from a legal install](#1-copy-the-dlc-folder-from-a-legal-install)
2. [Joining a multi-part (split) archive on macOS](#2-join-a-multi-part-split-archive-on-macos)

> ⚠️ You must own a legitimate copy of Europa Universalis IV on Steam. This is
> about moving content you **already have** onto your Mac — not obtaining it.
> If you don't own the DLC, please buy it and support Paradox Interactive.

---

## 1. Copy the `dlc/` folder from a legal install

Paradox DLC content is **cross-platform** — the exact same files work on Windows,
Linux and macOS. If you own EU4 and its DLC on another machine, copy the content
across.

### Where the `dlc/` folder lives

| Platform | Typical path |
|----------|--------------|
| Windows  | `…\Steam\steamapps\common\Europa Universalis IV\dlc\` |
| Linux    | `~/.steam/steam/steamapps/common/Europa Universalis IV/dlc/` |
| macOS    | `~/Library/Application Support/Steam/steamapps/common/Europa Universalis IV/dlc/` |

On macOS the Steam library is often on an external drive instead, e.g.
`/Volumes/<drive>/SteamLibrary/steamapps/common/Europa Universalis IV/dlc/`.

### Steps

1. On the source machine, open the game's `dlc/` folder. Each DLC is a subfolder
   named `dlcNNN_<name>/` containing three files:
   - `dlcNNN.dlc` — metadata (the unlocker reads the Steam appid from here),
   - `dlcNNN.zip` — the actual content,
   - `thumbnail.png`.
2. Copy the **subfolders** (or the whole `dlc/` folder) onto your Mac, into:
   ```
   …/Europa Universalis IV/dlc/
   ```
3. Re-run the installer so the unlock list is rebuilt from the new content:
   ```bash
   ./bin/unlocker install eu4
   ```
4. Verify:
   ```bash
   ./bin/unlocker status eu4     # → unlockall = false; explicit [dlc] list (N DLC)
   ```
   Then open the Paradox launcher's **DLC** tab — everything whose content is
   present should be owned.

### Common mistakes

- **Wrong target folder.** Content goes in `…/Europa Universalis IV/dlc/` — not
  inside the `eu4.app` bundle, and not in a nested `…/dlc/dlc/`. Each DLC should
  end up at `…/Europa Universalis IV/dlc/dlcNNN_<name>/`.
- **Flattening the structure.** Keep each `dlcNNN_<name>/` folder intact; don't
  dump the loose `.zip`/`.dlc` files directly into `dlc/`.
- **Leaving the `.dlc` file behind.** The unlocker reads each `.dlc` file's
  `steam_id`; without it, that DLC won't be added to the list.
- **Quarantine on copied/downloaded files.** If the launcher acts up after a
  manual copy:
  ```bash
  xattr -dr com.apple.quarantine "…/Europa Universalis IV/dlc"
  ```
- **Overwriting newer content with an older pack.** If you already had some DLC,
  keep the newer copies. Re-running `install` only rebuilds the list — it never
  deletes your content.

---

## 2. Join a multi-part (split) archive on macOS

Content is sometimes distributed as one archive split into parts:
`Something.zip.001`, `Something.zip.002`, … These are **one** archive cut into
chunks — **not** separate zips. Extracting each part on its own is the usual
source of "duplicate files" / error confusion. Join them and extract **once**.

Two macOS-specific gotchas:

- The built-in `unzip` and Archive Utility usually **can't** handle the **LZMA**
  compression these packs use, and they don't understand split sets at all.
- So use **7-Zip** (`7zz`): it handles LZMA and reads every part automatically
  when you point it at the **first** one (`.001`).

### Install 7-Zip

```bash
brew install sevenzip      # installs the `7zz` command
```

### Check the parts before extracting

```bash
ls -la *.zip.0??           # all parts present and in order: .001 .002 .003 …?
7zz l "Something.zip.001"  # list contents — should show  Type = Split, Volumes = N
```

`7zz l` reads the whole set starting from `.001`. If it lists the file tree
without error, the set is complete and in the right order.

### Extract

```bash
# Point -o at the GAME folder (the PARENT of dlc/). The archive already contains
# a top-level dlc/, so it merges into place:
7zz x "Something.zip.001" -o"/path/to/Europa Universalis IV"
```

Alternative — physically concatenate the parts first (order matters):

```bash
cat Something.zip.00{1,2,3,4} > Something.zip
7zz x Something.zip -o"/path/to/Europa Universalis IV"
```

### Verify integrity

```bash
7zz t "Something.zip.001"   # test every part; "Everything is Ok" means good
```

### Troubleshooting `7zz`

| Symptom | Cause / fix |
|---------|-------------|
| `Cannot find archive` / `No more files` | A part is missing or misnamed. They must form a continuous `.001 .002 .003 …` with no gaps, all in the same folder. |
| `Data Error` / `Unexpected end of archive` | A part is corrupt or only partly downloaded. Re-download that part and re-check sizes (all parts except the last are usually identical in size). |
| `Unsupported Method` (with `unzip`/Archive Utility) | That's the LZMA limitation — use `7zz`, not `unzip` or Archive Utility. |
| Files landed in `…/dlc/dlc/…` | You pointed `-o` at the `dlc/` folder. Point it at the **game** folder (the parent) instead. |
| `command not found: 7zz` | Run `brew install sevenzip` (the formula is `sevenzip`; the command it provides is `7zz`). |

After extracting, run `./bin/unlocker install eu4` so the DLC list picks up the
new content, then `./bin/unlocker status eu4` to confirm.

---

> This unlocker does not host, link to, or download DLC content. If you don't
> already own the DLC, please buy it and support **Paradox Interactive**.
