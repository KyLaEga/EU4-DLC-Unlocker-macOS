#!/bin/bash

# ============================================
# Europa Universalis IV - DLC Unlocker Uninstaller
# Version 3.0 - CreamAPI
# ============================================

echo "============================================"
echo "EU4 DLC Unlocker Uninstaller v3.0"
echo "============================================"
echo ""

# Функция для поиска libsteam_api.dylib
find_steam_api() {
    local search_path="$1"
    find "$search_path" -name "libsteam_api.dylib" -type f 2>/dev/null | head -1
}

# Стандартные пути для поиска
SEARCH_PATHS=(
    "/Users/$USER/Library/Application Support/Steam/steamapps/common/Europa Universalis IV"
    "/Volumes/*/SteamLibrary/steamapps/common/Europa Universalis IV"
    "/Volumes/*/Steam/steamapps/common/Europa Universalis IV"
)

STEAM_API_PATH=""

echo "Поиск игры Europa Universalis IV..."
echo ""

for path in "${SEARCH_PATHS[@]}"; do
    for expanded_path in $path; do
        if [ -d "$expanded_path" ]; then
            FOUND=$(find_steam_api "$expanded_path")
            if [ -n "$FOUND" ]; then
                STEAM_API_PATH="$FOUND"
                break 2
            fi
        fi
    done
done

if [ -z "$STEAM_API_PATH" ]; then
    echo "Игра не найдена в стандартных местах."
    read -p "Укажите путь к папке игры: " CUSTOM_PATH
    STEAM_API_PATH=$(find_steam_api "$CUSTOM_PATH")
fi

if [ -z "$STEAM_API_PATH" ]; then
    echo "ОШИБКА: libsteam_api.dylib не найден!"
    exit 1
fi

STEAM_API_DIR=$(dirname "$STEAM_API_PATH")

# Проверяем наличие бэкапа (CreamAPI использует libsteam_api_o.dylib)
BACKUP_PATH="${STEAM_API_DIR}/libsteam_api_o.dylib"
OLD_BACKUP_PATH="${STEAM_API_PATH}.backup"

if [ -f "$BACKUP_PATH" ]; then
    echo "Найден бэкап CreamAPI: $BACKUP_PATH"
    echo "Восстанавливаю оригинальный файл..."
    cp "$BACKUP_PATH" "$STEAM_API_PATH"
    rm "$BACKUP_PATH"
    rm -f "$STEAM_API_DIR/cream_api.ini"
    echo ""
    echo "✅ Оригинальная библиотека восстановлена!"
elif [ -f "$OLD_BACKUP_PATH" ]; then
    echo "Найден старый бэкап Goldberg: $OLD_BACKUP_PATH"
    echo "Восстанавливаю оригинальный файл..."
    cp "$OLD_BACKUP_PATH" "$STEAM_API_PATH"
    rm "$OLD_BACKUP_PATH"
    rm -rf "$STEAM_API_DIR/steam_settings"
    rm -f "$STEAM_API_DIR/steam_appid.txt"
    rm -f "$STEAM_API_DIR/cream_api.ini"
    echo ""
    echo "✅ Оригинальная библиотека восстановлена!"
else
    echo "ОШИБКА: Бэкап не найден!"
    echo "Возможно, DLC Unlocker не был установлен."
    exit 1
fi

echo ""
echo "Удаление завершено."
echo "Теперь игра будет работать в оригинальном режиме."
echo ""
