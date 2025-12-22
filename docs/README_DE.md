# EU4 DLC Unlocker für macOS

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-macOS-blue.svg)](https://www.apple.com/macos/)
[![Game](https://img.shields.io/badge/Game-Europa%20Universalis%20IV-red.svg)](https://store.steampowered.com/app/236850/)

**🌍 Sprachen:** [English](../README.md) | [Русский](README_RU.md) | [Deutsch](README_DE.md) | [Français](README_FR.md) | [Español](README_ES.md) | [中文](README_ZH.md)

---

## ⚠️ Haftungsausschluss

> **⚠️ WICHTIG: Dieses Tool funktioniert nur im EINZELSPIELER-Modus!**  
> Multiplayer wird NICHT unterstützt. Sie können keine Freunde einladen oder Multiplayer-Sitzungen über Steam oder den Paradox Launcher mit der modifizierten Bibliothek beitreten.
>
> **🌐 Möchten Sie ONLINE spielen?** Verwenden Sie [CreamAPI](https://cs.rin.ru/forum/viewtopic.php?f=29&t=70576) — es unterstützt Multiplayer auf allen Plattformen (Windows, macOS, Linux).


> **Diese Software wird nur zu Bildungszwecken bereitgestellt.**  
> Sie müssen eine legitime Kopie von Europa Universalis IV auf Steam besitzen, um dieses Tool zu verwenden.  
> Dieses Tool lädt KEINE DLC-Inhalte herunter — es entsperrt nur DLCs, die bereits in Ihren Spieldateien vorhanden sind.  
> **Verwendung auf eigene Gefahr.** Die Autoren sind nicht für etwaige Konsequenzen verantwortlich.

---

## 📖 Beschreibung

Dies ist ein DLC-Entsperrer für **Europa Universalis IV** auf **macOS**. Er verwendet den [Goldberg Steam Emulator](https://github.com/inflation/goldberg_emulator), um den DLC-Besitz für legal auf Steam erworbene Spiele zu emulieren.

### Funktionsweise

Das Tool ersetzt die originale `libsteam_api.dylib` durch eine modifizierte Version, die dem Spiel mitteilt, dass Sie alle DLCs besitzen. Die eigentlichen DLC-Inhaltsdateien müssen bereits in Ihrem Spielverzeichnis vorhanden sein.

### Funktionen

- ✅ Automatische Erkennung des EU4-Installationspfads
- ✅ Automatische Sicherung der Originaldateien
- ✅ Einfache Installations- und Deinstallationsskripte
- ✅ Unterstützung für externe Laufwerke und benutzerdefinierte Installationspfade
- ✅ Alle 60+ EU4-DLCs in der Konfiguration enthalten

---

## 📋 Anforderungen

- macOS 10.13 oder neuer
- Europa Universalis IV (legal auf Steam erworben)
- DLC-Inhaltsdateien (müssen separat bezogen werden)

---

## 🚀 Installation

### Methode 1: Mit dem Installationsskript (Empfohlen)

1. **Laden Sie** dieses Repository herunter oder klonen Sie es:
   ```bash
   git clone https://github.com/YOUR_USERNAME/EU4-DLC-Unlocker-macOS.git
   ```

2. **Öffnen Sie Terminal** und navigieren Sie zum Ordner:
   ```bash
   cd EU4-DLC-Unlocker-macOS
   ```

3. **Führen Sie den Installer aus:**
   ```bash
   ./install_dlc_unlocker.sh
   ```

4. **Geben Sie den Pfad** zu Ihrer EU4-Installation ein, wenn Sie dazu aufgefordert werden.

5. **Starten Sie das Spiel** über Steam.

### Methode 2: Manuelle Installation

1. **Finden Sie Ihre EU4-Installation.** Übliche Speicherorte:
   - `/Users/IHR_NAME/Library/Application Support/Steam/steamapps/common/Europa Universalis IV`
   - `/Volumes/IHR_LAUFWERK/SteamLibrary/steamapps/common/Europa Universalis IV`

2. **Finden Sie `libsteam_api.dylib`:**
   ```bash
   find "/pfad/zu/Europa Universalis IV" -name "libsteam_api.dylib"
   ```
   Normalerweise in: `eu4.app/Contents/Frameworks/`

3. **Sichern Sie die Originaldatei:**
   ```bash
   cp "/pfad/zu/libsteam_api.dylib" "/pfad/zu/libsteam_api.dylib.backup"
   ```

4. **Kopieren Sie die modifizierte Bibliothek:**
   ```bash
   cp libsteam_api.dylib "/pfad/zu/eu4.app/Contents/Frameworks/"
   ```

5. **Kopieren Sie den steam_settings-Ordner:**
   ```bash
   cp -r steam_settings "/pfad/zu/eu4.app/Contents/Frameworks/"
   cp steam_settings/steam_appid.txt "/pfad/zu/eu4.app/Contents/Frameworks/"
   ```

---

## 🗑️ Deinstallation

Führen Sie das Deinstallationsskript aus:
```bash
./uninstall_dlc_unlocker.sh
```

Oder stellen Sie die Sicherung manuell wieder her:
```bash
cp "/pfad/zu/libsteam_api.dylib.backup" "/pfad/zu/libsteam_api.dylib"
```

---

## ❓ FAQ

### DLCs zeigen Warnsymbole im Launcher

Dies bedeutet, dass die DLC-Inhaltsdateien fehlen. Der Entsperrer teilt dem Spiel nur mit, dass Sie die DLCs "besitzen" — die eigentlichen Inhaltsdateien müssen im `dlc/`-Ordner vorhanden sein.

### Wo bekomme ich DLC-Dateien?

DLC-Dateien für Paradox-Spiele sind plattformübergreifend (Windows/Mac/Linux). Wenn Sie sie von einer Windows-Installation haben, kopieren Sie einfach den Inhalt des `dlc/`-Ordners in Ihre Mac-Installation.

### Das Spiel startet nicht

1. Versuchen Sie, die Spieldateien über Steam zu verifizieren
2. Stellen Sie sicher, dass Sie die richtige `libsteam_api.dylib` für Ihre macOS-Version verwenden
3. Führen Sie den Deinstaller aus und versuchen Sie es erneut

---

## 🙏 Danksagungen

- [Goldberg Steam Emulator](https://github.com/Mr_Goldberg/goldberg_emulator) von Mr_Goldberg
- [macOS-Build](https://github.com/inflation/goldberg_emulator) von inflation
- Inspiriert von [CreamInstaller](https://github.com/pointfeev/CreamInstaller)

---

## 📜 Lizenz

Dieses Projekt ist unter der MIT-Lizenz lizenziert - siehe die [LICENSE](../LICENSE)-Datei für Details.
