# EU4 DLC Unlocker pour macOS

**Version 4.0.2 — moteur modulaire, CreamAPI v5.3.0.0, déblocage complet des DLC, multijoueur pris en charge**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-macOS-blue.svg)](https://www.apple.com/macos/)
[![Game](https://img.shields.io/badge/Game-Europa%20Universalis%20IV-red.svg)](https://store.steampowered.com/app/236850/)

**🌍 Langues:** [English](../README.md) | [Русский](README_RU.md) | [Deutsch](README_DE.md) | [Français](README_FR.md) | [Español](README_ES.md) | [中文](README_ZH.md)

---

## ⚠️ Avertissement & mise en garde légale

> **À des fins éducatives uniquement. Utilisez à vos propres risques.**
>
> - Vous devez **posséder une copie légitime d'Europa Universalis IV sur Steam**.
>   Cet outil ne **télécharge aucun** DLC — il ne fait que changer l'état de
>   possession des DLC dont les fichiers sont déjà présents dans le jeu.
> - Utiliser un débloqueur de DLC **enfreint l'accord d'abonnement Steam et
>   l'EULA de Paradox**. En principe, cela peut entraîner un **bannissement /
>   blocage de compte (VAC)**. EU4 n'a pas de serveurs protégés par VAC, donc le
>   risque pratique est faible, mais **pas nul** — vous l'assumez vous-même.
> - Les auteurs ne sont pas responsables des conséquences. Si vous aimez le jeu,
>   **achetez les DLC et soutenez Paradox Interactive.**

---

## 📖 Description

Un débloqueur de DLC pour **Europa Universalis IV** sur **macOS**. Il utilise
[CreamAPI v5.3.0.0](https://cs.rin.ru/forum/viewtopic.php?f=29&t=70576) pour
débloquer la possession des DLC d'un jeu légitimement acheté sur Steam.

### Comment ça marche

L'outil installe la `libsteam_api.dylib` de CreamAPI (un proxy devant la vraie
bibliothèque Steam) dans `eu4.app/Contents/Frameworks/`, sauvegarde l'original
sous `libsteam_api_o.dylib` et écrit un `cream_api.ini`. Au lancement, le jeu
demande à Steam quels DLC vous possédez ; CreamAPI répond « oui » pour chaque DLC
débloqué tout en relayant le reste au vrai Steam — donc **le multijoueur continue
de fonctionner**.

À l'installation, l'outil **lit les métadonnées `dlc/*.dlc` du jeu** et écrit une
liste `[dlc]` explicite (`unlockall = false`). C'est volontaire : EU4 compte plus
de 130 packs de contenu, et `unlockall = true` s'appuie sur la liste de DLC
*d'exécution* de Steam, qui revient **tronquée** pour les jeux à nombreux DLC —
seule une partie serait alors débloquée. La liste construite à partir de votre
propre contenu est **complète** et **fonctionne hors ligne**. Elle est
reconstruite à chaque installation. Si aucune métadonnée DLC n'est trouvée,
l'outil revient à `unlockall = true`.

### Fonctionnalités

- ✅ **Multijoueur pris en charge** (CreamAPI relaie au vrai Steam)
- ✅ Déblocage complet des DLC — liste explicite construite depuis votre propre contenu `dlc/` (non tronquée, hors ligne), reconstruite à chaque installation
- ✅ Détection automatique de l'installation d'EU4 (disque interne **et** externes)
- ✅ Sauvegarde sûre de l'original ; désinstallation propre et réversible
- ✅ Commande `status` sans modification — montre ce qui est installé
- ✅ Binaire **universel** vérifié par somme de contrôle (natif Intel **et** Apple Silicon)

---

## 📋 Prérequis

### Plateformes prises en charge

| Plateforme   | Architecture          | Statut                  |
|--------------|-----------------------|-------------------------|
| macOS 10.13+ | Intel (x86_64)        | ✅ Natif                |
| macOS 11+    | Apple Silicon (M1–M4) | ✅ Natif (arm64)        |

La `libsteam_api.dylib` fournie est un binaire **universel** (fat) contenant les
deux tranches `x86_64` et `arm64` — **aucune Rosetta 2 requise** sur Apple Silicon.

### Conditions

- macOS 10.13 (High Sierra) ou ultérieur
- Europa Universalis IV, légitimement acheté sur Steam
- Les **fichiers de contenu** DLC (doivent déjà être présents — non téléchargés par l'outil)
- Recommandé : Xcode Command Line Tools (`xcode-select --install`) pour `codesign`/`xattr`

---

## 🚀 Installation

**En bref** — trois commandes, puis lancez le jeu :

```bash
git clone https://github.com/KyLaEga/EU4-DLC-Unlocker-macOS.git
cd EU4-DLC-Unlocker-macOS
./install_dlc_unlocker.sh
```

### Pas à pas

1. **Assurez-vous d'abord que le contenu DLC est en place.** Le dossier `dlc/`
   du jeu doit déjà contenir les packs de DLC (cet outil débloque la
   possession, il ne **télécharge pas** le contenu). S'il est vide, voir
   [Où obtenir les fichiers de contenu DLC ?](#où-obtenir-les-fichiers-de-contenu-dlc-) ci-dessous.

2. **Clonez ou téléchargez** le dépôt :
   ```bash
   git clone https://github.com/KyLaEga/EU4-DLC-Unlocker-macOS.git
   cd EU4-DLC-Unlocker-macOS
   ```

3. **Lancez l'installateur :**
   ```bash
   ./install_dlc_unlocker.sh
   ```
   Une fine surcouche de `./bin/unlocker install eu4`. L'outil vérifie la
   bibliothèque fournie, détecte l'installation d'EU4 (disque interne **et**
   lecteurs externes), sauvegarde l'original sous `libsteam_api_o.dylib`,
   installe CreamAPI, construit la liste DLC explicite à partir de votre `dlc/`
   et re-signe le résultat en ad-hoc pour Gatekeeper.

   Si le jeu se trouve à un emplacement inhabituel, indiquez le chemin directement :
   ```bash
   ./bin/unlocker install eu4 --path "/Volumes/My Drive/SteamLibrary/steamapps/common/Europa Universalis IV"
   ```

4. **Lancez EU4 via Steam.** Avec la liste `[dlc]` explicite, cela fonctionne
   aussi hors ligne. **Important :** si le jeu ou le Paradox Launcher étaient
   déjà ouverts, **quittez-les complètement (`⌘Q`)** puis relancez — CreamAPI ne
   lit `cream_api.ini` qu'une fois, au démarrage du processus.

### Vérifier

Vérifiez l'état du patch sans rien modifier :
```bash
./bin/unlocker status eu4
```
Vous devez voir :
```
[+] Patch state:     INSTALLED (CreamAPI active)
[+] Original backup: PRESENT (...libsteam_api_o.dylib)
[+] cream_api.ini:   PRESENT
[*]   unlockall = false; explicit [dlc] list (N DLC)
```
Ouvrez ensuite l'onglet **DLC** du Paradox Launcher — chaque DLC dont le contenu
est présent doit apparaître comme possédé (aucun bouton « Buy », aucun avertissement).

---

## 🛠️ Utilisation (CLI `unlocker`)

Le point d'entrée unique est `bin/unlocker` ; les deux `*_dlc_unlocker.sh` sont
de fines surcouches conservées pour la compatibilité.

```text
./bin/unlocker install   [eu4]   # sauvegarder l'original + installer CreamAPI
./bin/unlocker uninstall [eu4]   # restaurer la bibliothèque originale
./bin/unlocker status    [eu4]   # sans modification : patch / sauvegarde / intégrité
./bin/unlocker --help
./bin/unlocker --version

Options (après la commande) :
  --yes          Non interactif ; suppose « oui ».
  --path DIR     Utiliser ce dossier de jeu au lieu de la détection auto.
```

Vérifier l'état sans rien modifier :
```bash
./bin/unlocker status eu4
```

### Ce que fait `install` en coulisses

1. **Contrôle d'intégrité** — ne s'exécute que si la `libsteam_api.dylib` fournie
   correspond au SHA256 figé (protection anti-altération).
2. **Localiser le jeu** — développe les chemins de `games/eu4.conf` (avec espaces
   et lecteurs externes `/Volumes/*`) ; ou utilise `--path`.
3. **Sauvegarde** de l'original sous `libsteam_api_o.dylib` (n'écrase jamais une
   bonne sauvegarde existante).
4. **Installer CreamAPI** — copie la dylib proxy et revérifie le hash de la copie
   avant de re-signer.
5. **Construire `cream_api.ini`** — scanne `dlc/*/*.dlc`, collecte chaque
   `steam_id`, dédoublonne et écrit une liste `[dlc]` explicite avec
   `unlockall = false`.
6. **Durcissement macOS** — retire l'attribut de quarantaine (`xattr`) et re-signe
   la dylib en ad-hoc (`codesign -s -`) pour que Gatekeeper la charge.

`uninstall` annule les étapes 3–4 (restaurer la sauvegarde, supprimer
`cream_api.ini`, re-signer). `status` rapporte tout cela sans rien changer.

---

## 🗑️ Désinstallation

```bash
./uninstall_dlc_unlocker.sh
# ou : ./bin/unlocker uninstall eu4
```

Restaure `libsteam_api.dylib` depuis la sauvegarde, supprime `cream_api.ini`,
re-signe l'original et nettoie les artefacts hérités.

> La fonction Steam **« Vérifier l'intégrité des fichiers du jeu »** restaure
> silencieusement la bibliothèque originale et retire le patch — c'est normal.
> Relancez l'installateur, ou `status` pour vérifier l'état.

---

## ❓ FAQ

### Les DLC affichent des icônes d'avertissement dans le lanceur
Les **fichiers de contenu** des DLC sont manquants. L'outil ne change que l'état
de possession — le contenu doit être présent dans le dossier `dlc/` du jeu.

### Où obtenir les fichiers de contenu DLC ?
Cet outil **ne distribue ni ne télécharge** de DLC — vous apportez les vôtres. Le
contenu DLC de Paradox est multiplateforme : le plus simple est donc de **copier
le dossier `dlc/` depuis une machine où vous l'avez déjà** (p. ex. une
installation Windows/Linux qui vous appartient) vers votre installation Mac dans :
```
.../steamapps/common/Europa Universalis IV/dlc/
```
Chaque DLC est dans son propre sous-dossier (`dlc/dlcNNN_name/`) avec un fichier
de métadonnées `.dlc`, un `.zip` et une vignette. Après la copie, (re)lancez
l'installateur pour que la liste `[dlc]` soit reconstruite.

**Contenu reçu sous forme d'archive multipartie (`*.zip.001`, `*.zip.002`, …) ?**
Ces parties forment **une seule** archive découpée en morceaux — pas des zips
séparés. Réunissez-les et extrayez sur macOS ainsi (n'extrayez pas chaque partie
séparément) :
```bash
# 7-Zip gère le LZMA souvent utilisé par les packs d'EU4 et lit toutes les
# parties automatiquement si vous pointez vers la première :
brew install sevenzip
7zz x "DLC-….zip.001" -o"/chemin/vers/Europa Universalis IV"   # écrit l'arbre dlc/

# Sinon, concaténez d'abord les parties en un seul fichier (l'ordre compte) :
cat DLC-….zip.00{1,2,3,4} > DLC-….zip
7zz x DLC-….zip -o"/chemin/vers/Europa Universalis IV"
```
Pointez `-o` vers le dossier du jeu (le parent de `dlc/`) — l'archive contient
déjà un `dlc/` de premier niveau, donc l'extraction l'y fusionne.

### « Vérifier l'intégrité » de Steam a annulé mon patch
Normal — Steam a remplacé notre bibliothèque par l'originale. Vérifiez avec
`./bin/unlocker status eu4` puis réinstallez.

### Le jeu ne se lance pas
Gatekeeper de macOS peut bloquer la bibliothèque modifiée. L'installateur retire
déjà l'attribut de quarantaine et re-signe la dylib en ad-hoc ; si vous avez
copié des fichiers manuellement :
```bash
xattr -dr com.apple.quarantine "/chemin/vers/eu4.app"
codesign --force -s - "/chemin/vers/eu4.app/Contents/Frameworks/libsteam_api.dylib"
```
Si `codesign`/`xattr` manquent, installez d'abord les Command Line Tools :
`xcode-select --install`. Toujours bloqué ? Désinstallez et réessayez.

### La bibliothèque fournie est-elle sûre ?
La `libsteam_api.dylib` fournie est identique octet pour octet au build officiel
CreamAPI *nonlog* macOS et obtient **0/64 sur VirusTotal**. Vous pouvez
re-vérifier la somme de contrôle vous-même — voir [docs/SECURITY.md](SECURITY.md)
et [vendor/creamapi/VERSION.txt](../vendor/creamapi/VERSION.txt). (Note : le
binaire embarque un chemin de build amont dans son install-name ; c'est inoffensif
et c'est précisément ce que l'outil utilise pour détecter un patch installé.)

### Quels DLC sont débloqués ?
**Tous les DLC dont le contenu est présent dans votre dossier `dlc/`.**
L'installateur lit chaque fichier `dlc/*.dlc`, récupère son appid Steam et écrit
l'ensemble complet dans la section `[dlc]` de `cream_api.ini`. Du contenu
ajouté ? Relancez l'installateur, la liste est reconstruite. (Nous évitons
`unlockall = true` à dessein : la liste d'exécution de Steam est tronquée pour
EU4 et ne débloquerait qu'une partie. `status eu4` indique combien de DLC sont
couverts.)

### Pourquoi `status` affiche-t-il moins de DLC que de dossiers ?
C'est normal, rien ne manque. Le dossier `dlc/` contient des **packs de contenu**
(134 pour le jeu complet), mais Steam les vend en moins d'**achats** — un achat
regroupe souvent plusieurs packs (une extension + son unit pack + son music pack
partagent un même appid Steam). L'outil accorde la propriété **par appid Steam**,
donc p. ex. ~75 appids couvrent les 134 packs. `status` affiche le nombre
d'appids ; le launcher montre tous les packs qu'ils débloquent.

### Puis-je débloquer un autre jeu Paradox ?
Le moteur est indépendant du jeu. Pour CK3 par exemple, il suffit d'un nouveau
`games/<game>.conf` (appid + chemins de recherche) — sans changer le code. Seul
EU4 est livré aujourd'hui ; voir [docs/CONTRIBUTING.md](CONTRIBUTING.md).

---

## 📜 Historique des stratégies de déblocage

Le débloqueur macOS a utilisé trois stratégies différentes. Si vous avez utilisé
une ancienne version, voici ce qui a changé et pourquoi :

| Versions  | Stratégie                            | Multijoueur | Remarques |
|-----------|--------------------------------------|:-----------:|-----------|
| 1.x – 2.x | **Goldberg Steam Emulator**          | ❌ | *Émule* entièrement Steam hors ligne et remplace `libsteam_api.dylib` ; utilisait un dossier `steam_settings/` et `steam_appid.txt`. **Solo uniquement** — impossible d'inviter des amis ou de rejoindre des sessions. |
| 3.0       | **CreamAPI + `unlockall = true`**    | ✅ | Passage à un *proxy* CreamAPI qui relaie au vrai Steam — le multijoueur refonctionne. Les DLC venaient de la liste d'exécution de Steam. |
| 4.0.1+    | **CreamAPI + liste `[dlc]` explicite** | ✅ | La liste d'exécution de Steam est tronquée pour EU4 (~⅓ débloqué), donc l'installateur construit désormais la liste complète à partir de votre propre contenu `dlc/`. |

`uninstall` supprime toujours les anciens artefacts Goldberg (`steam_settings/`,
`steam_appid.txt`, `*.backup`) si vous effectuez une mise à niveau depuis une
installation 1.x–2.x.

---

## 🔐 Sécurité & intégrité

L'installateur refuse de s'exécuter si la SHA256 de la dylib fournie ne
correspond pas à `vendor/creamapi/VERSION.txt` (protection contre
altération/corruption), et la CI le revérifie à chaque push. Voir
[docs/SECURITY.md](SECURITY.md).

## 🙏 Remerciements

- [CreamAPI](https://cs.rin.ru/forum/viewtopic.php?f=29&t=70576) — la bibliothèque de déblocage de DLC
- Inspiré par CreamInstaller (repo no longer available)

## 📜 Licence

Sous licence MIT — voir [LICENSE](../LICENSE).

## ⭐ Soutien

Si cela vous a aidé : ⭐ ajoutez une étoile, 🐛 signalez les bugs, 💡 proposez des améliorations.
**Et si vous aimez EU4 et ses DLC, achetez-les pour soutenir Paradox Interactive.**
