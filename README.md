# EU4 DLC Unlocker for macOS

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-macOS-blue.svg)](https://www.apple.com/macos/)
[![Game](https://img.shields.io/badge/Game-Europa%20Universalis%20IV-red.svg)](https://store.steampowered.com/app/236850/)

**🌍 Languages:** [English](README.md) | [Русский](docs/README_RU.md) | [Deutsch](docs/README_DE.md) | [Français](docs/README_FR.md) | [Español](docs/README_ES.md) | [中文](docs/README_ZH.md)

---

## ⚠️ Disclaimer

> **This software is provided for educational purposes only.**  
> You must own a legitimate copy of Europa Universalis IV on Steam to use this tool.  
> This tool does NOT download any DLC content — it only unlocks DLCs that are already present in your game files.  
> **Use at your own risk.** The authors are not responsible for any consequences.

> **⚠️ IMPORTANT: This tool works only for SINGLE-PLAYER mode!**  
> Multiplayer is NOT supported. You cannot invite friends or join multiplayer sessions through Steam or the Paradox Launcher with the modified library.

---

## 📖 Description

This is a DLC unlocker for **Europa Universalis IV** on **macOS**. It uses the [Goldberg Steam Emulator](https://github.com/inflation/goldberg_emulator) to emulate DLC ownership for games legitimately owned on Steam.

### How it works

The tool replaces the original `libsteam_api.dylib` with a modified version that tells the game you own all DLCs. The actual DLC content files must already be present in your game directory.

### Features

- ✅ **Single-player only** (multiplayer not supported)
- ✅ Automatic detection of EU4 installation path
- ✅ Automatic backup of original files
- ✅ Easy installation and uninstallation scripts
- ✅ Support for external drives and custom installation paths
- ✅ All 60+ EU4 DLCs included in configuration

---

## 📋 Requirements

- macOS 10.13 or later
- Europa Universalis IV (legitimately owned on Steam)
- DLC content files (must be obtained separately)

---

## 🚀 Installation

### Method 1: Using the installer script (Recommended)

1. **Download** this repository or clone it:
   ```bash
   git clone https://github.com/KyLaEga/EU4-DLC-Unlocker-macOS.git
   ```

2. **Open Terminal** and navigate to the folder:
   ```bash
   cd EU4-DLC-Unlocker-macOS
   ```

3. **Run the installer:**
   ```bash
   ./install_dlc_unlocker.sh
   ```

4. **Enter the path** to your EU4 installation when prompted (or press Enter if it's in the default location).

5. **Launch the game** through Steam.

### Method 2: Manual installation

1. **Find your EU4 installation.** Default location:
   - `/Users/YOUR_NAME/Library/Application Support/Steam/steamapps/common/Europa Universalis IV`
   
   Alternative (external drive):
   - `/Volumes/YOUR_DRIVE/SteamLibrary/steamapps/common/Europa Universalis IV`

2. **Locate `libsteam_api.dylib`:**
   ```bash
   find "/path/to/Europa Universalis IV" -name "libsteam_api.dylib"
   ```
   Usually found in: `eu4.app/Contents/Frameworks/`

3. **Backup the original file:**
   ```bash
   cp "/path/to/libsteam_api.dylib" "/path/to/libsteam_api.dylib.backup"
   ```

4. **Copy the modified library:**
   ```bash
   cp libsteam_api.dylib "/path/to/eu4.app/Contents/Frameworks/"
   ```

5. **Copy the steam_settings folder:**
   ```bash
   cp -r steam_settings "/path/to/eu4.app/Contents/Frameworks/"
   cp steam_settings/steam_appid.txt "/path/to/eu4.app/Contents/Frameworks/"
   ```

---

## 🗑️ Uninstallation

Run the uninstaller script:
```bash
./uninstall_dlc_unlocker.sh
```

Or manually restore the backup:
```bash
cp "/path/to/libsteam_api.dylib.backup" "/path/to/libsteam_api.dylib"
```

---

## ❓ FAQ

### DLCs show warning icons in the launcher

This means the DLC content files are missing. The unlocker only tells the game you "own" the DLCs — the actual content files must be present in the `dlc/` folder.

### Where do I get DLC files?

DLC files for Paradox games are cross-platform (Windows/Mac/Linux). If you have them from a Windows installation, simply copy the `dlc/` folder contents to your Mac installation.

### The game doesn't launch

1. Try verifying game files through Steam
2. Make sure you're using the correct `libsteam_api.dylib` for your macOS version
3. Run the uninstaller and try again

### Which DLCs are supported?

All EU4 DLCs are included in the configuration file, including:
- Conquest of Paradise, Wealth of Nations, Res Publica
- Art of War, El Dorado, Common Sense
- The Cossacks, Mare Nostrum, Rights of Man
- Mandate of Heaven, Third Rome, Cradle of Civilization
- Rule Britannia, Dharma, Golden Century
- Emperor, Leviathan, Origins
- Lions of the North, Domination, King of Kings
- And all content packs!

---

## 🙏 Credits

- [Goldberg Steam Emulator](https://github.com/Mr_Goldberg/goldberg_emulator) by Mr_Goldberg
- [macOS build](https://github.com/inflation/goldberg_emulator) by inflation
- Inspired by [CreamInstaller](https://github.com/pointfeev/CreamInstaller)

---

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## ⭐ Support

If this tool helped you, please consider:
- ⭐ Starring this repository
- 🐛 Reporting issues
- 💡 Suggesting improvements

**Remember:** If you enjoy the game and DLCs, please support Paradox Interactive by purchasing them!
