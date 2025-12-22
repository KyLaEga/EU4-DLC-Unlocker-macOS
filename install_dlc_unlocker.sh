#!/bin/bash

# ============================================
# Europa Universalis IV - DLC Unlocker для macOS
# Version 3.0 - CreamAPI v5.3.0.0
# Supports MULTIPLAYER!
# ============================================

echo "============================================"
echo "EU4 DLC Unlocker Installer для macOS v3.0"
echo "CreamAPI v5.3.0.0 - Multiplayer Supported!"
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

# Создаем бэкап (CreamAPI использует libsteam_api_o.dylib)
BACKUP_PATH="${STEAM_API_DIR}/libsteam_api_o.dylib"
if [ ! -f "$BACKUP_PATH" ]; then
    echo "Создаю бэкап оригинального файла..."
    cp "$STEAM_API_PATH" "$BACKUP_PATH"
    echo "Бэкап создан: $BACKUP_PATH"
else
    echo "Бэкап уже существует: $BACKUP_PATH"
fi

# Копируем CreamAPI библиотеку
echo ""
echo "Копирую CreamAPI v5.3.0.0..."
cp "$SCRIPT_DIR/libsteam_api.dylib" "$STEAM_API_PATH"

# Копируем конфигурацию cream_api.ini
echo "Копирую конфигурацию DLC..."
cp "$SCRIPT_DIR/cream_api.ini" "$STEAM_API_DIR/"

# Устанавливаем права
chmod 755 "$STEAM_API_PATH"
chmod 644 "$STEAM_API_DIR/cream_api.ini"

echo ""
echo "============================================"
echo "УСТАНОВКА ЗАВЕРШЕНА!"
echo "============================================"
echo ""
echo "CreamAPI v5.3.0.0 установлен в: $STEAM_API_DIR"
echo ""
echo "✅ Все DLC разблокированы"
echo "✅ Мультиплеер ПОДДЕРЖИВАЕТСЯ!"
echo ""
echo "ВАЖНО:"
echo "- Базовая версия игры должна быть куплена в Steam"
echo "- Файлы контента DLC должны быть в папке dlc/"
echo ""
echo "Для восстановления оригинала выполните:"
echo "./uninstall_dlc_unlocker.sh"
echo ""
