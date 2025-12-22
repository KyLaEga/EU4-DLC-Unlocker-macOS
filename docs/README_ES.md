# EU4 DLC Unlocker para macOS

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-macOS-blue.svg)](https://www.apple.com/macos/)
[![Game](https://img.shields.io/badge/Game-Europa%20Universalis%20IV-red.svg)](https://store.steampowered.com/app/236850/)

**🌍 Idiomas:** [English](../README.md) | [Русский](README_RU.md) | [Deutsch](README_DE.md) | [Français](README_FR.md) | [Español](README_ES.md) | [中文](README_ZH.md)

---

## ⚠️ Descargo de responsabilidad

> **⚠️ IMPORTANTE: Esta herramienta solo funciona en modo UN JUGADOR!**  
> El multijugador NO está soportado. No puedes invitar amigos ni unirte a sesiones multijugador a través de Steam o el Paradox Launcher con la biblioteca modificada.
>
> **🌐 ¿Quieres jugar EN LÍNEA?** Usa [CreamAPI](https://cs.rin.ru/forum/viewtopic.php?f=29&t=70576) — soporta multijugador en todas las plataformas (Windows, macOS, Linux).


> **Este software se proporciona únicamente con fines educativos.**  
> Debes poseer una copia legítima de Europa Universalis IV en Steam para usar esta herramienta.  
> Esta herramienta NO descarga contenido DLC — solo desbloquea los DLC que ya están presentes en los archivos del juego.  
> **Úsalo bajo tu propio riesgo.** Los autores no son responsables de las consecuencias.

---

## 📖 Descripción

Este es un desbloqueador de DLC para **Europa Universalis IV** en **macOS**. Utiliza el [Goldberg Steam Emulator](https://github.com/inflation/goldberg_emulator) para emular la propiedad de DLC para juegos legítimamente adquiridos en Steam.

### Cómo funciona

La herramienta reemplaza el `libsteam_api.dylib` original con una versión modificada que le dice al juego que posees todos los DLC. Los archivos de contenido DLC reales ya deben estar presentes en tu directorio del juego.

### Características

- ✅ Detección automática de la ruta de instalación de EU4
- ✅ Copia de seguridad automática de los archivos originales
- ✅ Scripts de instalación y desinstalación sencillos
- ✅ Soporte para unidades externas y rutas de instalación personalizadas
- ✅ Más de 60 DLC de EU4 incluidos en la configuración

---

## 📋 Requisitos

- macOS 10.13 o posterior
- Europa Universalis IV (legítimamente adquirido en Steam)
- Archivos de contenido DLC (deben obtenerse por separado)

---

## 🚀 Instalación

### Método 1: Usando el script de instalación (Recomendado)

1. **Descarga** este repositorio o clónalo:
   ```bash
   git clone https://github.com/YOUR_USERNAME/EU4-DLC-Unlocker-macOS.git
   ```

2. **Abre Terminal** y navega a la carpeta:
   ```bash
   cd EU4-DLC-Unlocker-macOS
   ```

3. **Ejecuta el instalador:**
   ```bash
   ./install_dlc_unlocker.sh
   ```

4. **Ingresa la ruta** a tu instalación de EU4 cuando se te solicite.

5. **Inicia el juego** a través de Steam.

### Método 2: Instalación manual

1. **Encuentra tu instalación de EU4.** Ubicaciones comunes:
   - `/Users/TU_NOMBRE/Library/Application Support/Steam/steamapps/common/Europa Universalis IV`
   - `/Volumes/TU_DISCO/SteamLibrary/steamapps/common/Europa Universalis IV`

2. **Localiza `libsteam_api.dylib`:**
   ```bash
   find "/ruta/a/Europa Universalis IV" -name "libsteam_api.dylib"
   ```
   Generalmente en: `eu4.app/Contents/Frameworks/`

3. **Haz una copia de seguridad del archivo original:**
   ```bash
   cp "/ruta/a/libsteam_api.dylib" "/ruta/a/libsteam_api.dylib.backup"
   ```

4. **Copia la biblioteca modificada:**
   ```bash
   cp libsteam_api.dylib "/ruta/a/eu4.app/Contents/Frameworks/"
   ```

5. **Copia la carpeta steam_settings:**
   ```bash
   cp -r steam_settings "/ruta/a/eu4.app/Contents/Frameworks/"
   cp steam_settings/steam_appid.txt "/ruta/a/eu4.app/Contents/Frameworks/"
   ```

---

## 🗑️ Desinstalación

Ejecuta el script de desinstalación:
```bash
./uninstall_dlc_unlocker.sh
```

O restaura manualmente la copia de seguridad:
```bash
cp "/ruta/a/libsteam_api.dylib.backup" "/ruta/a/libsteam_api.dylib"
```

---

## ❓ Preguntas frecuentes

### Los DLC muestran iconos de advertencia en el lanzador

Esto significa que faltan los archivos de contenido DLC. El desbloqueador solo le dice al juego que "posees" los DLC — los archivos de contenido reales deben estar presentes en la carpeta `dlc/`.

### ¿Dónde obtengo los archivos DLC?

Los archivos DLC para juegos de Paradox son multiplataforma (Windows/Mac/Linux). Si los tienes de una instalación de Windows, simplemente copia el contenido de la carpeta `dlc/` a tu instalación de Mac.

### El juego no se inicia

1. Intenta verificar los archivos del juego a través de Steam
2. Asegúrate de usar el `libsteam_api.dylib` correcto para tu versión de macOS
3. Ejecuta el desinstalador e intenta de nuevo

---

## 🙏 Créditos

- [Goldberg Steam Emulator](https://github.com/Mr_Goldberg/goldberg_emulator) por Mr_Goldberg
- [Build para macOS](https://github.com/inflation/goldberg_emulator) por inflation
- Inspirado en [CreamInstaller](https://github.com/pointfeev/CreamInstaller)

---

## 📜 Licencia

Este proyecto está licenciado bajo la Licencia MIT - ver el archivo [LICENSE](../LICENSE) para más detalles.
