# EU4 DLC Unlocker pour macOS

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-macOS-blue.svg)](https://www.apple.com/macos/)
[![Game](https://img.shields.io/badge/Game-Europa%20Universalis%20IV-red.svg)](https://store.steampowered.com/app/236850/)

**🌍 Langues:** [English](../README.md) | [Русский](README_RU.md) | [Deutsch](README_DE.md) | [Français](README_FR.md) | [Español](README_ES.md) | [中文](README_ZH.md)

---

## ⚠️ Avertissement

> **Ce logiciel est fourni à des fins éducatives uniquement.**  
> Vous devez posséder une copie légitime d'Europa Universalis IV sur Steam pour utiliser cet outil.  
> Cet outil NE télécharge PAS de contenu DLC — il déverrouille uniquement les DLC déjà présents dans vos fichiers de jeu.  
> **Utilisez à vos propres risques.** Les auteurs ne sont pas responsables des conséquences.

---

## 📖 Description

Ceci est un débloqueur de DLC pour **Europa Universalis IV** sur **macOS**. Il utilise le [Goldberg Steam Emulator](https://github.com/inflation/goldberg_emulator) pour émuler la possession de DLC pour les jeux légitimement achetés sur Steam.

### Comment ça marche

L'outil remplace le `libsteam_api.dylib` original par une version modifiée qui indique au jeu que vous possédez tous les DLC. Les fichiers de contenu DLC réels doivent déjà être présents dans votre répertoire de jeu.

### Fonctionnalités

- ✅ Détection automatique du chemin d'installation d'EU4
- ✅ Sauvegarde automatique des fichiers originaux
- ✅ Scripts d'installation et de désinstallation simples
- ✅ Support des disques externes et des chemins d'installation personnalisés
- ✅ Plus de 60 DLC EU4 inclus dans la configuration

---

## 📋 Prérequis

- macOS 10.13 ou ultérieur
- Europa Universalis IV (légitimement acheté sur Steam)
- Fichiers de contenu DLC (doivent être obtenus séparément)

---

## 🚀 Installation

### Méthode 1: Utilisation du script d'installation (Recommandé)

1. **Téléchargez** ce dépôt ou clonez-le:
   ```bash
   git clone https://github.com/YOUR_USERNAME/EU4-DLC-Unlocker-macOS.git
   ```

2. **Ouvrez Terminal** et naviguez vers le dossier:
   ```bash
   cd EU4-DLC-Unlocker-macOS
   ```

3. **Exécutez l'installateur:**
   ```bash
   ./install_dlc_unlocker.sh
   ```

4. **Entrez le chemin** vers votre installation EU4 lorsque demandé.

5. **Lancez le jeu** via Steam.

### Méthode 2: Installation manuelle

1. **Trouvez votre installation EU4.** Emplacements courants:
   - `/Users/VOTRE_NOM/Library/Application Support/Steam/steamapps/common/Europa Universalis IV`
   - `/Volumes/VOTRE_DISQUE/SteamLibrary/steamapps/common/Europa Universalis IV`

2. **Localisez `libsteam_api.dylib`:**
   ```bash
   find "/chemin/vers/Europa Universalis IV" -name "libsteam_api.dylib"
   ```
   Généralement dans: `eu4.app/Contents/Frameworks/`

3. **Sauvegardez le fichier original:**
   ```bash
   cp "/chemin/vers/libsteam_api.dylib" "/chemin/vers/libsteam_api.dylib.backup"
   ```

4. **Copiez la bibliothèque modifiée:**
   ```bash
   cp libsteam_api.dylib "/chemin/vers/eu4.app/Contents/Frameworks/"
   ```

5. **Copiez le dossier steam_settings:**
   ```bash
   cp -r steam_settings "/chemin/vers/eu4.app/Contents/Frameworks/"
   cp steam_settings/steam_appid.txt "/chemin/vers/eu4.app/Contents/Frameworks/"
   ```

---

## 🗑️ Désinstallation

Exécutez le script de désinstallation:
```bash
./uninstall_dlc_unlocker.sh
```

Ou restaurez manuellement la sauvegarde:
```bash
cp "/chemin/vers/libsteam_api.dylib.backup" "/chemin/vers/libsteam_api.dylib"
```

---

## ❓ FAQ

### Les DLC affichent des icônes d'avertissement dans le lanceur

Cela signifie que les fichiers de contenu DLC sont manquants. Le débloqueur indique seulement au jeu que vous "possédez" les DLC — les fichiers de contenu réels doivent être présents dans le dossier `dlc/`.

### Où obtenir les fichiers DLC?

Les fichiers DLC pour les jeux Paradox sont multiplateformes (Windows/Mac/Linux). Si vous les avez d'une installation Windows, copiez simplement le contenu du dossier `dlc/` vers votre installation Mac.

### Le jeu ne se lance pas

1. Essayez de vérifier les fichiers du jeu via Steam
2. Assurez-vous d'utiliser le bon `libsteam_api.dylib` pour votre version de macOS
3. Exécutez le désinstallateur et réessayez

---

## 🙏 Remerciements

- [Goldberg Steam Emulator](https://github.com/Mr_Goldberg/goldberg_emulator) par Mr_Goldberg
- [Build macOS](https://github.com/inflation/goldberg_emulator) par inflation
- Inspiré par [CreamInstaller](https://github.com/pointfeev/CreamInstaller)

---

## 📜 Licence

Ce projet est sous licence MIT - voir le fichier [LICENSE](../LICENSE) pour plus de détails.
