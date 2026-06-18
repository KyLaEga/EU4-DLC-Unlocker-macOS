# CreamAPI vendor bundle

This directory holds the unmodified **nonlog macOS** build of CreamAPI v5.3.0.0,
used by the unlocker to proxy the game's Steam API calls.

- `libsteam_api.dylib` — the CreamAPI proxy library (universal: x86_64 + arm64)
- `VERSION.txt` — version + expected SHA256
- `libsteam_api.dylib.sha256` — the expected SHA256 (bare hex, no newline tricks)

## Verification

The installer verifies the dylib against the committed SHA256 before copying it
anywhere. If the file is corrupted or tampered with, installation aborts.

To re-verify manually:

```bash
shasum -a 256 vendor/creamapi/libsteam_api.dylib | awk '{print $1}'
cat vendor/creamapi/libsteam_api.dylib.sha256
```

## Updating CreamAPI

1. Replace `libsteam_api.dylib` with the new `nonlog_build/macos/libsteam_api.dylib`
   from the official release archive.
2. Regenerate the checksum:
   `shasum -a 256 libsteam_api.dylib | awk '{print $1}' > libsteam_api.dylib.sha256`
3. Update `VERSION.txt` with the new version + SHA256.
4. Commit. CI (`verify-dylib.yml`) asserts the committed dylib matches the SHA256.
