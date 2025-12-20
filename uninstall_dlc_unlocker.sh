#!/bin/bash

# ============================================
# Europa Universalis IV - Восстановление оригинала
# ============================================

echo "============================================"
echo "EU4 DLC Unlocker - Удаление"
echo "============================================"
echo ""

EU4_PATH="/Users/$USER/Library/Application Support/Steam/steamapps/common/Europa Universalis IV"
EU4_APP="$EU4_PATH/eu4.app"

if [ ! -d "$EU4_APP" ]; then
    echo "Игра не найдена в стандартном пути."
    read -p "Укажите путь к eu4.app: " EU4_APP
fi

FRAMEWORKS_PATH="$EU4_APP/Contents/Frameworks"
STEAM_API="$FRAMEWORKS_PATH/libsteam_api.dylib"
BACKUP_PATH="$FRAMEWORKS_PATH/libsteam_api.dylib.backup"

if [ -f "$BACKUP_PATH" ]; then
    echo "Восстанавливаю оригинальный файл..."
    cp "$BACKUP_PATH" "$STEAM_API"
    rm -rf "$FRAMEWORKS_PATH/steam_settings"
    rm -f "$FRAMEWORKS_PATH/steam_appid.txt"
    echo "Готово! Оригинальные файлы восстановлены."
else
    echo "ОШИБКА: Бэкап не найден!"
    echo "Попробуйте проверить целостность файлов игры через Steam."
fi
