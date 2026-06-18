---
name: Bug report
about: Something doesn't work (game not found, won't launch, DLC not unlocked)
title: "[bug] "
labels: bug
---

## What happened

<!-- A clear description of the problem. -->

## What you expected

## Steps to reproduce

1. `./bin/unlocker ...`
2. ...

## `status` output

<!-- Paste the FULL output of the read-only status command. It reveals most
issues (game found? patch installed? backup present? integrity OK?). -->

```
$ ./bin/unlocker status eu4
...
```

## Environment

- macOS version:
- Architecture (`uname -m`): <!-- arm64 or x86_64 -->
- Steam library location: <!-- internal disk / external drive; does the path contain spaces? -->
- Xcode Command Line Tools installed? (`xcode-select -p` prints a path):

## Integrity check (paste both lines)

```
$ shasum -a 256 vendor/creamapi/libsteam_api.dylib | awk '{print $1}'
$ cat vendor/creamapi/libsteam_api.dylib.sha256
```

<!-- If these two do NOT match, see docs/SECURITY.md before anything else. -->
