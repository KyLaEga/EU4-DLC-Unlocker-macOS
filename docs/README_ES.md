# EU4 DLC Unlocker para macOS

**Versión 4.0 — motor modular, CreamAPI v5.3.0.0, desbloqueo completo de DLC, multijugador compatible**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-macOS-blue.svg)](https://www.apple.com/macos/)
[![Game](https://img.shields.io/badge/Game-Europa%20Universalis%20IV-red.svg)](https://store.steampowered.com/app/236850/)

**🌍 Idiomas:** [English](../README.md) | [Русский](README_RU.md) | [Deutsch](README_DE.md) | [Français](README_FR.md) | [Español](README_ES.md) | [中文](README_ZH.md)

---

## ⚠️ Descargo de responsabilidad y aviso legal

> **Solo con fines educativos. Úsalo bajo tu propio riesgo.**
>
> - Debes **poseer una copia legítima de Europa Universalis IV en Steam**. Esta
>   herramienta **no descarga** ningún DLC — solo cambia el estado de propiedad
>   de los DLC cuyos archivos ya están presentes en el juego.
> - Usar un desbloqueador de DLC **infringe el Acuerdo de Suscriptor de Steam y
>   la EULA de Paradox**. En principio, esto puede provocar un **baneo/bloqueo
>   de cuenta (VAC)**. EU4 no tiene servidores protegidos por VAC, así que el
>   riesgo práctico es bajo, pero **no es nulo** — lo asumes tú.
> - Los autores no se hacen responsables de las consecuencias. Si disfrutas del
>   juego, **compra los DLC y apoya a Paradox Interactive.**

---

## 📖 Descripción

Un desbloqueador de DLC para **Europa Universalis IV** en **macOS**. Utiliza
[CreamAPI v5.3.0.0](https://cs.rin.ru/forum/viewtopic.php?f=29&t=70576) para
desbloquear la propiedad de DLC de un juego legítimamente adquirido en Steam.

### Cómo funciona

La herramienta instala la `libsteam_api.dylib` de CreamAPI (un proxy delante de
la biblioteca real de Steam) en `eu4.app/Contents/Frameworks/`, guarda el
original como `libsteam_api_o.dylib` y escribe un `cream_api.ini`. Al iniciar, el
juego pregunta a Steam qué DLC posees; CreamAPI responde «sí» por cada DLC
desbloqueado y reenvía todo lo demás al Steam real — por eso **el multijugador
sigue funcionando**.

Durante la instalación la herramienta **lee los metadatos `dlc/*.dlc` del propio
juego** y escribe una lista `[dlc]` explícita (`unlockall = false`). Es
deliberado: EU4 trae más de 130 paquetes de contenido, y `unlockall = true`
depende de la lista de DLC en *tiempo de ejecución* de Steam, que llega
**truncada** en juegos con muchos DLC — entonces solo se desbloquea una parte. La
lista construida a partir de tu propio contenido es **completa** y **funciona sin
conexión**. Se reconstruye en cada instalación. Si no se encuentran metadatos de
DLC, recurre a `unlockall = true`.

### Características

- ✅ **Multijugador compatible** (CreamAPI reenvía al Steam real)
- ✅ Desbloqueo completo de DLC — lista explícita a partir de tu propio contenido `dlc/` (sin truncar, funciona sin conexión), reconstruida en cada instalación
- ✅ Detección automática de la instalación de EU4 (disco interno **y** externos)
- ✅ Copia de seguridad segura del original; desinstalación limpia y reversible
- ✅ Comando `status` sin modificar — muestra qué hay instalado
- ✅ Binario **universal** verificado por suma de comprobación (nativo Intel **y** Apple Silicon)

---

## 📋 Requisitos

### Plataformas compatibles

| Plataforma   | Arquitectura          | Estado                  |
|--------------|-----------------------|-------------------------|
| macOS 10.13+ | Intel (x86_64)        | ✅ Nativo               |
| macOS 11+    | Apple Silicon (M1–M4) | ✅ Nativo (arm64)       |

La `libsteam_api.dylib` incluida es un binario **universal** (fat) con ambas
porciones `x86_64` y `arm64` — **no requiere Rosetta 2** en Apple Silicon.

### Prerrequisitos

- macOS 10.13 (High Sierra) o posterior
- Europa Universalis IV, legítimamente adquirido en Steam
- Los **archivos de contenido** DLC (deben estar ya presentes — la herramienta no los descarga)
- Recomendado: Xcode Command Line Tools (`xcode-select --install`) para `codesign`/`xattr`

---

## 🚀 Instalación

1. **Clona o descarga** el repositorio:
   ```bash
   git clone https://github.com/KyLaEga/EU4-DLC-Unlocker-macOS.git
   cd EU4-DLC-Unlocker-macOS
   ```

2. **Ejecuta el instalador:**
   ```bash
   ./install_dlc_unlocker.sh
   ```
   Una fina envoltura sobre `./bin/unlocker install eu4`. La herramienta
   verifica la biblioteca incluida, detecta la instalación de EU4, guarda el
   original, instala CreamAPI y vuelve a firmar el resultado para Gatekeeper.

3. **Inicia EU4 a través de Steam** (en línea la primera vez para resolver los DLC).

Si el juego está en una ubicación inusual, indica la ruta directamente:
```bash
./bin/unlocker install eu4 --path "/Volumes/My Drive/SteamLibrary/steamapps/common/Europa Universalis IV"
```

---

## 🛠️ Uso (CLI `unlocker`)

El único punto de entrada es `bin/unlocker`; los dos `*_dlc_unlocker.sh` son
finas envolturas para compatibilidad.

```text
./bin/unlocker install   [eu4]   # respaldar original + instalar CreamAPI
./bin/unlocker uninstall [eu4]   # restaurar la biblioteca original
./bin/unlocker status    [eu4]   # sin modificar: parche / respaldo / integridad
./bin/unlocker --help
./bin/unlocker --version

Opciones (tras el comando):
  --yes          No interactivo; asume «sí».
  --path DIR     Usar esta carpeta del juego en vez de la detección automática.
```

Comprobar el estado sin cambiar nada:
```bash
./bin/unlocker status eu4
```

---

## 🗑️ Desinstalación

```bash
./uninstall_dlc_unlocker.sh
# o: ./bin/unlocker uninstall eu4
```

Restaura `libsteam_api.dylib` desde la copia de seguridad, elimina
`cream_api.ini`, vuelve a firmar el original y limpia artefactos heredados.

> La opción de Steam **«Verificar integridad de los archivos del juego»**
> restaura silenciosamente la biblioteca original y quita el parche — es normal.
> Vuelve a ejecutar el instalador, o `status` para comprobar el estado.

---

## ❓ Preguntas frecuentes

### Los DLC muestran iconos de advertencia en el lanzador
Faltan los **archivos de contenido** DLC. La herramienta solo cambia el estado
de propiedad — el contenido debe estar en la carpeta `dlc/` del juego.

### ¿Dónde obtengo los archivos de contenido DLC?
El contenido DLC de Paradox es multiplataforma. Si lo tienes de una instalación
Windows/Linux, copia el contenido de la carpeta `dlc/` a tu instalación de Mac.

### «Verificar integridad» de Steam revirtió mi parche
Es normal — Steam reemplazó nuestra biblioteca por la original. Comprueba con
`./bin/unlocker status eu4` y reinstala.

### El juego no se inicia
Gatekeeper de macOS puede bloquear la biblioteca modificada. El instalador ya
quita el atributo de cuarentena y vuelve a firmar la dylib en ad-hoc; si copiaste
archivos manualmente:
```bash
xattr -dr com.apple.quarantine "/ruta/a/eu4.app"
codesign --force -s - "/ruta/a/eu4.app/Contents/Frameworks/libsteam_api.dylib"
```
Si faltan `codesign`/`xattr`, instala primero las Command Line Tools:
`xcode-select --install`. ¿Sigue sin funcionar? Desinstala e inténtalo de nuevo.

### ¿Es segura la biblioteca incluida?
La `libsteam_api.dylib` incluida es idéntica byte a byte al build oficial
CreamAPI *nonlog* de macOS y obtiene **0/64 en VirusTotal**. Puedes volver a
verificar la suma de comprobación tú mismo — ver [docs/SECURITY.md](SECURITY.md)
y [vendor/creamapi/VERSION.txt](../vendor/creamapi/VERSION.txt). (Nota: el
binario incrusta una ruta de build de origen en su install-name; es inofensivo y
es justo lo que la herramienta usa para detectar un parche instalado.)

### ¿Qué DLC se desbloquean?
**Todos los DLC cuyo contenido esté en tu carpeta `dlc/`.** El instalador lee
cada archivo `dlc/*.dlc`, recoge su appid de Steam y escribe el conjunto
completo en la sección `[dlc]` de `cream_api.ini`. ¿Añadiste contenido nuevo?
Vuelve a ejecutar el instalador y la lista se reconstruye. (Evitamos
`unlockall = true` a propósito: la lista en tiempo de ejecución de Steam llega
truncada en EU4 y solo desbloquearía una parte. `status eu4` indica cuántos DLC
cubre la configuración actual.)

### ¿Por qué `status` muestra menos DLC que carpetas tengo?
Es correcto, no falta nada. La carpeta `dlc/` contiene **paquetes de contenido**
(134 en el juego completo), pero Steam los vende como menos **compras** — una
compra suele agrupar varios paquetes (una expansión + su unit pack + su music
pack comparten un mismo appid de Steam). La herramienta concede propiedad **por
appid de Steam**, así que p. ej. ~75 appids cubren los 134 paquetes. `status`
muestra el número de appids; el launcher muestra todos los paquetes que
desbloquean.

### ¿Puedo desbloquear otro juego de Paradox?
El motor es independiente del juego. Para CK3, por ejemplo, basta con un nuevo
`games/<game>.conf` (appid + rutas de búsqueda) — sin cambiar el código. Hoy
solo se incluye EU4; ver [docs/CONTRIBUTING.md](CONTRIBUTING.md).

---

## 🔐 Seguridad e integridad

El instalador no se ejecuta si la SHA256 de la dylib incluida no coincide con
`vendor/creamapi/VERSION.txt` (protección contra manipulación/corrupción), y la
CI lo vuelve a verificar en cada push. Ver [docs/SECURITY.md](SECURITY.md).

## 🙏 Créditos

- [CreamAPI](https://cs.rin.ru/forum/viewtopic.php?f=29&t=70576) — la biblioteca de desbloqueo de DLC
- Inspirado en CreamInstaller (repo no longer available)

## 📜 Licencia

Bajo licencia MIT — ver [LICENSE](../LICENSE).

## ⭐ Apoyo

Si te ayudó: ⭐ marca el repo con estrella, 🐛 reporta errores, 💡 sugiere mejoras.
**Y si disfrutas de EU4 y sus DLC, cómpralos para apoyar a Paradox Interactive.**
