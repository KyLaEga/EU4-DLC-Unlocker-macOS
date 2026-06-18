# Security & integrity

## The bundled CreamAPI library

This repository ships one binary: `vendor/creamapi/libsteam_api.dylib`.

- **Build:** CreamAPI v5.3.0.0, official *nonlog* macOS build.
- **Architectures:** universal — `x86_64` + `arm64`.
- **SHA256:** `13f49f08eaf3e4f48103173605793c8da1bcaa04bf6f4a3adbd0b29a6ef5c0d9`
- **VirusTotal:** 0/64 detections —
  <https://www.virustotal.com/gui/file/13f49f08eaf3e4f48103173605793c8da1bcaa04bf6f4a3adbd0b29a6ef5c0d9/detection>

The file is **byte-identical** to the official release archive's
`nonlog_build/macos/libsteam_api.dylib`. It is closed-source, so it cannot be
built from source here — instead its integrity is pinned by checksum.

### Verify it yourself

```bash
shasum -a 256 vendor/creamapi/libsteam_api.dylib | awk '{print $1}'
cat  vendor/creamapi/libsteam_api.dylib.sha256
```

Both must print the SHA256 above. The installer performs this check
automatically and **refuses to run on a mismatch** (exit code 4), and CI
re-verifies it on every push (`.github/workflows/verify-dylib.yml`).

### Known cosmetic artifact (harmless)

`otool -L`/`otool -D` show an upstream build path embedded in the library's
install name:

```
/Users/Shared/repos/cream_api_clean/../build/nonlog_build/macos/libsteam_api.dylib
```

This is a leftover of how the upstream binary was built; it is **not** a path on
your machine and exposes nothing about your system. The unlocker actually uses
the `cream_api_clean` marker in this name to detect an installed patch (it
survives the ad-hoc re-sign that changes the file hash).

## Reporting a vulnerability or a tampered binary

If you believe the shipped dylib has been tampered with, or you find a security
issue in the scripts:

1. **Do not** open a public issue with exploit details first.
2. Email the maintainer or open a minimal private report.
3. Include the output of the two `shasum`/`cat` commands above and your macOS
   version + architecture (`uname -m`).

A checksum that does not match the value in this file is the single most
important signal — report it.

## Threat model / scope

- The scripts only touch the EU4 `Frameworks` directory: they copy the vendored
  dylib, write `cream_api.ini`, back up the original, and re-sign/de-quarantine.
- They do not phone home, download anything, or require root.
- Using a DLC unlocker violates the Steam Subscriber Agreement and Paradox's
  EULA and can in principle lead to account action. That is a policy risk, not a
  software vulnerability — see the README disclaimer.
