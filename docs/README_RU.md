# EU4 DLC Unlocker для macOS

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-macOS-blue.svg)](https://www.apple.com/macos/)
[![Game](https://img.shields.io/badge/Game-Europa%20Universalis%20IV-red.svg)](https://store.steampowered.com/app/236850/)

**🌍 Языки:** [English](../README.md) | [Русский](README_RU.md) | [Deutsch](README_DE.md) | [Français](README_FR.md) | [Español](README_ES.md) | [中文](README_ZH.md)

---

## ⚠️ Отказ от ответственности

> **Данное программное обеспечение предоставляется исключительно в образовательных целях.**  
> Для использования этого инструмента у вас должна быть легальная копия Europa Universalis IV в Steam.  
> Этот инструмент НЕ скачивает контент DLC — он только разблокирует DLC, файлы которых уже присутствуют в папке игры.  
> **Используйте на свой страх и риск.** Авторы не несут ответственности за любые последствия.

> **⚠️ ВАЖНО: Этот инструмент работает только для ОДИНОЧНОЙ ИГРЫ!**  
> Мультиплеер НЕ поддерживается. Игра не сможет подключиться к серверам Steam с модифицированной библиотекой.

---

## 📖 Описание

Это разблокировщик DLC для **Europa Universalis IV** на **macOS**. Он использует [Goldberg Steam Emulator](https://github.com/inflation/goldberg_emulator) для эмуляции владения DLC для игр, легально приобретённых в Steam.

### Как это работает

Инструмент заменяет оригинальный `libsteam_api.dylib` на модифицированную версию, которая сообщает игре, что вы владеете всеми DLC. Фактические файлы контента DLC должны уже присутствовать в директории игры.

### Возможности

- ✅ **Только одиночная игра** (мультиплеер не поддерживается)
- ✅ Автоматическое определение пути установки EU4
- ✅ Автоматическое резервное копирование оригинальных файлов
- ✅ Простые скрипты установки и удаления
- ✅ Поддержка внешних дисков и нестандартных путей установки
- ✅ Все 60+ DLC для EU4 включены в конфигурацию

---

## 📋 Требования

- macOS 10.13 или новее
- Europa Universalis IV (легально приобретённая в Steam)
- Файлы контента DLC (необходимо получить отдельно)

---

## 🚀 Установка

### Способ 1: Использование скрипта установки (Рекомендуется)

1. **Скачайте** этот репозиторий или клонируйте его:
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

4. **Введите путь** к вашей установке EU4 при запросе (или нажмите Enter, если игра в стандартном расположении).

5. **Запустите игру** через Steam.

### Способ 2: Ручная установка

1. **Найдите вашу установку EU4.** Стандартное расположение:
   - `/Users/ВАШ_ПОЛЬЗОВАТЕЛЬ/Library/Application Support/Steam/steamapps/common/Europa Universalis IV`
   
   Альтернативно (внешний диск):
   - `/Volumes/ВАШ_ДИСК/SteamLibrary/steamapps/common/Europa Universalis IV`

2. **Найдите `libsteam_api.dylib`:**
   ```bash
   find "/путь/к/Europa Universalis IV" -name "libsteam_api.dylib"
   ```
   Обычно находится в: `eu4.app/Contents/Frameworks/`

3. **Создайте резервную копию оригинального файла:**
   ```bash
   cp "/путь/к/libsteam_api.dylib" "/путь/к/libsteam_api.dylib.backup"
   ```

4. **Скопируйте модифицированную библиотеку:**
   ```bash
   cp libsteam_api.dylib "/путь/к/eu4.app/Contents/Frameworks/"
   ```

5. **Скопируйте папку steam_settings:**
   ```bash
   cp -r steam_settings "/путь/к/eu4.app/Contents/Frameworks/"
   cp steam_settings/steam_appid.txt "/путь/к/eu4.app/Contents/Frameworks/"
   ```

---

## 🗑️ Удаление

Запустите скрипт удаления:
```bash
./uninstall_dlc_unlocker.sh
```

Или вручную восстановите резервную копию:
```bash
cp "/путь/к/libsteam_api.dylib.backup" "/путь/к/libsteam_api.dylib"
```

---

## ❓ Часто задаваемые вопросы

### DLC показывают предупреждающие иконки в лаунчере

Это означает, что файлы контента DLC отсутствуют. Разблокировщик только сообщает игре, что вы "владеете" DLC — фактические файлы контента должны присутствовать в папке `dlc/`.

### Где взять файлы DLC?

Файлы DLC для игр Paradox кроссплатформенные (Windows/Mac/Linux). Если у вас есть они от Windows-установки, просто скопируйте содержимое папки `dlc/` в вашу Mac-установку.

### Игра не запускается

1. Попробуйте проверить целостность файлов игры через Steam
2. Убедитесь, что используете правильный `libsteam_api.dylib` для вашей версии macOS
3. Запустите деинсталлятор и попробуйте снова

### Какие DLC поддерживаются?

Все DLC для EU4 включены в конфигурационный файл, включая:
- Conquest of Paradise, Wealth of Nations, Res Publica
- Art of War, El Dorado, Common Sense
- The Cossacks, Mare Nostrum, Rights of Man
- Mandate of Heaven, Third Rome, Cradle of Civilization
- Rule Britannia, Dharma, Golden Century
- Emperor, Leviathan, Origins
- Lions of the North, Domination, King of Kings
- И все контент-паки!

---

## 🙏 Благодарности

- [Goldberg Steam Emulator](https://github.com/Mr_Goldberg/goldberg_emulator) от Mr_Goldberg
- [macOS сборка](https://github.com/inflation/goldberg_emulator) от inflation
- Вдохновлено [CreamInstaller](https://github.com/pointfeev/CreamInstaller)

---

## 📜 Лицензия

Этот проект лицензирован под MIT License - см. файл [LICENSE](../LICENSE) для деталей.

---

## ⭐ Поддержка

Если этот инструмент помог вам, пожалуйста:
- ⭐ Поставьте звезду этому репозиторию
- 🐛 Сообщайте о проблемах
- 💡 Предлагайте улучшения

**Помните:** Если вам нравится игра и DLC, пожалуйста, поддержите Paradox Interactive, купив их!
