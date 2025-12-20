#!/bin/bash

# ============================================
# Europa Universalis IV - DLC Unlocker для macOS
# Version 2.1
# ============================================

echo "============================================"
echo "EU4 DLC Unlocker Installer для macOS v2.1"
echo "============================================"
echo ""

# Получаем директорию скрипта
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

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

# Ищем в стандартных путях
for path in "${SEARCH_PATHS[@]}"; do
    # Используем glob expansion для путей с *
    for expanded_path in $path; do
        if [ -d "$expanded_path" ]; then
            echo "Проверяю: $expanded_path"
            FOUND=$(find_steam_api "$expanded_path")
            if [ -n "$FOUND" ]; then
                STEAM_API_PATH="$FOUND"
                break 2
            fi
        fi
    done
done

# Если не нашли, просим указать путь
if [ -z "$STEAM_API_PATH" ]; then
    echo ""
    echo "Игра не найдена в стандартных местах."
    echo "Укажите полный путь к папке Europa Universalis IV"
    echo "(например: /Users/$USER/Library/Application Support/Steam/steamapps/common/Europa Universalis IV)"
    echo ""
    read -p "Путь: " CUSTOM_PATH
    
    if [ -z "$CUSTOM_PATH" ]; then
        echo "Путь не указан. Выход."
        exit 1
    fi
    
    STEAM_API_PATH=$(find_steam_api "$CUSTOM_PATH")
    
    if [ -z "$STEAM_API_PATH" ]; then
        echo ""
        echo "ОШИБКА: libsteam_api.dylib не найден в указанной папке!"
        echo ""
        echo "Попробуйте выполнить команду для поиска вручную:"
        echo "find \"$CUSTOM_PATH\" -name \"libsteam_api.dylib\""
        exit 1
    fi
fi

# Определяем директорию где лежит steam_api
STEAM_API_DIR=$(dirname "$STEAM_API_PATH")

echo ""
echo "============================================"
echo "Найден файл: $STEAM_API_PATH"
echo "Директория: $STEAM_API_DIR"
echo "============================================"
echo ""

# Создаем бэкап
BACKUP_PATH="${STEAM_API_PATH}.backup"
if [ ! -f "$BACKUP_PATH" ]; then
    echo "Создаю бэкап оригинального файла..."
    cp "$STEAM_API_PATH" "$BACKUP_PATH"
    echo "Бэкап создан: $BACKUP_PATH"
else
    echo "Бэкап уже существует: $BACKUP_PATH"
fi

# Копируем модифицированную библиотеку
echo ""
echo "Копирую Goldberg Steam Emulator..."
cp "$SCRIPT_DIR/libsteam_api.dylib" "$STEAM_API_PATH"

# Копируем конфигурацию
echo "Копирую конфигурацию DLC..."
mkdir -p "$STEAM_API_DIR/steam_settings"
cp -r "$SCRIPT_DIR/steam_settings/"* "$STEAM_API_DIR/steam_settings/"

# Также копируем steam_appid.txt в ту же директорию
cp "$SCRIPT_DIR/steam_settings/steam_appid.txt" "$STEAM_API_DIR/"

# Создаём глобальную папку настроек Goldberg
GOLDBERG_SETTINGS="$HOME/Library/Application Support/Goldberg SteamEmu Saves/settings"
mkdir -p "$GOLDBERG_SETTINGS"
cp "$SCRIPT_DIR/steam_settings/DLC.txt" "$GOLDBERG_SETTINGS/"
echo "236850" > "$GOLDBERG_SETTINGS/steam_appid.txt"

echo ""
echo "============================================"
echo "УСТАНОВКА ЗАВЕРШЕНА!"
echo "============================================"
echo ""
echo "Файлы установлены в: $STEAM_API_DIR"
echo "Глобальные настройки: $GOLDBERG_SETTINGS"
echo ""
echo "Теперь запустите игру через Steam."
echo "Все DLC должны быть разблокированы."
echo ""
echo "ВАЖНО: Для работы требуется, чтобы базовая"
echo "версия игры была куплена в Steam."
echo ""
echo "Для восстановления оригинала выполните:"
echo "./uninstall_dlc_unlocker.sh"
echo ""
