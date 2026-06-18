# EU4 DLC Unlocker für macOS

**Version 4.0 — modulare Engine, CreamAPI v5.3.0.0, vollständige DLC-Freischaltung, Multiplayer unterstützt**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-macOS-blue.svg)](https://www.apple.com/macos/)
[![Game](https://img.shields.io/badge/Game-Europa%20Universalis%20IV-red.svg)](https://store.steampowered.com/app/236850/)

**🌍 Sprachen:** [English](../README.md) | [Русский](README_RU.md) | [Deutsch](README_DE.md) | [Français](README_FR.md) | [Español](README_ES.md) | [中文](README_ZH.md)

---

## ⚠️ Haftungsausschluss & rechtlicher Hinweis

> **Nur zu Bildungszwecken. Verwendung auf eigene Gefahr.**
>
> - Sie müssen eine **legale Kopie von Europa Universalis IV auf Steam besitzen**.
>   Dieses Tool lädt **keine** DLC herunter — es ändert nur den Besitzstatus für
>   DLC, deren Dateien bereits im Spiel vorhanden sind.
> - Ein DLC-Unlocker **verstößt gegen die Steam-Nutzungsbedingungen und die
>   Paradox-EULA**. Grundsätzlich kann das zu einer **VAC-/Kontosperre** führen.
>   EU4 hat keine VAC-geschützten Server, daher ist das praktische Risiko gering,
>   aber **nicht null** — Sie tragen es selbst.
> - Die Autoren haften nicht für Folgen. Wenn Ihnen das Spiel gefällt,
>   **kaufen Sie die DLC und unterstützen Sie Paradox Interactive.**

---

## 📖 Beschreibung

Ein DLC-Unlocker für **Europa Universalis IV** auf **macOS**. Er verwendet
[CreamAPI v5.3.0.0](https://cs.rin.ru/forum/viewtopic.php?f=29&t=70576), um den
DLC-Besitz für ein legal auf Steam erworbenes Spiel freizuschalten.

### Funktionsweise

Das Tool installiert die `libsteam_api.dylib` von CreamAPI (ein Proxy vor der
echten Steam-Bibliothek) in `eu4.app/Contents/Frameworks/`, sichert das Original
als `libsteam_api_o.dylib` und schreibt eine `cream_api.ini`. Beim Start fragt
das Spiel Steam, welche DLC Sie besitzen; CreamAPI antwortet für jedes
freigeschaltete DLC mit „ja“ und leitet alles andere an das echte Steam weiter —
daher **funktioniert der Multiplayer weiterhin**.

Bei der Installation liest das Tool die `dlc/*.dlc`-Metadaten des Spiels und
schreibt eine explizite `[dlc]`-Liste (`unlockall = false`). Das ist Absicht:
EU4 hat 130+ Inhaltspakete, und `unlockall = true` stützt sich auf Steams
*Laufzeit*-DLC-Liste, die bei vielen DLC **abgeschnitten** zurückkommt — dann
wird nur ein Teil freigeschaltet. Die aus Ihren eigenen Inhalten gebaute Liste
ist **vollständig** und **funktioniert offline**. Sie wird bei jeder
Installation neu erstellt. Werden keine DLC-Metadaten gefunden, fällt das Tool
auf `unlockall = true` zurück.

### Funktionen

- ✅ **Multiplayer unterstützt** (CreamAPI leitet an das echte Steam weiter)
- ✅ Vollständige DLC-Freischaltung — explizite Liste aus Ihren eigenen `dlc/`-Inhalten (nicht abgeschnitten, offline-fähig), bei jeder Installation neu erstellt
- ✅ Automatische Erkennung der EU4-Installation (interne **und** externe Laufwerke)
- ✅ Sichere Sicherung des Originals; saubere, umkehrbare Deinstallation
- ✅ `status`-Befehl ohne Änderungen — zeigt, was installiert ist
- ✅ Prüfsummengesichertes **universelles** Binary (nativ Intel **und** Apple Silicon)

---

## 📋 Anforderungen

### Unterstützte Plattformen

| Plattform    | Architektur           | Status                  |
|--------------|-----------------------|-------------------------|
| macOS 10.13+ | Intel (x86_64)        | ✅ Nativ                |
| macOS 11+    | Apple Silicon (M1–M4) | ✅ Nativ (arm64)        |

Die mitgelieferte `libsteam_api.dylib` ist ein **universelles** (fat) Binary mit
beiden Slices `x86_64` und `arm64` — **kein Rosetta 2 auf Apple Silicon nötig**.

### Voraussetzungen

- macOS 10.13 (High Sierra) oder neuer
- Europa Universalis IV, legal auf Steam erworben
- Die DLC-**Inhaltsdateien** (müssen bereits vorhanden sein — werden nicht heruntergeladen)
- Empfohlen: Xcode Command Line Tools (`xcode-select --install`) für `codesign`/`xattr`

---

## 🚀 Installation

1. **Repository klonen oder herunterladen:**
   ```bash
   git clone https://github.com/KyLaEga/EU4-DLC-Unlocker-macOS.git
   cd EU4-DLC-Unlocker-macOS
   ```

2. **Installer ausführen:**
   ```bash
   ./install_dlc_unlocker.sh
   ```
   Ein dünner Wrapper um `./bin/unlocker install eu4`. Das Tool verifiziert die
   mitgelieferte Bibliothek, erkennt die EU4-Installation, sichert das Original,
   installiert CreamAPI und signiert das Ergebnis für Gatekeeper neu.

3. **EU4 über Steam starten** (beim ersten Mal online, damit die DLC aufgelöst werden).

Liegt das Spiel an einem ungewöhnlichen Ort, geben Sie den Pfad direkt an:
```bash
./bin/unlocker install eu4 --path "/Volumes/My Drive/SteamLibrary/steamapps/common/Europa Universalis IV"
```

---

## 🛠️ Verwendung (`unlocker`-CLI)

Der einzige Einstiegspunkt ist `bin/unlocker`; die beiden `*_dlc_unlocker.sh`
sind dünne Wrapper zur Abwärtskompatibilität.

```text
./bin/unlocker install   [eu4]   # Original sichern + CreamAPI installieren
./bin/unlocker uninstall [eu4]   # Originalbibliothek wiederherstellen
./bin/unlocker status    [eu4]   # ohne Änderung: Patch / Sicherung / Integrität
./bin/unlocker --help
./bin/unlocker --version

Optionen (nach dem Befehl):
  --yes          Nicht-interaktiv; „ja“ annehmen.
  --path DIR     Dieses Spielverzeichnis statt Auto-Erkennung verwenden.
```

Status ohne Änderung prüfen:
```bash
./bin/unlocker status eu4
```

---

## 🗑️ Deinstallation

```bash
./uninstall_dlc_unlocker.sh
# oder: ./bin/unlocker uninstall eu4
```

Stellt `libsteam_api.dylib` aus der Sicherung wieder her, entfernt
`cream_api.ini`, signiert das Original neu und räumt veraltete Artefakte auf.

> Steams **„Spieldateien auf Fehler überprüfen“** stellt stillschweigend die
> Originalbibliothek wieder her und entfernt den Patch — das ist normal. Führen
> Sie den Installer erneut aus oder `status`, um den Zustand zu prüfen.

---

## ❓ FAQ

### DLCs zeigen Warnsymbole im Launcher
Die DLC-**Inhaltsdateien** fehlen. Der Unlocker ändert nur den Besitzstatus —
der eigentliche Inhalt muss im `dlc/`-Ordner des Spiels liegen.

### Wo bekomme ich die DLC-Inhaltsdateien?
Paradox-DLC-Inhalte sind plattformübergreifend. Wenn Sie sie von einer
Windows-/Linux-Installation haben, kopieren Sie den Inhalt des `dlc/`-Ordners
in Ihre Mac-Installation.

### Steam „Spieldateien überprüfen“ hat meinen Patch zurückgesetzt
Normal — Steam hat unsere Bibliothek durch das Original ersetzt. Prüfen Sie mit
`./bin/unlocker status eu4` und installieren Sie erneut.

### Das Spiel startet nicht
macOS Gatekeeper blockiert evtl. die modifizierte Bibliothek. Der Installer
entfernt bereits das Quarantäne-Attribut und signiert die dylib ad-hoc neu;
falls Sie Dateien manuell kopiert haben:
```bash
xattr -dr com.apple.quarantine "/pfad/zu/eu4.app"
codesign --force -s - "/pfad/zu/eu4.app/Contents/Frameworks/libsteam_api.dylib"
```
Fehlen `codesign`/`xattr`, installieren Sie zuerst die Command Line Tools:
`xcode-select --install`. Weiterhin Probleme? Deinstallieren und erneut versuchen.

### Ist die mitgelieferte Bibliothek sicher?
Die mitgelieferte `libsteam_api.dylib` ist Byte-identisch mit dem offiziellen
CreamAPI-*nonlog*-macOS-Build und erreicht **0/64 auf VirusTotal**. Sie können
die Prüfsumme selbst nachprüfen — siehe [docs/SECURITY.md](SECURITY.md) und
[vendor/creamapi/VERSION.txt](../vendor/creamapi/VERSION.txt). (Hinweis: Das
Binary enthält im Install-Name einen Upstream-Build-Pfad; das ist harmlos und
genau daran erkennt das Tool einen installierten Patch.)

### Welche DLC werden freigeschaltet?
**Jedes DLC, dessen Inhalt in Ihrem `dlc/`-Ordner liegt.** Der Installer liest
jede `dlc/*.dlc`-Datei, sammelt deren Steam-App-ID und schreibt den gesamten
Satz in den `[dlc]`-Abschnitt der `cream_api.ini`. Neue Inhalte hinzugefügt?
Installer erneut ausführen, dann wird die Liste neu gebaut. (`unlockall = true`
vermeiden wir bewusst — Steams Laufzeitliste ist bei EU4 abgeschnitten und würde
nur einen Teil freischalten. `status eu4` zeigt, wie viele DLC abgedeckt sind.)

### Warum zeigt `status` weniger DLC als ich Ordner habe?
Das ist korrekt, es fehlt nichts. Der `dlc/`-Ordner enthält **Inhaltspakete**
(134 beim Vollspiel), aber Steam verkauft sie als weniger **Käufe** — ein Kauf
bündelt oft mehrere Pakete (eine Erweiterung + ihr Unit-Pack + ihr Music-Pack
teilen sich eine Steam-App-ID). Das Tool schaltet **pro Steam-App-ID** frei, so
decken z. B. ~75 App-IDs alle 134 Pakete ab. `status` zeigt die Zahl der
App-IDs; der Launcher zeigt alle Pakete, die sie freischalten.

### Kann ich ein anderes Paradox-Spiel freischalten?
Die Engine ist spielunabhängig. Für z. B. CK3 genügt eine neue
`games/<game>.conf` (appid + Suchpfade) — keine Code-Änderung. Aktuell wird nur
EU4 ausgeliefert; siehe [docs/CONTRIBUTING.md](CONTRIBUTING.md).

---

## 🔐 Sicherheit & Integrität

Der Installer startet nicht, wenn die SHA256 der mitgelieferten dylib nicht mit
`vendor/creamapi/VERSION.txt` übereinstimmt (Schutz vor Manipulation/Korruption),
und CI prüft das bei jedem Push erneut. Siehe [docs/SECURITY.md](SECURITY.md).

## 🙏 Danksagungen

- [CreamAPI](https://cs.rin.ru/forum/viewtopic.php?f=29&t=70576) — die DLC-Unlocker-Bibliothek
- Inspiriert von CreamInstaller (repo no longer available)

## 📜 Lizenz

Lizenziert unter der MIT-Lizenz — siehe [LICENSE](../LICENSE).

## ⭐ Unterstützung

Wenn es geholfen hat: ⭐ Repo mit Stern versehen, 🐛 Fehler melden, 💡 Verbesserungen vorschlagen.
**Und wenn Ihnen EU4 und seine DLC gefallen, kaufen Sie sie zur Unterstützung von Paradox Interactive.**
