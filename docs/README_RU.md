# EU4 DLC Unlocker для macOS

**Версия 3.0 - Теперь с CreamAPI v5.3.0.0 и поддержкой мультиплеера!**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-macOS-blue.svg)](https://www.apple.com/macos/)
[![Game](https://img.shields.io/badge/Game-Europa%20Universalis%20IV-red.svg)](https://store.steampowered.com/app/236850/)

**🌍 Языки:** [English](../README.md) | [Русский](README_RU.md) | [Deutsch](README_DE.md) | [Français](README_FR.md) | [Español](README_ES.md) | [中文](README_ZH.md)

---

## ⚠️ Отказ от ответственности

> Для использования этого инструмента у вас должна быть легальная копия Europa Universalis IV в Steam.  
> Этот инструмент НЕ скачивает контент DLC — он только разблокирует DLC, файлы которых уже присутствуют в папке игры.  
> **Используйте на свой страх и риск.** Авторы не несут ответственности за любые последствия.

> **✅ Мультиплеер ПОДДЕРЖИВАЕТСЯ с CreamAPI!**  
> Вы можете приглашать друзей и присоединяться к мультиплеерным сессиям через Steam или Paradox Launcher.

---

## 📖 Описание

Это разблокировщик DLC для **Europa Universalis IV** на **macOS**. Использует [CreamAPI v5.3.0.0](https://cs.rin.ru/forum/viewtopic.php?f=29&t=70576) для разблокировки DLC в играх, легально приобретённых в Steam.

### Как это работает

Инструмент заменяет оригинальный `libsteam_api.dylib` на CreamAPI, который сообщает игре, что вы владеете всеми DLC. Файлы контента DLC должны уже присутствовать в папке игры.

### Возможности

- ✅ **Мультиплеер поддерживается!**
- ✅ Автоматическое определение пути установки EU4
- ✅ Автоматическое создание резервной копии
- ✅ Простые скрипты установки и удаления
- ✅ Поддержка внешних дисков и нестандартных путей
- ✅ Все 100+ DLC для EU4 включены в конфигурацию

---

## 📋 Требования

### Поддерживаемые платформы

| Платформа | Архитектура | Статус |
|-----------|-------------|--------|
| macOS 10.13+ | Intel (x86_64) | ✅ Поддерживается |
| macOS 11+ | Apple Silicon (M1/M2/M3) | ✅ Поддерживается (через Rosetta 2) |

### Необходимо

- macOS 10.13 (High Sierra) или новее
- Europa Universalis IV (легально приобретённая в Steam)
- Файлы контента DLC (необходимо получить отдельно)

---

## 🚀 Установка

### Способ 1: Через скрипт установки (Рекомендуется)

1. **Скачайте** репозиторий или клонируйте его:
   ```bash
   git clone https://github.com/KyLaEga/EU4-DLC-Unlocker-macOS.git
   ```

2. **Откройте Терминал** и перейдите в папку:
   ```bash
   cd EU4-DLC-Unlocker-macOS
   ```

3. **Запустите установщик:**
   ```bash
   ./install_dlc_unlocker.sh
   ```

4. **Укажите путь** к установке EU4 при запросе (или нажмите Enter, если игра в стандартном месте).

5. **Запустите игру** через Steam.

### Способ 2: Ручная установка

1. **Найдите папку EU4.** Стандартное расположение:
   - `/Users/ВАШ_ПОЛЬЗОВАТЕЛЬ/Library/Application Support/Steam/steamapps/common/Europa Universalis IV`
   
   На внешнем диске:
   - `/Volumes/ВАШ_ДИСК/SteamLibrary/steamapps/common/Europa Universalis IV`

2. **Найдите `libsteam_api.dylib`:**
   ```bash
   find "/путь/к/Europa Universalis IV" -name "libsteam_api.dylib"
   ```
   Обычно находится в: `eu4.app/Contents/Frameworks/`

3. **Создайте резервную копию (переименуйте в libsteam_api_o.dylib):**
   ```bash
   cp "/путь/к/libsteam_api.dylib" "/путь/к/libsteam_api_o.dylib"
   ```

4. **Скопируйте библиотеку CreamAPI:**
   ```bash
   cp libsteam_api.dylib "/путь/к/eu4.app/Contents/Frameworks/"
   ```

5. **Скопируйте конфигурацию cream_api.ini:**
   ```bash
   cp cream_api.ini "/путь/к/eu4.app/Contents/Frameworks/"
   ```

---

## 🗑️ Удаление

Запустите скрипт удаления:
```bash
./uninstall_dlc_unlocker.sh
```

Или вручную восстановите резервную копию:
```bash
cp "/путь/к/libsteam_api_o.dylib" "/путь/к/libsteam_api.dylib"
rm "/путь/к/cream_api.ini"
```

---

## ❓ FAQ

### DLC показывают предупреждения в лаунчере

Это означает, что файлы контента DLC отсутствуют. Разблокировщик только сообщает игре, что вы "владеете" DLC — сами файлы должны быть в папке `dlc/`.

### Где взять файлы DLC?

Файлы DLC для игр Paradox кроссплатформенные (Windows/Mac/Linux). Если они есть от Windows-установки, просто скопируйте содержимое папки `dlc/` в Mac-версию.

### Игра не запускается

1. Проверьте целостность файлов через Steam
2. Убедитесь, что используете правильный `libsteam_api.dylib`
3. Запустите скрипт удаления и попробуйте снова

### Какие DLC поддерживаются?

Все DLC для EU4 включены в конфигурацию:
- Conquest of Paradise, Wealth of Nations, Res Publica
- Art of War, El Dorado, Common Sense
- The Cossacks, Mare Nostrum, Rights of Man
- Mandate of Heaven, Third Rome, Cradle of Civilization
- Rule Britannia, Dharma, Golden Century
- Emperor, Leviathan, Origins
- Lions of the North, Domination, King of Kings
- Winds of Change
- И все контент-паки, музыкальные паки и юнит-паки!

---

## 🙏 Благодарности

- [CreamAPI](https://cs.rin.ru/forum/viewtopic.php?f=29&t=70576) от deadmau5
- Вдохновлено [CreamInstaller](https://github.com/pointfeev/CreamInstaller)

---

## 📜 Лицензия

Проект распространяется под лицензией MIT — см. файл [LICENSE](../LICENSE).

---

## ⭐ Поддержка

Если инструмент помог вам:
- ⭐ Поставьте звезду репозиторию
- 🐛 Сообщайте об ошибках
- 💡 Предлагайте улучшения

**Помните:** Если вам нравится игра и DLC, поддержите Paradox Interactive покупкой!
